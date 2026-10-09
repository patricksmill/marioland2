#!/usr/bin/env python3
"""WP5: disassemble a banked ROM chunk with sym labels; print targets.

Usage:
  disctx.py BANK START END [--max N]     (hex addrs, e.g. 18 60441 60444)
  disctx.py --chunks BANK                (all raw chunks of BANK from main.asm)
"""
import re, sys
sys.path.insert(0, '/home/pmill/sml2decomp/.hermes/tools/wp3')
import sm83 as D

SYMF = '/home/pmill/.hermes/cache/scratch/sml2.sym'
SYMS = {}
for ln in open(SYMF):
    m = re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)', ln)
    if m:
        SYMS.setdefault((int(m[1], 16), int(m[2], 16)), []).append(m[3])

MAIN = open('/home/pmill/sml2decomp/main.asm').read().splitlines()

def lab(bank):
    def f(a):
        names = SYMS.get((bank if a >= 0x4000 else 0, a), [])
        return names[0] if names else f'${a:04X}'
    return f

def dis(bank, s, e):
    out = []
    targets = []
    pc = s
    while pc < e:
        n, m, info = D.decode(pc, lab(bank))
        bs = ' '.join(f'{b:02X}' for b in D.ROM[pc:pc+n])
        nm = SYMS.get((bank, pc), [])
        lbl = f'   <{"|".join(nm)}' if nm else ''
        tag = ' ** ILLEGAL **' if m is None else ''
        out.append(f'${pc:05X}: {bs:<11} {m or "$%02X (illegal)" % D.ROM[pc]}{lbl}{tag}')
        if 'target' in info:
            t = info['target']
            rom = bank * 0x4000 + (t - 0x4000) if t >= 0x4000 else t
            targets.append(f'{info["kind"]} -> ${t:04X} (ROM ${rom:05X})')
        pc += n
    if targets:
        out.append('   targets: ' + '; '.join(targets))
    return '\n'.join(out)

def chunks_of(bank):
    cur = None
    out = []
    for i, ln in enumerate(MAIN):
        m = re.match(r'SECTION "bank([0-9A-Fa-f]+)", ROMX, BANK\[\$([0-9A-Fa-f]+)\]', ln)
        if m:
            cur = int(m.group(2), 16); continue
        m = re.match(r'INCBIN "baserom\.gb", \$([0-9A-Fa-f]+), \$([0-9A-Fa-f]+) - \$([0-9A-Fa-f]+)', ln)
        if m and cur == bank:
            out.append((int(m.group(1), 16), int(m.group(2), 16), i + 1))
    return out

if __name__ == '__main__':
    if sys.argv[1] == '--chunks':
        bank = int(sys.argv[2], 16)
        for s, e, line in sorted(chunks_of(bank)):
            print(f'===== chunk ${s:05X}-${e:05X} ({e-s} B) main.asm line {line} =====')
            if e - s <= 260:
                print(dis(bank, s, e))
            else:
                print(dis(bank, s, s + 128))
                print(f'   ... ({e-s} B total)')
            print()
    else:
        bank, s, e = int(sys.argv[1], 16), int(sys.argv[2], 16), int(sys.argv[3], 16)
        mx = 100000
        if '--max' in sys.argv:
            mx = int(sys.argv[sys.argv.index('--max') + 1])
        print(dis(bank, s, min(e, s + mx)))
