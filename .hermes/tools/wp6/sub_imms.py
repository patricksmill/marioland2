#!/usr/bin/env python3
"""WP6 batch substitution for BARE operand tokens ($ADxx immediates/derefs).

Replaces `$ADxx` in the code part of each line only — the comment part after the
first ';' is never touched. Use this for address regions whose refs are immediate
loads (`ld hl, $AD00`) rather than bracketed derefs (for those use sub_refs.py).

Dry-run by default; pass --apply to write.
Usage: python3 sub_imms.py mapping.tsv [--apply]
TSV lines: $AD00<TAB>sObjectTable
"""
import re
import sys


def main():
    apply = '--apply' in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    pairs = []
    for line in open(args[0]):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        addr, sym = line.split('\t')
        pairs.append((addr.strip().lstrip('$'), sym.strip()))
    total = 0
    for fname in ('main.asm', 'home.asm'):
        src = open(fname, encoding='utf-8').read().split('\n')
        out = []
        hits = 0
        for lineno, ln in enumerate(src, 1):
            if ';' in ln:
                code, comment = ln.split(';', 1)
                comment = ';' + comment
            else:
                code, comment = ln, ''
            new = code
            for addr, sym in pairs:
                pat = re.compile(r'\$' + addr + r'(?![0-9A-Fa-f])')
                if pat.search(new):
                    found = pat.findall(new)
                    new = pat.sub(sym, new)
                    hits += len(found)
                    if not apply:
                        print(f'{fname}:{lineno}: {code.strip()}  ->  {new.strip()}')
            out.append(new + comment)
        total += hits
        if apply and out != src:
            open(fname, 'w', encoding='utf-8').write('\n'.join(out))
        print(f'{fname}: {hits} operand substitutions')
    print('TOTAL:', total, 'substitutions')
    if not apply:
        print('(dry run; pass --apply to write)')


if __name__ == '__main__':
    main()
