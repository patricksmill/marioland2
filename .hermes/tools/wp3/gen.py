#!/usr/bin/env python3
"""WP3 generator: replace bank-0 INCBIN chunks in home.asm with typed source.

Usage: gen.py [chunk_start_hex ...]   (no args = every chunk in SPEC)
Rewrites /home/pmill/sml2decomp/home.asm in place (and main.asm pointer refs).
"""
import re, sys, json
sys.path.insert(0, '/home/pmill/.hermes/cache/scratch/wp3')
import sm83 as D
from addrmap import addrmap

ROOT = '/home/pmill/sml2decomp'
ROM = D.ROM

# ---------------------------------------------------------------- symbols
import subprocess
subprocess.run('rgbasm -o /home/pmill/.hermes/cache/scratch/wp3/sym.o main.asm && '
               'rgblink -n /home/pmill/.hermes/cache/scratch/sml2.sym -o /dev/null '
               '/home/pmill/.hermes/cache/scratch/wp3/sym.o', shell=True, check=True, cwd=ROOT)
SYMS = {}
for ln in open('/home/pmill/.hermes/cache/scratch/sml2.sym'):
    m = re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)', ln)
    if m and '.' not in m[3]:
        SYMS.setdefault((int(m[1], 16), int(m[2], 16)), []).append(m[3])

# ---------------------------------------------------------------- spec
# segments: (kind, start, end, extra)
#   code                      extra: None
#   db  bytes                 extra: (per_line, comment)
#   dw  words                 extra: (per_line, comment)
#   jt  rst $28 jump table    extra: None
# LABELS: explicit names (override automatic naming)
# COMMENTS: addr -> comment line(s) emitted before the instruction at addr
U = 'unused filler'
SPEC = {
    0x0000: [('code', 0x0000, 0x0003), ('db', 0x0003, 0x0008, (8, U)),
             ('code', 0x0008, 0x000B), ('db', 0x000B, 0x0028, (16, U + ' (rst $10/$18/$20 included; never used)'))],
    0x0034: [('db', 0x0034, 0x0040, (16, U + ' (rst $30/$38 included; never used)'))],
    0x0043: [('db', 0x0043, 0x0048, (16, U)), ('code', 0x0048, 0x004B),
             ('db', 0x004B, 0x0050, (16, U)), ('code', 0x0050, 0x0053),
             ('db', 0x0053, 0x0058, (16, U)), ('code', 0x0058, 0x005B),
             ('db', 0x005B, 0x0100, (16, U + ' (joypad vector $0060 included; never enabled)'))],
    0x0153: [('code', 0x0153, 0x0154)],
    0x029F: [('code', 0x029F, 0x02AD)],
    0x02B0: [('jt', 0x02B0, 0x02F8), ('code', 0x02F8, 0x02FF)],
    0x033F: [('code', 0x033F, 0x0348)],
    0x03E1: [('db', 0x03E1, 0x03F1, (4, None))],
    0x04CA: [('code', 0x04CA, 0x04DD)],
    0x05C6: [('code', 0x05C6, 0x05D5)],
    0x0763: [('dw', 0x0763, 0x076B, (4, None))],
    0x07EA: [('db', 0x07EA, 0x07FE, (20, None)), ('code', 0x07FE, 0x0879)],
    0x08A1: [('code', 0x08A1, 0x08A2)],
    0x0DA4: [('db', 0x0DA4, 0x0DAF, (16, None))],
    0x1382: [('code', 0x1382, 0x13FE)],
    0x1415: [('code', 0x1415, 0x1432)],
    0x1446: [('code', 0x1446, 0x144B)],
    0x1488: [('code', 0x1488, 0x148D)],
    0x1559: [('code', 0x1559, 0x156B)],
    0x15AF: [('code', 0x15AF, 0x15B6)],
    0x16AF: [('code', 0x16AF, 0x16CC)],
    0x17DA: [('code', 0x17DA, 0x181C)],
    0x1D9A: [('code', 0x1D9A, 0x1DA4)],
    0x1EF5: [('code', 0x1EF5, 0x1EFA)],
    0x1FB1: [('code', 0x1FB1, 0x1FD2)],
    0x202F: [('code', 0x202F, 0x2062)],
    0x2097: [('code', 0x2097, 0x20A4)],
    0x2131: [('code', 0x2131, 0x214F)],
    0x2153: [('code', 0x2153, 0x2162)],
    0x2182: [('code', 0x2182, 0x218C)],
    0x2190: [('code', 0x2190, 0x2198)],
    0x21A7: [('code', 0x21A7, 0x21E5), ('db', 0x21E5, 0x21E8, (16, 'palettes'))],
    0x222E: [('code', 0x222E, 0x224E)],
    0x224E: [('code', 0x224E, 0x22B9)],
    0x22C4: [('code', 0x22C4, 0x22D5)],
    0x22DF: [('code', 0x22DF, 0x2323)],
    0x2357: [('code', 0x2357, 0x2359)],
    0x268B: [('db', 0x268B, 0x2699, (2, None)), ('dw', 0x2699, 0x26B5, (2, None)),
             ('dw', 0x26B5, 0x26C3, (1, None))],
    0x2874: [('db', 0x2874, 0x287E, (16, '"GAME OVER", $80-terminated'))],
    0x2974: [('code', 0x2974, 0x29BD), ('db', 0x29BD, 0x29CA, (16, '"GAME CLEARED", $80-terminated')),
             ('code', 0x29CA, 0x29DD)],
    0x2A63: [('code', 0x2A63, 0x2A96)],
    0x2AFF: [('code', 0x2AFF, 0x2B13)],
    0x2C39: [('code', 0x2C39, 0x2C61)],
    0x2C8D: [('code', 0x2C8D, 0x2CA3)],
    0x2D20: [('code', 0x2D20, 0x2D41)],
    0x2D4C: [('code', 0x2D4C, 0x2D7D)],
    0x2ED7: [('code', 0x2ED7, 0x2EDD)],
    0x3150: [('code', 0x3150, 0x315C)],
    0x31E0: [('code', 0x31E0, 0x31EF)],
    0x3439: [('db', 0x3439, 0x3451, (12, None))],
    0x34C2: [('code', 0x34C2, 0x34C9)],
    0x35EA: [('db', 0x35EA, 0x360A, (16, None)), ('db', 0x360A, 0x362A, (16, None))],
    0x372A: [('code', 0x372A, 0x3735)],
    0x377B: [('dw', 0x377B, 0x3873, (4, None))],
    0x3911: [('code', 0x3911, 0x3947), ('db', 0x3947, 0x3A00, (16, U))],
    0x3A3C: [('code', 0x3A3C, 0x3A50)],
    0x3AC8: [('code', 0x3AC8, 0x3ADC)],
    0x3D42: [('db', 0x3D42, 0x3E00, (16, U))],
    0x3FBD: [('db', 0x3FBD, 0x4000, (16, U))],
}

LABELS = {
    0x033F: 'UnknownCall_0x033F', 0x02F8: 'UnknownCall_0x02F8',
    0x07FE: 'UnknownCall_0x07FE', 0x0804: 'UnknownCall_0x0804', 0x0816: 'UnknownCall_0x0816',
    0x1382: 'UnknownCall_0x1382', 0x16AF: 'UnknownCall_0x16AF', 0x17DA: 'UnknownCall_0x17DA',
    0x1EF5: 'UnknownCall_0x1EF5', 0x1FB1: 'UnknownCall_0x1FB1', 0x202F: 'UnknownCall_0x202F',
    0x2058: 'OAMDMARoutine', 0x2097: 'UnknownCall_0x2097', 0x2098: 'UnknownCall_0x2098',
    0x22DF: 'UnknownCall_0x22DF', 0x2A63: 'UnknownCall_0x2A63', 0x2AFF: 'UnknownCall_0x2AFF',
    0x2C39: 'UnknownCall_0x2C39', 0x2C4D: 'UnknownCall_0x2C4D', 0x2C8D: 'UnknownCall_0x2C8D',
    0x2D20: 'UnknownCall_0x2D20', 0x2D2B: 'UnknownCall_0x2D2B', 0x2D36: 'UnknownCall_0x2D36',
    0x2D4C: 'UnknownCall_0x2D4C', 0x3A3C: 'UnknownCall_0x3A3C', 0x3AC8: 'UnknownCall_0x3AC8',
    0x372A: 'STATInterrupt',
    0x21E5: 'UnknownData_0x21E5', 0x29BD: 'UnknownData_0x29BD', 0x2699: 'UnknownData_0x2699',
    0x26B5: 'UnknownData_0x26B5', 0x360A: 'UnknownData_0x360A', 0x3947: 'UnknownData_0x3947',
}
LABEL_COMMENTS = {
    0x029F: 'soft reset (A+B+Start+Select held)',
    0x2058: 'copied to $FFA0 by Init and called from VBlank (runs from HRAM)',
    0x372A: 'LCD STAT interrupt handler (vector $0048)',
    0x0153: 'serial interrupt handler (vector $0058)',
    0x0347: 'timer interrupt handler (vector $0050)',
    0x033F: 'copies bytes from de to hl until a $FF terminator',
    0x02F8: 'advance to the next game state ($FF9B)',
    0x02FE: 'game state no-op handler',
    0x02B0: 'rst $28 jump table for UnknownCall_0x02AD, indexed by game state $FF9B',
    0x03E1: 'fade palettes (BGP, OBP0, OBP1, pad), indexed by ($A266 & $C0) >> 4',
    0x0763: 'GFX source pointers, indexed by ($A2D2 >> 4) * 2',
    0x07EA: 'window/HUD tile row, 20 tiles copied to $9C00 by UnknownCall_0x07DB',
    0x268B: 'ROM bank pairs, indexed by $A22D * 2',
    0x2699: 'GFX source pointer pairs, indexed by $A22D * 4 (UnknownData_0x2699 + 2 = second word)',
    0x26B5: 'pointers, indexed by $A22D * 2',
    0x3439: 'indexed by $A259',
    0x35EA: 'per-level byte, indexed by sCurLevel',
    0x360A: 'per-level byte, indexed by sCurLevel (stored to $A2D2)',
    0x377B: 'per-level 8-byte records (copied to $A800), indexed by sCurLevel * 8',
}
VECTOR_COMMENTS = {
    0x0000: 'rst $00', 0x0008: 'rst $08', 0x0048: 'LCD STAT interrupt vector',
    0x0050: 'timer interrupt vector', 0x0058: 'serial interrupt vector',
}
DATA_LABELS = {a for a, n in LABELS.items() if n.startswith('UnknownData_')} | {0x2058}
BANKSWITCH = {0xA24E, 0x2100}


def bank0_label(a):
    names = SYMS.get((0, a), [])
    names = [n for n in names if not n.startswith('UnknownData_')] or names
    return names[0] if names else None


def main():
    only = {int(x, 16) for x in sys.argv[1:]} or set(SPEC)
    home = open(f'{ROOT}/home.asm').read().split('\n')
    amap = addrmap()
    # chunk -> INCBIN line index
    chunk_line = {}
    for i, l in enumerate(home):
        m = re.match(r'INCBIN "baserom.gb", \$([0-9A-F]{4}), \$([0-9A-F]{4})', l)
        if m and int(m[1], 16) in only:
            s, e = int(m[1], 16), int(m[2], 16)
            segs = SPEC[s]
            assert segs[0][1] == s and segs[-1][2] == e, hex(s)
            for a, b in zip(segs, segs[1:]):
                assert a[2] == b[1], hex(s)
            chunk_line[s] = i
    assert set(chunk_line) == only, only - set(chunk_line)
    in_new = lambda a: any(segs[0][1] <= a < segs[-1][2] for s in only for segs in [SPEC[s]])
    CODE_STARTS = {seg[1] for s in only for seg in SPEC[s] if seg[0] == 'code'}

    # ---------------- collect labels needed
    need = {}  # addr -> name

    def want(a, kind):
        if a >= 0x4000:
            return
        if a in LABELS:
            need[a] = LABELS[a]
            return
        ex = bank0_label(a)
        # an existing UnknownData_ label at the start of a converted *code* chunk is dropped
        if ex and not (ex.startswith('UnknownData_') and a in CODE_STARTS):
            return
        pref = {'call': 'UnknownCall', 'jp': 'UnknownJump', 'jr': 'UnknownRJump',
                'jt': 'UnknownJump'}[kind]
        rank = ['UnknownCall', 'UnknownJump', 'UnknownRJump']
        old = need.get(a)
        if old is None or (old.split('_0x')[0] in rank and rank.index(pref) < rank.index(old.split('_0x')[0])):
            need[a] = f'{pref}_0x{a:04X}'

    for s in only:
        for kind, a, b, *_ in SPEC[s]:
            for addr, name in LABELS.items():
                if a <= addr < b:
                    need[addr] = name
            if kind == 'code':
                for pc, n, m, info in D.linear(a, b):
                    assert m is not None, f'illegal opcode in code at {pc:04X}'
                    if 'target' in info:
                        want(info['target'], info['kind'])
                assert pc + n == b, f'code segment overruns at {a:04X}-{b:04X}'
            if kind == 'jt':
                for p in range(a, b, 2):
                    want(ROM[p] | ROM[p + 1] << 8, 'jt')

    # existing data labels at start of data chunks are kept: make sure they are emitted
    def labels_at(a):
        out = []
        for n in SYMS.get((0, a), []):
            if n.startswith('UnknownData_') and a in CODE_STARTS:
                continue
            out.append(n)
        if a in need and need[a] not in out:
            out.append(need[a])
        return out

    # every label inside a converted chunk must fall on an instruction / data-segment start
    bounds = set()
    for s in only:
        for kind, a, b, *_ in SPEC[s]:
            bounds.add(a)
            if kind == 'code':
                bounds |= {pc for pc, *_ in D.linear(a, b)}
    for a, nm in need.items():
        if in_new(a) and a not in bounds:
            print(f'!! label {nm} at ${a:04X} is not on a boundary', file=sys.stderr)
            sys.exit(3)

    # ---------------- render
    def lab(a, kind=None, bank=None):
        if a < 0x4000:
            if a in need:
                return need[a]
            n = bank0_label(a)
            if n:
                return n
            return f'${a:04X}'
        if bank is not None and bank != 0:
            names = SYMS.get((bank, a))
            if names:
                return names[0]
        return f'${a:04X}'

    def render_code(a, b):
        out = []
        bank = None
        insts = D.linear(a, b)
        for idx, (pc, n, m, info) in enumerate(insts):
            emit_labels(out, pc, first=(pc == a))
            if pc in VECTOR_COMMENTS:
                out.append(f';{VECTOR_COMMENTS[pc]}')
            line = m
            if 'target' in info:
                tl = lab(info['target'], info['kind'], bank)
                line = m.rsplit(' ', 1)[0] + ' ' + tl
            op = ROM[pc]
            # alu immediates: add/adc/sub/sbc decimal (project style)
            if op in (0xC6, 0xCE, 0xD6, 0xDE):
                line = f"{['add', 'adc', 'sub', 'sbc'][(op - 0xC6) // 8]} {ROM[pc + 1]}"
            if op == 0x21:
                v = ROM[pc + 1] | ROM[pc + 2] << 8
                if v in DATA_LABELS:
                    line = f'ld hl, {LABELS[v]}'
            # bank tracking
            if op == 0x3E:
                nxt = insts[idx + 1] if idx + 1 < len(insts) else None
                if nxt and nxt[3].get('mem') in BANKSWITCH:
                    line += ' ;prepare bank switch'
            if op == 0xEA and info.get('mem') == 0x2100:
                # ld a, N / [ld [$A24E], a /] ld [$2100], a
                bank = None
                for back in (1, 2):
                    if idx >= back:
                        q = insts[idx - back][0]
                        if ROM[q] == 0x3E:
                            bank = ROM[q + 1]
                            break
                        if not (ROM[q] == 0xEA and insts[idx - back][3].get('mem') == 0xA24E):
                            break
            out.append('\t' + line)
        return out

    def emit_labels(out, pc, first=False):
        names = labels_at(pc)
        if not names:
            return
        if not first:
            out.append('')
        for nm in names:
            c = LABEL_COMMENTS.get(pc)
            out.append(f'{nm}:' + (f' ;{c}' if c and nm == names[-1] else ''))

    def render_data(kind, a, b, per, comment):
        out = []
        p = a
        emit_labels(out, a, first=True)
        if comment:
            out.append(f';{comment}')
        if kind == 'db':
            while p < b:
                q = min(b, p + per)
                out.append('\tdb ' + ', '.join(f'${x:02X}' for x in ROM[p:q]))
                p = q
        else:
            assert (b - a) % 2 == 0
            while p < b:
                q = min(b, p + 2 * per)
                ws = [ROM[i] | ROM[i + 1] << 8 for i in range(p, q, 2)]
                out.append('\tdw ' + ', '.join(f'${w:04X}' for w in ws))
                p = q
        return out

    def render_jt(a, b):
        out = []
        emit_labels(out, a, first=True)
        for i, p in enumerate(range(a, b, 2)):
            t = ROM[p] | ROM[p + 1] << 8
            out.append(f'\tdw {lab(t)} ;${i:02X}')
        return out

    blocks = {}
    for s in only:
        out = []
        for seg in SPEC[s]:
            kind, a, b = seg[:3]
            if out:
                out.append('')
            if kind == 'code':
                out += render_code(a, b)
            elif kind == 'jt':
                out += render_jt(a, b)
            else:
                out += render_data(kind, a, b, *seg[3])
        blocks[s] = out

    # ---------------- insertions into untouched source
    inserts = {}  # line index -> [label lines]
    rev = {}
    for ln, ad in sorted(amap.items()):
        rev.setdefault(ad, ln)  # first line with that address
    for a, nm in sorted(need.items()):
        if in_new(a):
            continue
        if nm in sum(SYMS.values(), []):
            continue
        ln = rev.get(a)
        if ln is None:
            print(f'!! no line boundary at ${a:04X} for {nm}', file=sys.stderr)
            sys.exit(3)
        # skip forward past blank lines so the label sits next to its code
        i = ln - 1
        while home[i].strip() == '' or home[i].lstrip().startswith(';'):
            i += 1
        if amap.get(i + 1) != a:
            print(f'!! boundary drift at ${a:04X}', file=sys.stderr)
            sys.exit(3)
        c = LABEL_COMMENTS.get(a)
        lst = inserts.setdefault(i, [])
        if not lst and home[i - 1].strip() != '' and not re.match(r'^\w+:', home[i - 1]):
            lst.append('')
        lst.append(f'{nm}:' + (f' ;{c}' if c else ''))

    # ---------------- apply (bottom-up)
    edits = []  # (start, end, newlines)
    for s, i in chunk_line.items():
        j = i
        carried = []
        while j - 1 >= 0 and re.match(r'^\w+:\s*(;.*)?$', home[j - 1]):
            j -= 1
            mm = re.match(r'^(\w+):\s*;\s*(.*)$', home[j])
            if mm:
                carried.append(mm[2])
        blk = blocks[s]
        if carried and s not in LABEL_COMMENTS:
            # attach the old comment to the first label line in the block
            for k, l in enumerate(blk):
                if re.match(r'^\w+:$', l):
                    blk[k] = l + ' ;' + '; '.join(carried)
                    break
        edits.append((j, i + 1, blk))
    for i, labs in inserts.items():
        edits.append((i, i, labs))
    edits.sort(key=lambda e: (e[0], e[1]), reverse=True)
    for a, b, new in edits:
        home[a:b] = new
    open(f'{ROOT}/home.asm', 'w').write('\n'.join(home))
    print(f'converted {len(only)} chunks, {sum(SPEC[s][-1][2] - s for s in only)} bytes; '
          f'{len(inserts)} label insertions')
    for i, labs in sorted(inserts.items()):
        print('  insert', [l for l in labs if l])


if __name__ == '__main__':
    main()
