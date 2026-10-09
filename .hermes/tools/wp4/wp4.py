#!/usr/bin/env python3
"""WP4: replace remaining raw baserom INCBIN chunks in main.asm.

Usage: wp4.py BANK   (BANK in 08 0D 0E 10 13 17 1E)

Per the WP4 handoff doc + the chosen approach:
  * graphics chunks -> extract to named gfx/*.2bpp files, label + INCBIN
  * level-data tails -> append bytes to levels/levelNN.bin, drop the chunk
  * everything else -> inline `db` (16/line), keeping UnknownData_0xNNNNN labels
"""
import os, sys

ROOT = '/home/pmill/sml2decomp'
ROM = open(f'{ROOT}/baserom.gb', 'rb').read()
MAIN = f'{ROOT}/main.asm'

# chunk: rom_start, rom_end, kind, label, file
CHUNKS = {
    0x23800: dict(end=0x24000, kind='data',  label='UnknownData_0x23800',
                  comment='level-layout-like data (0xAA-heavy), unclassified'),
    0x35800: dict(end=0x35A00, kind='gfx',   label='GFX_OW_MacroZoneBase',
                  file='gfx/overworld/macrozone_base.2bpp'),
    0x38000: dict(end=0x38200, kind='gfx',   label='GFX_OW_PumpkinZoneBase',
                  file='gfx/overworld/pumpkinzone_base.2bpp'),
    0x39800: dict(end=0x39A00, kind='gfx',   label='GFX_OW_TreeZoneBase',
                  file='gfx/overworld/treezone_base.2bpp'),
    0x3BFC0: dict(end=0x3C000, kind='data',  label='UnknownData_0x3BFC0',
                  comment='64 bytes after the overworld tilemaps (wariocastle tail?)'),
    0x40000: dict(end=0x40200, kind='gfx',   label='GFX_OW_SpaceZoneBase',
                  file='gfx/overworld/spacezone_base.2bpp'),
    0x41800: dict(end=0x42000, kind='gfx',   label='GFX_OW_MarioCastleBase',
                  file='gfx/overworld/mariocastle_base.2bpp'),
    0x43B40: dict(end=0x44000, kind='data',  label='UnknownData_0x43B40',
                  comment='follows the minigame tilemaps; unclassified'),
    0x4C000: dict(end=0x4C2F0, kind='data',  label='UnknownData_0x4C000',
                  comment='per-level group block preceding the Level_xx pointer list'),
    0x4C2F8: dict(end=0x4C500, kind='data',  label='UnknownData_0x4C2F8',
                  comment='shared group block between the pointer list and Level_18'),
    0x4FEAF: dict(end=0x50000, kind='tail',  file='levels/level25.bin'),
    0x5C000: dict(end=0x5C2F0, kind='data',  label='UnknownData_0x5C000',
                  comment='per-level group block preceding the Level_xx pointer list'),
    0x5C2F8: dict(end=0x5C500, kind='data',  label='UnknownData_0x5C2F8',
                  comment='shared group block between the pointer list and Level_11'),
    0x5F81A: dict(end=0x60000, kind='tail',  file='levels/level14.bin'),
    0x79800: dict(end=0x79A00, kind='gfx',   label='GFX_TilesetWarioRoom2',
                  file='gfx/tilesets/warioroom2.2bpp'),
    0x7A800: dict(end=0x7A880, kind='gfx',   label='GFX_EnemiesSpaceZoneBoss2',
                  file='gfx/enemies/spacezoneboss2.2bpp'),
    0x7B680: dict(end=0x7C000, kind='data',  label='UnknownData_0x7B680',
                  comment='level-layout-like data (0xAA-heavy), unclassified'),
}

# which chunks belong to which bank batch
BANKS = {
    '08': [0x23800],
    '0D': [0x35800],
    '0E': [0x38000, 0x39800, 0x3BFC0],
    '10': [0x40000, 0x41800, 0x43B40],
    '13': [0x4C000, 0x4C2F8, 0x4FEAF],
    '17': [0x5C000, 0x5C2F8, 0x5F81A],
    '1E': [0x79800, 0x7A800, 0x7B680],
}


def incbin_line(off, info):
    """exact source text of the raw baserom INCBIN for this chunk"""
    return f'INCBIN "baserom.gb", ${off:05X}, ${info["end"]:05X} - ${off:05X}'


def db_block(data):
    out = []
    for i in range(0, len(data), 16):
        row = ', '.join(f'${b:02X}' for b in data[i:i + 16])
        out.append('\tdb ' + row)
    return '\n'.join(out)


def apply_bank(bank):
    offs = BANKS[bank]
    text = open(MAIN).read()
    report = []
    for off in offs:
        info = CHUNKS[off]
        old = incbin_line(off, info)
        if old not in text:
            print(f'!! anchor not found for ${off:05X}: {old}')
            sys.exit(1)
        data = ROM[off:info['end']]
        if info['kind'] == 'gfx':
            new = f'{info["label"]}: ;${off:05X}\nINCBIN "{info["file"]}"'
            os.makedirs(os.path.dirname(f'{ROOT}/{info["file"]}'), exist_ok=True)
            with open(f'{ROOT}/{info["file"]}', 'wb') as fh:
                fh.write(data)
            report.append(f'  ${off:05X} -> extract {info["file"]} ({len(data)} B) as {info["label"]}')
        elif info['kind'] == 'tail':
            path = f'{ROOT}/{info["file"]}'
            before = os.path.getsize(path)
            with open(path, 'ab') as fh:
                fh.write(data)
            report.append(f'  ${off:05X} -> append {len(data)} B to {info["file"]} ({before} -> {before+len(data)})')
            new = None  # drop the line
        else:
            body = db_block(data)
            if f'{info["label"]}:' in text:
                # existing label line: left in place, just gain a comment
                text = text.replace(f'{info["label"]}:\n',
                                    f'{info["label"]}: ;{info["comment"]}\n', 1)
                new = body
            else:
                new = f'{info["label"]}: ;{info["comment"]}\n' + body
            report.append(f'  ${off:05X} -> db ({len(data)} B) as {info["label"]}')

        if new is None:
            # remove the line and a following blank line if present
            text = text.replace(old + '\n\n', '', 1)
            if old in text:
                text = text.replace(old + '\n', '', 1)
        else:
            text = text.replace(old, new, 1)

    # $38000 / $40000 already carry a leading UnknownData_0xNNNNN: label line
    for off in offs:
        info = CHUNKS[off]
        if info['kind'] == 'gfx':
            stale = f'UnknownData_0x{off:05X}:\n'
            # only strip when it directly precedes our new label (else it is another chunk's)
            text = text.replace(stale + info['label'], info['label'], 1)

    open(MAIN, 'w').write(text)
    print(f'bank ${bank}:')
    print('\n'.join(report))


if __name__ == '__main__':
    apply_bank(sys.argv[1])