#!/usr/bin/env python3
"""WP6 batch substitution: replace bracketed [$Axxx] refs with ram.asm symbols.

Bracketed-only by design: comments, immediates (`ld hl, $Axxx`) and `dw` tables are
NOT touched. Dry-run by default; pass --apply to write.

Usage:
  python3 sub_refs.py                       # dry-run, built-in $A2xx mapping below
  python3 sub_refs.py --apply               # write
  python3 sub_refs.py mapping.tsv           # custom mapping (lines: $A2B6<TAB>sMoonFxState)
  python3 sub_refs.py --apply mapping.tsv

Always follow with: make clean && make compare && sha1sum baserom.gb sml2.gb
(commit only on green), and delete any stray baserom.gb.ram first.
"""
import re, sys

# Batch of 2026-10-09 (commit 7b37c37) — pass a TSV for the next batch.
DEFAULT = [
    ('$A2B6', 'sMoonFxState'),
    ('$A2B7', 'sMoonFxTimer'),
    ('$A2B8', 'sMoonFxYU'),
    ('$A2B9', 'sMoonFxY'),
    ('$A2BA', 'sMoonFxXU'),
    ('$A2BB', 'sMoonFxX'),
    ('$A2C7', 'sCursorHopActive'),
    ('$A2C9', 'sRowShiftIndex'),
    ('$A2CA', 'sRowShiftCount'),
    ('$A2D0', 'sPrevKeysHeld'),
    ('$A2D1', 'sCursorAnimY'),
    ('$A2D3', 'sCoinIconDropY'),
    ('$A2D6', 'sCreditsTextPhase'),
    ('$A2D8', 'sCreditsTextDone'),
]


def main():
    apply = '--apply' in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    pairs = DEFAULT
    if args:
        pairs = []
        for line in open(args[0]):
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            addr, sym = line.split('\t')
            pairs.append((addr.strip(), sym.strip()))
    total = 0
    for fname in ('main.asm', 'home.asm'):
        src = open(fname, encoding='utf-8').read()
        out = src
        for addr, sym in pairs:
            pat = re.compile(r'\[\$' + addr.lstrip('$') + r'\]')
            n = len(pat.findall(out))
            if n:
                out = pat.sub('[' + sym + ']', out)
                total += n
                print(f'{fname}: {addr} -> {sym}: {n}')
        if out != src and apply:
            open(fname, 'w', encoding='utf-8').write(out)
    print('TOTAL:', total, 'substitutions')
    if not apply:
        print('(dry run; pass --apply to write)')


if __name__ == '__main__':
    main()
