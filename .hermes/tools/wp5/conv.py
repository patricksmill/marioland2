#!/usr/bin/env python3
"""WP5 banked chunk converter for main.asm — replaces raw baserom INCBIN chunks
with typed source (code / db / dw), byte-identical by construction.

Usage:
  conv.py BANK [--dry] [chunk_start_hex ...]
  BANK = hex (e.g. 18). Optional chunk args restrict to those chunks.
  Rewrites /home/pmill/sml2decomp/main.asm in place unless --dry.
  Run `make clean && make compare` after (the gate is the only proof).

Method per the WP5 handoff / AGENTS.md:
  * code chunks  -> disassembled instructions, branch targets resolved to
    existing labels (kind-preferred: call/jp/jr), new labels created in-chunk
    as UnknownCall/Jump/RJump_0x<romaddr> when missing
  * data chunks  -> inline db (16/line) / dw (4/line, label when available),
    UnknownData_0xNNNNN labels kept, comment attached to the label line
  * UnknownData_ labels at code-chunk starts are dropped when unreferenced
"""
import re, sys, glob

sys.path.insert(0, '/home/pmill/sml2decomp/.hermes/tools/wp3')
import sm83 as D

ROOT = '/home/pmill/sml2decomp'
ROM = D.ROM
MAIN = f'{ROOT}/main.asm'

SYMS = {}
for ln in open('/home/pmill/.hermes/cache/scratch/sml2.sym'):
    m = re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)', ln)
    if m:
        SYMS.setdefault((int(m[1], 16), int(m[2], 16)), []).append(m[3])

ALL_ASM = sorted(glob.glob(f'{ROOT}/**/*.asm', recursive=True))
_TEXT = {f: open(f, errors='replace').read() for f in ALL_ASM}


def external_refs(name):
    """occurrences of `name` outside its own definition line, across all sources"""
    n = 0
    rx = re.compile(rf'\b{re.escape(name)}\b')
    for txt in _TEXT.values():
        for m in rx.finditer(txt):
            ls = txt.rfind('\n', 0, m.start()) + 1
            le = txt.find('\n', m.start())
            line = txt[ls:le if le != -1 else None].strip()
            if line.startswith(name + ':'):
                continue
            n += 1
    return n


# ---------------- spec ------------------------------------------------------
# chunk_start: dict(segs=[(kind, start, end)], comment=..., labels={addr:[name]},
#                   seg_comments={addr: comment})
# kind in ('code', 'db', 'dw')
CODE18 = [(0x60441, 0x60444), (0x6045E, 0x60461), (0x60694, 0x6069C), (0x607A7, 0x607AA),
          (0x60862, 0x60865), (0x6094F, 0x60955), (0x6095F, 0x60965), (0x60B5A, 0x60B5C),
          (0x60BA4, 0x60BA8), (0x60D3F, 0x60D49), (0x60E21, 0x60E2F), (0x60E33, 0x60E41),
          (0x60E45, 0x60E4C), (0x60E50, 0x60E5B), (0x60E6A, 0x60E7D), (0x60EA1, 0x60EAB),
          (0x60EAF, 0x60EB5)]

SPEC = {
    0x18: {
        0x60000: dict(segs=[('db', 0x60000, 0x60028)],
                      comment='byte table (values 0-$0B); no direct reader found'),
        0x60037: dict(segs=[('dw', 0x60037, 0x6004F)],
                      comment='state handler table, `jp hl` targets, indexed by [$A7A6] (read via `ld hl, $4037`)'),
        0x6021A: dict(segs=[('db', 0x6021A, 0x6022A)],
                      comment='byte table, indexed by [$A7A7] (read via `ld hl, $421A`)'),
        0x60521: dict(segs=[('dw', 0x60521, 0x60539)],
                      comment='state handler table, `jp hl` targets, indexed by [$A7A6] (read via `ld hl, $4521`)'),
        0x60A1A: dict(segs=[('db', 0x60A1A, 0x60A81)],
                      comment='byte table (values 0-$04, $FF markers); no direct reader found'),
        0x60C4D: dict(segs=[('db', 0x60C4D, 0x60C59)],
                      comment='byte lookup tables: base $4C4D by sCurPowerup/[$A7AC] (UnknownCall_0x60C41), base $4C51 by [$A7A8]'),
        0x60F5A: dict(segs=[('db', 0x60F5A, 0x6106D)],
                      comment='packed lookup tables, read at $4F5A, $4F5E, $4F62, $4F66, $4F6A, $4F76, $4F7E, $4FA8, $4FCD'),
        0x611B1: dict(segs=[('dw', 0x611B1, 0x61213),
                            ('dw', 0x61213, 0x61239),
                            ('db', 0x61239, 0x61602)],
                      comment='object-type pointer tables (UnknownCall_0x6109B reads $51B1, UnknownCall_0x610DD reads $5213)',
                      labels={0x61213: ['UnknownData_0x61213']},
                      seg_comments={0x61213: 'second pointer table (base $5213, for the $A7D0 list)',
                                    0x61239: 'object records (4 bytes each; a $FF in the 3rd byte ends a stream)'}),
        0x61A40: dict(segs=[('db', 0x61A40, 0x64000)],
                      comment='object records pointed to by OW_Movement_Pointers ($61602)',
                      labels={0x61A40: ['UnknownData_0x61A40']}),
    },
}
for s, e in CODE18:
    SPEC[0x18][s] = dict(segs=[('code', s, e)])

# ---------------- label resolution ------------------------------------------
# NOTE: pc/target coordinates. jr targets are pc-relative and arrive in
# ROM-offset space (like the decode pc), while jp/call operands are in-bank
# ($0000-$3FFF = bank 0; $4000-$7FFF = the section's bank). Everything below
# normalizes to ROM-offset space; SYMS keys are in-mapped space.
CREATED = {}   # rom addr -> name (new labels needed by this batch)
DROPPED = set()


def to_rom(bank, t, kind):
    if kind == 'jr':
        return t
    if t < 0x4000:
        return t
    return bank * 0x4000 + (t - 0x4000)


def sym_key(rom):
    if rom < 0x4000:
        return (0, rom)
    return (rom >> 14, 0x4000 | (rom & 0x3FFF))


def pick(bank, rom, kind):
    names = SYMS.get(sym_key(rom), [])
    cands = [n for n in names if not n.startswith('UnknownData_') and n not in DROPPED]
    if not cands:
        return None
    pref = {'call': 'UnknownCall', 'jp': 'UnknownJump', 'jr': 'UnknownRJump'}.get(kind)
    if pref:
        for n in cands:
            if n.startswith(pref + '_'):
                return n
    return cands[0]


def label_for(bank, t, kind):
    rom = to_rom(bank, t, kind)
    if rom in CREATED:
        return CREATED[rom]
    name = pick(bank, rom, kind)
    if name:
        return name
    pref = {'call': 'UnknownCall', 'jp': 'UnknownJump', 'jr': 'UnknownRJump'}[kind]
    if rom < 0x4000:
        name = f'{pref}_0x{rom:04X}'
    else:
        name = f'{pref}_0x{rom:05X}'
    CREATED[rom] = name
    return name


def labels_at(bank, pc, extras):
    out = [n for n in SYMS.get(sym_key(pc), []) if n not in DROPPED]
    for n in extras.get(pc, []):
        if n not in out:
            out.append(n)
    return out


# ---------------- rendering -------------------------------------------------
def render_code(bank, a, b, extras):
    out = []
    pc = a
    while pc < b:
        n, m, info = D.decode(pc, lambda t: f'${t:04X}')
        assert m is not None, f'illegal opcode at ${pc:05X}'
        if pc != a:  # segment-start labels are emitted by the caller
            for nm in labels_at(bank, pc, extras):
                if out:
                    out.append('')
                out.append(f'{nm}:')
        if 'target' in info:
            m = m.rsplit(' ', 1)[0] + ' ' + label_for(bank, info['target'], info['kind'])
        op = ROM[pc]
        if op in (0xC6, 0xCE, 0xD6, 0xDE):
            m = f"{['add', 'adc', 'sub', 'sbc'][(op - 0xC6) // 8]} {ROM[pc + 1]}"
        out.append('\t' + m)
        pc += n
    assert pc == b, f'code segment overruns at ${a:05X}-${b:05X}'
    return out


def render_data(bank, kind, a, b):
    out = []
    p = a
    per = 16 if kind == 'db' else 4
    while p < b:
        if kind == 'db':
            q = min(b, p + per)
            out.append('\tdb ' + ', '.join(f'${x:02X}' for x in ROM[p:q]))
        else:
            q = min(b, p + 2 * per)
            cells = []
            for i in range(p, q, 2):
                w = ROM[i] | ROM[i + 1] << 8
                rom = to_rom(bank, w, 'jp')
                nm = CREATED.get(rom) or pick(bank, rom, 'jp')
                cells.append(nm if nm else f'${w:04X}')
            out.append('\tdw ' + ', '.join(cells))
        p = q
    return out


# ---------------- main ------------------------------------------------------
def main():
    argv = [a for a in sys.argv[1:] if not a.startswith('-')]
    dry = '--dry' in sys.argv
    bank = int(argv[0], 16)
    only = {int(a, 16) for a in argv[1:]} or None
    spec = SPEC[bank]

    main_lines = open(MAIN).read().split('\n')

    # locate the INCBIN lines for this bank's chunks
    info = {}
    cur = None
    for i, ln in enumerate(main_lines):
        m = re.match(r'SECTION "bank([0-9A-Fa-f]+)", ROMX, BANK\[\$([0-9A-Fa-f]+)\]', ln)
        if m:
            cur = int(m.group(2), 16)
            continue
        m = re.match(r'INCBIN "baserom\.gb", \$([0-9A-Fa-f]+), \$([0-9A-Fa-f]+) - \$([0-9A-Fa-f]+)', ln)
        if m and cur == bank:
            s, e = int(m.group(1), 16), int(m.group(2), 16)
            if only and s not in only:
                continue
            assert s in spec, f'chunk ${s:05X} not in SPEC'
            info[s] = dict(line=i + 1, e=e)

    missing = (set(spec) & only) - set(info) if only else set(spec) - set(info)
    assert not missing, f'chunks not found in main.asm: {[hex(x) for x in missing]}'

    # pass 1: drop-decision per chunk + collect created labels
    drop_map = {}
    for s, ch in spec.items():
        if s not in info:
            continue
        is_code = any(k == 'code' for k, *_ in ch['segs'])
        above = []
        j = info[s]['line'] - 2  # 0-based index of line above INCBIN
        while j >= 0 and re.match(r'^\w+:\s*(;.*)?$', main_lines[j]):
            above.append(main_lines[j].split(':')[0])
            j -= 1
        d = []
        if is_code:
            for n in above:
                if n.startswith('UnknownData_') and external_refs(n) == 0:
                    d.append(n)
        drop_map[s] = d
    DROPPED.update(x for d in drop_map.values() for x in d)

    # pass 2: create labels needed by code segments (existence + placement check)
    for s, ch in spec.items():
        if s not in info:
            continue
        for kind, a, b in ch['segs']:
            if kind != 'code':
                continue
            pc = a
            while pc < b:
                n, m, tgt = D.decode(pc)
                assert m is not None, f'illegal at ${pc:05X}'
                if 'target' in tgt:
                    label_for(bank, tgt['target'], tgt['kind'])
                pc += n

    # pass 3: render blocks
    blocks = {}
    for s, ch in spec.items():
        if s not in info:
            continue
        e = info[s]['e']
        extras = dict(ch.get('labels', {}))  # addr -> [name]
        for addr in list(CREATED):
            first, last = ch['segs'][0][1], ch['segs'][-1][2]
            if first <= addr < last:
                extras.setdefault(addr, []).append(CREATED[addr])
        seg_comments = ch.get('seg_comments', {})
        comment = ch.get('comment')
        out = []
        first_label_line = None
        for idx, (kind, a, b) in enumerate(ch['segs']):
            if out:
                out.append('')
            names = labels_at(bank, a, extras)
            if names:
                for nm in names:
                    line = f'{nm}:'
                    if first_label_line is None and comment:
                        line += f' ;{comment}'
                        comment = None
                        first_label_line = len(out)
                    elif a in seg_comments and nm == names[-1]:
                        line += f' ;{seg_comments[a]}'
                    out.append(line)
            elif comment:
                out.append(f';{comment}')
                comment = None
            elif a in seg_comments:
                out.append(f';{seg_comments[a]}')
            if kind == 'code':
                body = render_code(bank, a, b, extras)
            else:
                body = render_data(bank, kind, a, b)
            out += body
        assert comment is None, f'chunk comment unused for ${s:05X}'
        # end of block; strip a trailing blank if last segment ended with one
        blocks[s] = out

    # sanity: every created label must be emitted inside a converted block
    for addr, name in CREATED.items():
        emitted = any(any(f'{name}:' in l for l in blk) for blk in blocks.values())
        assert emitted, f'created label {name} at ${addr:05X} falls outside converted blocks'

    # pass 4: splice bottom-up
    edits = []
    for s, ch in spec.items():
        if s not in info:
            continue
        li = info[s]['line']
        old = main_lines[li - 1]
        assert old.startswith(f'INCBIN "baserom.gb", ${s:05X},'), old
        j = li - 2
        while j >= 0 and re.match(r'^\w+:\s*(;.*)?$', main_lines[j]):
            j -= 1
        start = j + 1  # first replaced line (0-based)
        edits.append((start, li, blocks[s]))  # replace lines [start, li)
    edits.sort(key=lambda t: t[0], reverse=True)

    if dry:
        for s in sorted(spec):
            if s not in info:
                continue
            print(f'===== chunk ${s:05X} (replacing main.asm line {info[s]["line"]}) =====')
            for l in blocks[s][:60]:
                print('   ' + l)
            if len(blocks[s]) > 60:
                print(f'   ... ({len(blocks[s])} lines total)')
        return

    for start, end, block in edits:
        main_lines[start:end] = block
    open(MAIN, 'w').write('\n'.join(main_lines))
    nbytes = sum(info[s]['e'] - s for s in info)
    print(f'bank ${bank:02X}: converted {len(info)} chunks, {nbytes} bytes; '
          f'created {len(CREATED)} labels: ' + str(CREATED))
    print('dropped: ' + str(sorted(DROPPED)))


if __name__ == '__main__':
    main()
