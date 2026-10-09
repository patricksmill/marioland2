#!/usr/bin/env python3
"""Map each home.asm line to its ROM address (bank 0). Prints JSON {line: addr}."""
import json, os, re, subprocess, sys

ROOT = '/home/pmill/sml2decomp'


def addrmap():
    lines = open(f'{ROOT}/home.asm').read().split('\n')
    out = []
    seen = False
    for i, l in enumerate(lines):
        if l.startswith('SECTION'):
            seen = True
            if l.strip() == 'SECTION "bank00", ROM0':
                l = 'SECTION "bank00", ROM0[$0000]'
            out.append(l)
            continue
        if seen:
            out.append('\tPRINTLN "N%d ", @' % (i + 1))
        out.append(l)
    probe_home = os.path.join(ROOT, '.wp3_probe_home.asm')
    probe_main = os.path.join(ROOT, '.wp3_probe_main.asm')
    open(probe_home, 'w').write('\n'.join(out))
    m = open(f'{ROOT}/main.asm').read().replace('include "home.asm"', 'include ".wp3_probe_home.asm"')
    # only need bank 0: cut main after the home include
    idx = m.index('include ".wp3_probe_home.asm"')
    m = m[:idx + len('include ".wp3_probe_home.asm"')] + '\n'
    open(probe_main, 'w').write(m)
    try:
        r = subprocess.run(['rgbasm', '-o', '/dev/null', probe_main], cwd=ROOT,
                           capture_output=True, text=True)
    finally:
        os.remove(probe_home)
        os.remove(probe_main)
    if r.returncode:
        print(r.stderr, file=sys.stderr)
        sys.exit(2)
    res = {}
    for ln in r.stdout.split('\n'):
        mm = re.match(r'N(\d+) \$([0-9A-Fa-f]+)', ln)
        if mm:
            res[int(mm[1])] = int(mm[2], 16)
    return res


if __name__ == '__main__':
    json.dump(addrmap(), open('/home/pmill/.hermes/cache/scratch/wp3/addrmap.json', 'w'))
    print('ok')
