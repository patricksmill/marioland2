#!/usr/bin/env python3
"""Scan baserom.gb for ALL 16-bit occurrences of given WRAM addresses ($Axxx).

Usage: python3 wramrefs.py A2C0 A2C1 ...

Classifies the preceding byte as a known SM83 opcode where possible
(EA=write, FA=read, 21=ld hl, ...) so real code references can be told apart
from byte pairs in data sections. Before trusting a "no writer/caller" claim,
check whether the hit region has labels/references (data sections give false
positives; also see romrefs.py for call/jp/jr scanning).
"""
import sys

rom = open('baserom.gb', 'rb').read()
BANK = 0x4000

OPS = {
    0xEA: 'ld [dir],a (WRITE)', 0xFA: 'ld a,[dir] (READ)', 0x21: 'ld hl,dir',
    0x01: 'ld bc,dir', 0x11: 'ld de,dir', 0xC3: 'jp', 0xCD: 'call', 0x08: 'ld [dir],sp',
}


def cpu(off):
    b = off // BANK
    return (off % BANK) + (0x4000 if b else 0)


for arg in sys.argv[1:]:
    target = int(arg, 16)
    lo, hi = target & 0xFF, (target >> 8) & 0xFF
    hits = []
    for i in range(len(rom) - 2):
        if rom[i+1] == lo and rom[i+2] == hi:
            hits.append((i, rom[i]))
    print(f'--- ${arg}: {len(hits)} raw 16-bit occurrences ---')
    for i, op in hits:
        kind = OPS.get(op, f'op ${op:02X}')
        print(f'  ROM ${i:05X} (bank {i//BANK}, cpu ${cpu(i):04X}) op ${op:02X} [{kind}]')
