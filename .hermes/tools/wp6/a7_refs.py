#!/usr/bin/env python3
"""Dump all $A7xx reference sites grouped by address (main.asm + home.asm).

Output: one section per address, each site as file:lineno: <source line>.
Used to decode semantics before naming in ram.asm.
"""
import re
import collections

refs = collections.defaultdict(list)
for fname in ('main.asm', 'home.asm'):
    for lineno, line in enumerate(open(fname, encoding='utf-8'), 1):
        for m in re.finditer(r'(?<!\[)\$A7([0-9A-Fa-f]{2})(?!\])|\[\$A7([0-9A-Fa-f]{2})\]', line):
            a = '$A7' + (m.group(1) or m.group(2)).upper()
            refs[a].append(f'{fname}:{lineno}: {line.rstrip()}')

out = []
for a in sorted(refs):
    out.append(f'===== {a} ({len(refs[a])} refs) =====')
    for s in refs[a]:
        out.append(s)
open('/home/pmill/.hermes/cache/scratch/wp6/a7_refs.txt', 'w', encoding='utf-8').write('\n'.join(out) + '\n')
print('addresses:', len(refs), 'sites:', sum(len(v) for v in refs.values()))
