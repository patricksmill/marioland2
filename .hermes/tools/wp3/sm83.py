#!/usr/bin/env python3
"""Minimal SM83 disassembler for sml2decomp WP3 (bank 0 chunks)."""
import re, sys, os

ROOT = '/home/pmill/sml2decomp'
ROM = open(f'{ROOT}/baserom.gb', 'rb').read()
SYM = '/home/pmill/.hermes/cache/scratch/sml2.sym'

R8 = ['b', 'c', 'd', 'e', 'h', 'l', '[hl]', 'a']
R16 = ['bc', 'de', 'hl', 'sp']
R16S = ['bc', 'de', 'hl', 'af']
CC = ['nz', 'z', 'nc', 'c']
ALU = ['add', 'adc', 'sub', 'sbc', 'and', 'xor', 'or', 'cp']
CB = ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'swap', 'srl']
ILLEGAL = {0xD3, 0xDB, 0xDD, 0xE3, 0xE4, 0xEB, 0xEC, 0xED, 0xF4, 0xFC, 0xFD}


def load_syms():
    labels = {}  # addr -> name (bank 0 only, first non-local)
    try:
        for ln in open(SYM):
            m = re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)', ln)
            if not m:
                continue
            b, a, n = int(m[1], 16), int(m[2], 16), m[3]
            if b == 0 and '.' not in n and a < 0x4000:
                labels.setdefault(a, []).append(n)
    except FileNotFoundError:
        pass
    return labels


def load_regs():
    names = {}
    used = set(re.findall(r'\b(r[A-Z][A-Z0-9_]+)\b',
                          open(f'{ROOT}/main.asm').read() + open(f'{ROOT}/home.asm').read()))
    for ln in open(f'{ROOT}/hardware.inc'):
        m = re.match(r'\s*def (r[A-Z0-9_]+)\s+equ\s+\$([0-9A-Fa-f]{4})\b', ln)
        if m:
            a = int(m[2], 16)
            n = m[1]
            if a < 0xFF00:
                continue
            if a not in names or (n in used and names[a] not in used):
                names[a] = n
    for ln in open(f'{ROOT}/ram.asm'):
        m = re.match(r'DEF (\w+) EQU \$([0-9A-Fa-f]{4})', ln)
        if m:
            names[int(m[2], 16)] = m[1]
    return names


LABELS = load_syms()
REGS = load_regs()


def hx8(v):
    return f'${v:02X}'


def hx16(v):
    return f'${v:04X}'


def mem16(a):
    """Name for an absolute memory operand (a16)."""
    return REGS.get(a, hx16(a))


def hram(n):
    a = 0xFF00 + n
    return REGS.get(a, hx16(a))


def decode(pc, labelfn=None):
    """Return (length, mnemonic, info) at pc. info: dict with 'target','kind'."""
    op = ROM[pc]
    b1 = ROM[pc + 1] if pc + 1 < len(ROM) else 0
    b2 = ROM[pc + 2] if pc + 2 < len(ROM) else 0
    w = b1 | (b2 << 8)
    lab = labelfn or (lambda a: hx16(a))
    info = {}
    if op in ILLEGAL:
        return 1, None, {'illegal': True}
    if op == 0xCB:
        x, y, z = b1 >> 6, (b1 >> 3) & 7, b1 & 7
        if x == 0:
            return 2, f'{CB[y]} {R8[z]}', info
        return 2, f"{['', 'bit', 'res', 'set'][x]} {y}, {R8[z]}", info
    x, y, z = op >> 6, (op >> 3) & 7, op & 7
    p, q = y >> 1, y & 1
    if x == 1:
        if op == 0x76:
            return 1, 'halt', {'halt': True}
        return 1, f'ld {R8[y]}, {R8[z]}', info
    if x == 2:
        return 1, f'{ALU[y]} {R8[z]}' if y not in (0, 1, 3) else f'{ALU[y]} {R8[z]}', info
    if x == 0:
        if z == 0:
            if y == 0: return 1, 'nop', info
            if y == 1: return 3, f'ld [{hx16(w)}], sp', info
            if y == 2: return 2, 'stop', {'stop': True}
            off = b1 - 256 if b1 > 127 else b1
            t = pc + 2 + off
            info = {'target': t, 'kind': 'jr'}
            if y == 3: return 2, f'jr {lab(t)}', {**info, 'end': True}
            return 2, f'jr {CC[y-4]}, {lab(t)}', info
        if z == 1:
            if q == 0: return 3, f'ld {R16[p]}, {hx16(w)}', {'imm16': w}
            return 1, f'add hl, {R16[p]}', info
        if z == 2:
            m = ['[bc]', '[de]', '[hli]', '[hld]'][p]
            return 1, (f'ld {m}, a' if q == 0 else f'ld a, {m}'), info
        if z == 3:
            return 1, f"{'inc' if q == 0 else 'dec'} {R16[p]}", info
        if z == 4: return 1, f'inc {R8[y]}', info
        if z == 5: return 1, f'dec {R8[y]}', info
        if z == 6: return 2, f'ld {R8[y]}, {b1}', info
        if z == 7:
            return 1, ['rlca', 'rrca', 'rla', 'rra', 'daa', 'cpl', 'scf', 'ccf'][y], info
    if x == 3:
        if z == 0:
            if y < 4: return 1, f'ret {CC[y]}', info
            if y == 4: return 2, f'ldh [{hram(b1)}], a', info
            if y == 5: return 2, f'add sp, {b1 - 256 if b1 > 127 else b1}', info
            if y == 6: return 2, f'ldh a, [{hram(b1)}]', info
            if y == 7:
                o = b1 - 256 if b1 > 127 else b1
                return 2, f'ld hl, sp + {o}', info
        if z == 1:
            if q == 0: return 1, f'pop {R16S[p]}', info
            if p == 0: return 1, 'ret', {'end': True}
            if p == 1: return 1, 'reti', {'end': True}
            if p == 2: return 1, 'jp hl', {'end': True}
            return 1, 'ld sp, hl', info
        if z == 2:
            if y < 4:
                return 3, f'jp {CC[y]}, {lab(w)}', {'target': w, 'kind': 'jp'}
            if y == 4: return 1, 'ld [$FF00+c], a', info
            if y == 5: return 3, f'ld [{mem16(w)}], a', {'mem': w}
            if y == 6: return 1, 'ld a, [$FF00+c]', info
            return 3, f'ld a, [{mem16(w)}]', {'mem': w}
        if z == 3:
            if y == 0: return 3, f'jp {lab(w)}', {'target': w, 'kind': 'jp', 'end': True}
            if y == 6: return 1, 'di', info
            if y == 7: return 1, 'ei', info
        if z == 4:
            return 3, f'call {CC[y]}, {lab(w)}', {'target': w, 'kind': 'call'}
        if z == 5:
            if q == 0: return 1, f'push {R16S[p]}', info
            return 3, f'call {lab(w)}', {'target': w, 'kind': 'call'}
        if z == 6:
            fmt = hx8(b1)
            return 2, f'{ALU[y]} {fmt}', info
        if z == 7:
            return 1, f'rst ${y*8:02X}', {'rst': y * 8, 'end': y * 8 == 0x28}
    return 1, None, {'illegal': True}


def linear(start, end):
    out = []
    pc = start
    while pc < end:
        n, m, info = decode(pc)
        out.append((pc, n, m, info))
        pc += n
    return out


if __name__ == '__main__':
    s, e = int(sys.argv[1], 16), int(sys.argv[2], 16)
    for pc, n, m, info in linear(s, e):
        bs = ' '.join(f'{b:02X}' for b in ROM[pc:pc + n])
        lbl = ','.join(LABELS.get(pc, []))
        print(f'{pc:04X}: {bs:<9} {m or "??"}{"   <" + lbl if lbl else ""}')
