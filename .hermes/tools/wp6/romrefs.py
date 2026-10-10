#!/usr/bin/env python3
"""Scan baserom.gb for call/jp (absolute, incl. conditionals) and same-bank jr
references to given ROM0 addresses (hex args). CPU-address-correct: maps file
offset -> bank/cpu window so jr math is not off by a bank.

Usage: python3 romrefs.py 0816 0F0B ...
"""
import sys

rom = open('baserom.gb', 'rb').read()
BANK = 0x4000


def cpu(off):
    b = off // BANK
    return (off % BANK) + (0x4000 if b else 0)


for arg in sys.argv[1:]:
    target = int(arg, 16)
    lo, hi = target & 0xFF, (target >> 8) & 0xFF
    print(f'--- refs to ${target:04X} ---')
    for i in range(len(rom) - 2):
        if rom[i+1] == lo and rom[i+2] == hi:
            op = rom[i]
            if op in (0xC3, 0xCD):
                kind = 'call' if op == 0xCD else 'jp'
                print(f'  {kind} at ROM ${i:05X} (bank {i//BANK}, cpu ${cpu(i):04X})')
            elif op in (0xC2, 0xC4, 0xCA, 0xCC, 0xD2, 0xD4, 0xDA, 0xDC):
                print(f'  cond ${op:02X} at ROM ${i:05X} (bank {i//BANK}, cpu ${cpu(i):04X})')
    for i in range(len(rom) - 1):
        op = rom[i]
        if op in (0x18, 0x20, 0x28, 0x30, 0x38):
            d = rom[i+1]
            d = d - 256 if d >= 128 else d
            if cpu(i + 2) + d == target:
                print(f'  jr ${op:02X} at ROM ${i:05X} (bank {i//BANK}, cpu ${cpu(i):04X})')
