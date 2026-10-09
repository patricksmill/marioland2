#!/usr/bin/env python3
"""WP5 chunk classifier: evidence for 'code vs data vs tiles vs packed' verdicts.

Usage: classify.py BANK [BANK ...]   (BANK hex, e.g. 0C 18 1A 01)
Prints one line per chunk plus a context dump around each INCBIN line in main.asm.
"""
import re, sys
from collections import Counter

ROOT = '/home/pmill/sml2decomp'
ROM = open(f'{ROOT}/baserom.gb', 'rb').read()
MAIN_LINES = open(f'{ROOT}/main.asm').read().splitlines()

ILLEGAL = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}
# SM83 instruction lengths for a linear sweep (0 = illegal)
LEN = [1]*256
for op in range(256):
    if op in ILLEGAL:
        LEN[op] = 0
LEN[0xCB] = 2
for op, l in [(0x01,3),(0x08,3),(0x11,3),(0x21,3),(0x31,3),(0xC2,3),(0xC3,3),(0xC4,3),
              (0xCA,3),(0xCC,3),(0xCD,3),(0xD2,3),(0xD4,3),(0xDA,3),(0xDC,3),(0xEA,3),
              (0xFA,3)]:
    LEN[op] = l
for op in (0x06,0x0E,0x16,0x1E,0x26,0x2E,0x36,0x3E): LEN[op] = 2
for op in (0x10,0x18,0x20,0x28,0x30,0x38): LEN[op] = 2
for op in (0xE0,0xF0,0xE8,0xF8): LEN[op] = 2
LEN[0xC6]=LEN[0xCE]=LEN[0xD6]=LEN[0xDE]=LEN[0xE6]=LEN[0xEE]=LEN[0xF6]=LEN[0xFE]=2
END_OPS = {0xC9, 0xD9, 0xE9}  # ret, reti, jp hl

def sweep(data, off, end):
    """linear sweep; return (n_instr, stop_reason, last_mnemonicish)"""
    pc = off
    n = 0
    while pc < end:
        op = ROM[pc]
        if LEN[op] == 0:
            return n, f'illegal@+{pc-off}'
        pc += LEN[op]
        n += 1
    return n, 'end'

def tile_score(data):
    """best tile-clean fraction over offsets 0..15; clean tile: >=8/16 bytes in {00,FF} or monotone bitplane pair."""
    best, boff = 0.0, 0
    for off in range(16):
        seg = data[off:]
        tiles = len(seg) // 16
        if tiles == 0:
            continue
        clean = 0
        for t in range(tiles):
            blk = seg[t*16:(t+1)*16]
            if blk.count(0x00) + blk.count(0xFF) >= 8:
                clean += 1
        f = clean / tiles
        if f > best:
            best, boff = f, off
    return best, boff

def load_chunks(banks):
    cur = None
    out = {}
    for i, ln in enumerate(MAIN_LINES):
        m = re.match(r'SECTION "bank([0-9A-Fa-f]+)", ROMX, BANK\[\$([0-9A-Fa-f]+)\]', ln)
        if m:
            cur = int(m.group(2), 16)
            continue
        m = re.match(r'INCBIN "baserom\.gb", \$([0-9A-Fa-f]+), \$([0-9A-Fa-f]+) - \$([0-9A-Fa-f]+)', ln)
        if m and cur in banks:
            s, e = int(m.group(1), 16), int(m.group(2), 16)
            out.setdefault(cur, []).append((s, e, i))
    return out

banks = [int(a, 16) for a in sys.argv[1:]]
chunks = load_chunks(set(banks))

for bank in sorted(chunks):
    print(f'\n########## bank ${bank:02X} ##########')
    for s, e, line in sorted(chunks[bank]):
        data = ROM[s:e]
        c = Counter(data)
        n = len(data)
        ill = sum(c[b] for b in ILLEGAL if b in c)
        aa = c.get(0xAA, 0)
        zf = c.get(0x00, 0) + c.get(0xFF, 0)
        top = ' '.join(f'{v:02X}:{k}' for v, k in c.most_common(5))
        ni, stop = sweep(ROM, s, e)
        ts, toff = tile_score(data)
        print(f'{s:05X}-{e:05X} {n:6}B line{line+1:6} | ill {ill*100.0/n:4.1f}%  zf {zf*100.0/n:4.1f}%  aa {aa*100.0/n:4.1f}% | tiles {ts:.2f}@{toff:2} | sweep {ni:4} instr stop={stop:14} | top {top}')
        # context: 2 lines before, INCBIN, 2 lines after
        for j in range(max(0, line-2), min(len(MAIN_LINES), line+3)):
            mark = '>>' if j == line else '  '
            print(f'   {mark} {j+1:6}: {MAIN_LINES[j][:110]}')
        print()
