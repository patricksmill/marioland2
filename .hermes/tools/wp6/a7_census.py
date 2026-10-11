#!/usr/bin/env python3
"""Census of $A7xx references in main.asm/home.asm.

For each address in $A700-$A7FF: count bracketed refs ([$A7xx]) and bare refs
($A7xx not inside brackets). Bare refs include immediates (ld hl, $A7xx), dw
tables and comments — print the source lines for bare refs so they can be
classified before choosing a substitution mode.

Usage: python3 a7_census.py [--lines]
"""
import re
import sys
import collections

show_lines = '--lines' in sys.argv

brack = collections.Counter()
bare = collections.Counter()
bare_lines = collections.defaultdict(list)

for fname in ('main.asm', 'home.asm'):
    for lineno, line in enumerate(open(fname, encoding='utf-8'), 1):
        code = line.split(';', 1)[0]
        # bracketed refs
        for m in re.finditer(r'\[\$A7([0-9A-Fa-f]{2})\]', code):
            brack['$A7' + m.group(1).upper()] += 1
        # bare refs: token not immediately preceded by '[' and not immediately followed by ']'
        for m in re.finditer(r'(?<!\[)\$A7([0-9A-Fa-f]{2})(?!\])', code):
            a = '$A7' + m.group(1).upper()
            bare[a] += 1
            bare_lines[a].append(f'{fname}:{lineno}: {line.rstrip()}')

addrs = sorted(set(brack) | set(bare))
tb = sum(brack.values())
tv = sum(bare.values())
print(f'{"addr":8} {"[brack]":>7} {"bare":>5}')
for a in addrs:
    print(f'{a:8} {brack.get(a,0):>7} {bare.get(a,0):>5}')
print(f'TOTAL bracketed={tb} bare={tv} addresses={len(addrs)}')
if show_lines:
    print()
    for a in addrs:
        if bare_lines.get(a):
            print(f'--- {a} bare sites ---')
            for l in bare_lines[a]:
                print('   ', l)
