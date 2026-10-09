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
    0x0C: {
        0x3012A: dict(segs=[('db', 0x3012A, 0x3012E)],
                      comment='indexed by ($FF97 & $0C) >> 2; value is added to 201 and written to $FFC6 (reader at $300B4)'),
        0x30132: dict(segs=[('dw', 0x30132, 0x30140)],
                      comment='dw pointers (descending); no direct reader found'),
        0x301C2: dict(segs=[('db', 0x301C2, 0x301C6)],
                      comment='indexed from ($A278 & $18); value written to $FFC6 (reader at $301A6)'),
        0x3046F: dict(segs=[('jt', 0x3046F, 0x30477)],
                      comment='rst $28 jump table for UnknownCall_0x3046B (indexed by $A277)'),
        0x304F1: dict(segs=[('db', 0x304F1, 0x3050A)],
                      comment='per-level byte, indexed by sCurLevel (value is an offset into $A848)'),
        0x30697: dict(segs=[('jt', 0x30697, 0x3069F)],
                      comment='rst $28 jump table for UnknownCall_0x30693 (indexed by $A277)'),
        0x306D1: dict(segs=[('db', 0x306D1, 0x306E1)],
                      comment='4-byte palette records (BGPalette, OAMPalette1, OAMPalette2, $00), indexed by ($A266 & $F0) >> 4'),
        0x30748: dict(segs=[('db', 0x30748, 0x3074C)],
                      comment='indexed by ($FF97 & $0C) >> 2; value written to $FFC6'),
        0x30777: dict(segs=[('db', 0x30777, 0x3077B), ('code', 0x3077B, 0x307BC)],
                      comment='4-byte lookup table (indexed by ($FF97 & $0C) >> 2 -> $FFC6) followed by code'),
        0x30985: dict(segs=[('db', 0x30985, 0x3099D), ('db', 0x3099D, 0x309B5), ('db', 0x309B5, 0x309CD)],
                      comment='per-level values for $FFC2, indexed by sCurLevel',
                      labels={0x3099D: ['UnknownData_0x3099D'], 0x309B5: ['UnknownData_0x309B5']},
                      seg_comments={0x3099D: 'per-level values for $FFC0, indexed by sCurLevel',
                                    0x309B5: 'per-level values for $FFC6, indexed by sCurLevel'}),
        0x30A2A: dict(segs=[('db', 0x30A2A, 0x30A52), ('db', 0x30A52, 0x34000)],
                      comment='tile-row window table (20-byte windows at stride 4, read by UnknownJump_0x309CD)',
                      seg_comments={0x30A52: 'bulk data, read at $4A52 ($400 B -> $9800), $4C92 ($1800 B -> $8000, renders as tiles), $6492/$688A ($300 B each -> $9800); mixes graphics and tables, boundaries open'}),
    },
    0x01: {
        0x4000: dict(segs=[('dw', 0x4000, 0x41E4)],
                     comment='sprite-mapping pointer table, indexed by [$FFC6] * 2 (reader UnknownCall_0x5297); entries point into the $80-terminated mappings at $41E4 (gfx/spritemappings.asm)'),
        0x5348: dict(segs=[('db', 0x5348, 0x534C)],
                     comment='spin-jump sprite selection, indexed by ($FF97 & $0C) >> 2 -> $FFC6'),
        0x588B: dict(segs=[('db', 0x588B, 0x591F)],
                     comment='data following the level headers; no direct reader found'),
        0x5933: dict(segs=[('code', 0x5933, 0x593D)]),
        0x59DA: dict(segs=[('code', 0x59DA, 0x59DF)]),
        0x5A4A: dict(segs=[('db', 0x5A4A, 0x5A72)],
                     comment='vertical offsets indexed by $A23F (40 entries)'),
        0x5AE0: dict(segs=[('db', 0x5AE0, 0x5AF9), ('db', 0x5AF9, 0x5AFD)],
                     comment='vertical offsets indexed by $A23F >> 1 (25 entries)',
                     labels={0x5AF9: ['UnknownData_0x5AF9']},
                     seg_comments={0x5AF9: 'sprites for $FFC6, indexed by ($A23F & $0C) >> 2'}),
        0x5B7E: dict(segs=[('code', 0x5B7E, 0x5B8A)]),
        0x5BB4: dict(segs=[('db', 0x5BB4, 0x5BBC)],
                     comment='8-byte vertical offset table, indexed by $A23F'),
        0x5BC8: dict(segs=[('code', 0x5BC8, 0x5BD3)]),
        0x5C27: dict(segs=[('code', 0x5C27, 0x5C2C)]),
        0x5C52: dict(segs=[('code', 0x5C52, 0x5CDE), ('db', 0x5CDE, 0x5CF1)],
                     seg_comments={0x5CDE: 'unreferenced tail (values $10/$20); no direct reader found'}),
        0x5DF2: dict(segs=[('code', 0x5DF2, 0x5DF9)]),
        0x5DF9: dict(segs=[('code', 0x5DF9, 0x5E03)]),
        0x5E42: dict(segs=[('code', 0x5E42, 0x5E95), ('dw', 0x5E95, 0x5EE1), ('db', 0x5EE1, 0x6442)],
                     comment='sprite-list builder (called from home.asm); entry points via the dw table below',
                     seg_comments={0x5E95: 'sprite-list pointers, indexed by $FFC6 * 2',
                                   0x5EE1: 'sprite lists: 4-byte entries (x, y, tile, attr) + $FF terminator'}),
        0x6442: dict(segs=[('code', 0x6442, 0x647D), ('db', 0x647D, 0x6485)],
                     comment='palette fade step (called via UnknownCall_0x6442)',
                     seg_comments={0x647D: 'palette rows read at +idx from $647D/$6481 (idx = [$A29B] >> 4)'}),
        0x6529: dict(segs=[('db', 0x6529, 0x8000)],
                     comment='packed data ($AA-heavy / high-bit-set runs); format unknown; not the layout RLE streams'),
    },
    0x1A: {
        0x6801A: dict(segs=[('jt', 0x6801A, 0x68042)],
                      comment='rst $28 jump table for UnknownCall_0x68016 (indexed by $A2DD)'),
        0x68125: dict(segs=[('code', 0x68125, 0x68139)]),
        0x6828E: dict(segs=[('code', 0x6828E, 0x682BA)]),
        0x6830F: dict(segs=[('code', 0x6830F, 0x68367), ('db', 0x68367, 0x68398)],
                      seg_comments={0x68367: 'flag table ($FF = skip), indexed from the code above'}),
        0x6844F: dict(segs=[('db', 0x6844F, 0x6845F)],
                      comment='screen-shake offsets (16 entries); values written to $FF43 (readers at $680B1 / $68416)'),
        0x68518: dict(segs=[('db', 0x68518, 0x68520)],
                      comment='sprites for $FFC6, indexed by ($FF97 & $1C) >> 2'),
        0x685E5: dict(segs=[('code', 0x685E5, 0x68656), ('db', 0x68656, 0x6C000)],
                      comment='ending-sequence bank-restoring handlers (reti-terminated)',
                      seg_comments={0x68656: 'ending-sequence assets: font/tile graphics (renders digits/letters/Nintendo), text at $696CE ("THANK YOU MARIO..."), tables; boundaries open'}),
    },
    0x0B: {
        0x2C000: dict(segs=[('db', 0x2C000, 0x2C2F0)],
                      comment='per-level group block preceding the Level_05/06/31/30/29/32 pointer list'),
        0x2C2FC: dict(segs=[('db', 0x2C2FC, 0x2C500)],
                      comment='shared group block between the pointer list and Level_05',
                      labels={0x2C2FC: ['UnknownData_0x2C2FC']}),
        0x2E6AA: dict(segs=[('db', 0x2E6AA, 0x30000)],
                      comment='level-data tail after the last layout stream in bank $0B',
                      labels={0x2E6AA: ['UnknownData_0x2E6AA']}),
    },
    0x12: {
        0x48000: dict(segs=[('db', 0x48000, 0x482F0)],
                      comment='per-level group block preceding the Level_07/08/09/10 pointer list'),
        0x482F8: dict(segs=[('db', 0x482F8, 0x48500)],
                      comment='shared group block between the pointer list and Level_07',
                      labels={0x482F8: ['UnknownData_0x482F8']}),
        0x4A948: dict(segs=[('db', 0x4A948, 0x4C000)],
                      comment='level-data tail after the last layout stream in bank $12',
                      labels={0x4A948: ['UnknownData_0x4A948']}),
    },
    0x19: {
        0x66092: dict(segs=[('dw', 0x66092, 0x6617E), ('db', 0x6617E, 0x68000)],
                      comment='sprite lists: pointer table + records; loader UnknownCall_0x66000 (table base $6092, indexed by [$FFDB] * 2)',
                      seg_comments={0x6617E: 'sprite records (4-byte entries; $80 ends a list, $88 checked as a flag)'}),
    },
    0x1D: {
        0x76600: dict(segs=[('gfx', 0x76600, 0x77E00), ('db', 0x77E00, 0x78000)],
                      comment='Turtle Zone extra tileset (castle/brick ornamentation); $6680-$677F hold 4 animated-tile phases copied to VRAM $9200 by UnknownCall_0x3873 (home.asm)',
                      labels={0x76600: ['GFX_TilesetTurtleZoneExtra'], 0x77E00: ['UnknownData_0x77E00']},
                      seg_comments={0x77E00: '128 zero bytes + packed $AA-heavy data; no direct reader identified'},
                      files={0x76600: 'gfx/tilesets/turtlezone_extra.2bpp'}),
    },
    0x02: {
        0x867C: dict(segs=[('code', 0x867C, 0x868A)]),
        0x86B9: dict(segs=[('code', 0x86B9, 0x86C6)]),
        0x86D2: dict(segs=[('code', 0x86D2, 0x86DA)]),
        0x8737: dict(segs=[('db', 0x8737, 0x8C31)],
                     comment='data blob: base of the [$FFDB]-indexed record copy (UnknownCall_0x81CF -> UnknownJump_0x81DB writes to $FFE3; base $4737 when [$AF06] == 0, else $4935); 2-byte records in the $4Axx-$4Bxx domain'),
        0x8E3F: dict(segs=[('dw', 0x8E3F, 0x8E51), ('db', 0x8E51, 0x8E6C)],
                     comment='pointer table indexed by [$AFC0] * 2 (UnknownCall_0x904E, line 3539)',
                     seg_comments={0x8E51: '3-byte records (9, one per table entry; $xx $06 $xx domain)'}),
        0x8E9A: dict(segs=[('dw', 0x8E9A, 0x8EAC), ('dw', 0x8EAC, 0x8EBA), ('db', 0x8EBA, 0x9048)],
                     comment='pointer table indexed by [$AFC0] * 2 (UnknownCall_0x904E, line 3554)',
                     labels={0x8EAC: ['UnknownData_0x8EAC']},
                     seg_comments={0x8EAC: 'second table (base $4EAC, 7 entries; read at line 3559)',
                                   0x8EBA: '18-byte records (16) for both tables'}),
        0x905B: dict(segs=[('dw', 0x905B, 0x925B), ('db', 0x925B, 0x9285)],
                     comment='256-entry pointer table indexed by [$FFDB] * 2 (UnknownCall_0x9048 -> UnknownJump_0x81DB)',
                     seg_comments={0x925B: 'payload targets for the table above'}),
        0x929A: dict(segs=[('code', 0x929A, 0x92A5)]),
        0x92E8: dict(segs=[('dw', 0x92E8, 0x9322), ('db', 0x9322, 0x9323)],
                     comment='dw values in the $53xx-$70xx domain (ascending, likely sub-table addresses); no direct reader found'),
        0x934E: dict(segs=[('dw', 0x934E, 0x9354)],
                     comment='three ascending dw values ($5354-$5385); no direct reader found'),
        0x93F0: dict(segs=[('dw', 0x93F0, 0x93FE)],
                     comment='seven ascending dw values ($53FE-$5543); no direct reader found'),
        0x94AC: dict(segs=[('code', 0x94AC, 0x94B6)]),
        0x9563: dict(segs=[('code', 0x9563, 0x9569)]),
        0x9595: dict(segs=[('db', 0x9595, 0x9606)],
                     comment='byte table read via UnknownCall_0xB16B at $5595 (8 call sites: lines 3863/3911/3938/3986/5428/5445/5469/5486); mostly $00'),
        0x9641: dict(segs=[('code', 0x9641, 0x9642)]),
        0x966A: dict(segs=[('dw', 0x966A, 0x9670)],
                     comment='three ascending dw values ($5629-$5688); no direct reader found'),
        0x96BE: dict(segs=[('dw', 0x96BE, 0x96C4)],
                     comment='three dw values ($56C4/$56E1/$5688); no direct reader found'),
        0x9754: dict(segs=[('dw', 0x9754, 0x9762)],
                     comment='dw values in the $54xx-$57xx domain; no direct reader found'),
        0x9864: dict(segs=[('dw', 0x9864, 0x986C)],
                     comment='dw values in the $58xx-$59xx domain; no direct reader found'),
        0x990A: dict(segs=[('dw', 0x990A, 0x9912)],
                     comment='dw values in the $58xx-$59xx domain; no direct reader found'),
        0x994C: dict(segs=[('dw', 0x994C, 0x9954)],
                     comment='dw values in the $59xx domain; no direct reader found'),
        0x99E2: dict(segs=[('db', 0x99E2, 0x9A63), ('db', 0x9A63, 0x9AB4), ('db', 0x9AB4, 0x9AF1), ('db', 0x9AF1, 0x9C19)],
                     comment='four byte blobs read via UnknownCall_0xB16B, selected by [$AFC7] at $997D ($59E2/$5A63/$5AB4/$5AF1)',
                     labels={0x9A63: ['UnknownData_0x9A63'], 0x9AB4: ['UnknownData_0x9AB4'], 0x9AF1: ['UnknownData_0x9AF1']},
                     seg_comments={0x9A63: 'second blob (base $5A63)', 0x9AB4: 'third blob (base $5AB4)', 0x9AF1: 'fourth blob (base $5AF1)'}),
        0x9C67: dict(segs=[('code', 0x9C67, 0x9C6C)]),
        0x9CA2: dict(segs=[('dw', 0x9CA2, 0x9CAC)],
                     comment='five ascending dw values ($5CAC/$5CD4/...); no direct reader found'),
        0x9D79: dict(segs=[('dw', 0x9D79, 0x9D83)],
                     comment='five dw values ($5CAC/$5CD4/$5D83/...); no direct reader found'),
        0x9E5D: dict(segs=[('dw', 0x9E5D, 0x9E67)],
                     comment='five dw values ($5CAC/$5CD4/$5E67/...); no direct reader found'),
        0x9F38: dict(segs=[('dw', 0x9F38, 0x9F46)],
                     comment='seven dw values ($5CAC/$5443/$5F46/...); no direct reader found'),
        0x9FA4: dict(segs=[('code', 0x9FA4, 0x9FD1)]),
        0xA05E: dict(segs=[('dw', 0xA05E, 0xA064)],
                     comment='three dw values ($607D/$608C/$6064); no direct reader found'),
        0xA08C: dict(segs=[('code', 0xA08C, 0xA099)]),
        0xA105: dict(segs=[('dw', 0xA105, 0xA117)],
                     comment='dw values in the $5Cxx-$62xx domain ($5CAC first); no direct reader found'),
        0xA297: dict(segs=[('dw', 0xA297, 0xA29B)],
                     comment='two dw values ($629B/$62A7); no direct reader found'),
        0xA2E5: dict(segs=[('dw', 0xA2E5, 0xA2F1)],
                     comment='six dw values ($6300/$630C/$62F1/...); no direct reader found'),
        0xA3C1: dict(segs=[('dw', 0xA3C1, 0xA3FF)],
                     comment='31 dw values ($5CAC + 30 ascending $6420-$688C into the $A4xx-$A8xx table region); no direct reader found'),
        0xA472: dict(segs=[('db', 0xA472, 0xA4A5)],
                     comment='byte table read via UnknownCall_0xB16B at $6472 (line 5742)'),
        0xA4EA: dict(segs=[('db', 0xA4EA, 0xA504)],
                     comment='byte table read via UnknownCall_0xB16B at $64EA (6 call sites: lines 5784/5910/5954/6121/6166/6240)'),
        0xA58F: dict(segs=[('db', 0xA58F, 0xA5A0), ('db', 0xA5A0, 0xA5B0)],
                     comment='byte table read via UnknownCall_0xB16B at $658F (line 5867)',
                     labels={0xA5A0: ['UnknownData_0xA5A0']},
                     seg_comments={0xA5A0: 'second table at $65A0 (line 5873, via $B26A caller)'}),
        0xA6B7: dict(segs=[('db', 0xA6B7, 0xA6CE)],
                     comment='byte table read via UnknownCall_0xB16B at $66B7 (line 6014)'),
        0xA730: dict(segs=[('db', 0xA730, 0xA747)],
                     comment='byte table read via UnknownCall_0xB16B at $6730 (line 6078)'),
        0xA90E: dict(segs=[('dw', 0xA90E, 0xA920)],
                     comment='dw values ($5CAC/$6920/$69BD/... in the $69xx-$6Axx domain); no direct reader found'),
        0xAAA8: dict(segs=[('dw', 0xAAA8, 0xAAB0)],
                     comment='four ascending dw values ($6AB0-$6B01); no direct reader found'),
        0xAB33: dict(segs=[('dw', 0xAB33, 0xAB37)],
                     comment='two dw values ($6B37/$6B4D); no direct reader found'),
        0xAB71: dict(segs=[('dw', 0xAB71, 0xAB75)],
                     comment='two dw values ($6B75/$6B4D); no direct reader found'),
        0xAC04: dict(segs=[('dw', 0xAC04, 0xAC1A)],
                     comment='dw values ($5CAC/$6920/... spanning $69xx-$6Dxx); no direct reader found'),
        0xADFD: dict(segs=[('dw', 0xADFD, 0xAE17)],
                     comment='dw values ($5CAC/$6E17/... spanning $6Cxx-$6Fxx); no direct reader found'),
        0xAFE6: dict(segs=[('dw', 0xAFE6, 0xAFEC)],
                     comment='three ascending dw values ($6FEC/$7000/$7015); no direct reader found'),
        0xB039: dict(segs=[('db', 0xB039, 0xB0C2)],
                     comment='byte table read via UnknownCall_0xB16B at $7039 (lines 7321/7333); values $01-$04 with $FC-$FE negatives'),
        0xB0C5: dict(segs=[('dw', 0xB0C5, 0xB0CF)],
                     comment='five dw pointers into the $B0CF-$B16B code region ($70CF/$70D3/$70DA/$711E/$714D); reader not identified'),
        0xB0FB: dict(segs=[('code', 0xB0FB, 0xB101)]),
        0xB105: dict(segs=[('code', 0xB105, 0xB10F)]),
        0xB173: dict(segs=[('code', 0xB173, 0xB177)]),
        0xB18B: dict(segs=[('code', 0xB18B, 0xB18F)]),
        0xB1A3: dict(segs=[('db', 0xB1A3, 0xB1C8)],
                     comment='37-entry byte table read via UnknownCall_0xB16B from the UnknownRJump_0xB191 loader family ($71A3, line 7502)'),
        0xB1DD: dict(segs=[('code', 0xB1DD, 0xB1E4)]),
        0xB1FF: dict(segs=[('db', 0xB1FF, 0xB224)],
                     comment='37-entry byte table with sub-tables at $B208/$B20E/$B211/$B214/$B217, read via UnknownCall_0xB16B (lines 7519-7545)'),
        0xB2AF: dict(segs=[('code', 0xB2AF, 0xB2C2)]),
        0xB356: dict(segs=[('db', 0xB356, 0xB35A)],
                     comment='4-entry byte table indexed via de at $7356 (line 7773)'),
        0xB388: dict(segs=[('db', 0xB388, 0xB38C)],
                     comment='4-entry byte table indexed via de at $7388 (line 7802)'),
        0xB3B4: dict(segs=[('db', 0xB3B4, 0xB3B9)],
                     comment='5-entry byte table indexed via de at $73B4 (line 7843)'),
        0xB3FB: dict(segs=[('code', 0xB3FB, 0xB402)]),
        0xB41A: dict(segs=[('db', 0xB41A, 0xC000)],
                     comment='bank tail after the $B16B blob region; no direct reader found'),
    },
    0x03: {
        0xC0B1: dict(segs=[('dw', 0xC0B1, 0xC201)],
                     comment='sprite-mapping pointer table, selected when [$AF06] == 0 (else $CF11) by UnknownCall_0xC000 (lines 8493/8497); 168 entries pointing into the gfx/spritemappings2/3 regions ($C202+)'),
        0xCF11: dict(segs=[('dw', 0xCF11, 0xD0D9)],
                     comment='sprite-mapping pointer table, selected when [$AF06] != 0; 228 entries pointing into the gfx/spritemappings regions',
                     labels={0xCF11: ['UnknownData_0xCF11']}),
        0xE037: dict(segs=[('dw', 0xE037, 0xE077), ('db', 0xE077, 0xEBB6)],
                     comment='per-level dw table, indexed by sCurLevel * 2 (32 entries; read at line 8644)',
                     labels={0xE037: ['UnknownData_0xE037']},
                     seg_comments={0xE077: 'level payload records (targets of the table above)'}),
        0xEC61: dict(segs=[('db', 0xEC61, 0xFFA0)],
                     comment='packed data ($AA-heavy; same family as the bank tails); no direct reader found'),
        0xFFA0: dict(segs=[('db', 0xFFA0, 0x10000)],
                     comment='packed data tail; the $FFA0 labels reflect the `call $FFA0` HRAM OAM-DMA convention (OAMDMARoutine in home.asm), not this data'),
    },
    0x05: {
        0x14000: dict(segs=[('code', 0x14000, 0x14043)]),
        0x140A8: dict(segs=[('code', 0x140A8, 0x140D6)]),
        0x14121: dict(segs=[('db', 0x14121, 0x14125), ('dw', 0x14125, 0x14165), ('db', 0x14165, 0x141E5)],
                     comment='title-screen data: 4 per-slot bytes ($00/$11/$0E/$14, read as $4121 + ([$A0F0] & 3) at lines 11820 / $140AC)',
                     seg_comments={0x14125: '32-entry ascending dw table ($4165-$41E2)',
                                   0x14165: 'payload (title-screen data) for the table above'}),
        0x159E5: dict(segs=[('db', 0x159E5, 0x18000)],
                     comment='bank tail after the title screen graphics (packed $AA-heavy data + zero padding); no direct reader found'),
    },
    0x09: {
        0x24000: dict(segs=[('db', 0x24000, 0x242F0)],
                     comment='per-level group block preceding the Level_01/26/27/28 pointer list'),
        0x242F8: dict(segs=[('db', 0x242F8, 0x24500)],
                     comment='shared group block between the pointer list and Level_01',
                     labels={0x242F8: ['UnknownData_0x242F8']}),
        0x25CF7: dict(segs=[('db', 0x25CF7, 0x28000)],
                     comment='level-data tail after the last layout stream (level28.bin) in bank $09',
                     labels={0x25CF7: ['UnknownData_0x25CF7']}),
    },
    0x14: {
        0x50000: dict(segs=[('db', 0x50000, 0x502F0)],
                      comment='per-level group block preceding the Level_15/16/17 pointer list'),
        0x502F6: dict(segs=[('db', 0x502F6, 0x50500)],
                      comment='shared group block between the pointer list and Level_15',
                      labels={0x502F6: ['UnknownData_0x502F6']}),
        0x52341: dict(segs=[('db', 0x52341, 0x54000)],
                      comment='level-data tail after the last layout stream (level17.bin) in bank $14',
                      labels={0x52341: ['UnknownData_0x52341']}),
    },
    0x15: {
        0x54000: dict(segs=[('db', 0x54000, 0x542F0)],
                      comment='per-level group block preceding the Level_21/22/23/24 pointer list'),
        0x542F8: dict(segs=[('db', 0x542F8, 0x54500)],
                      comment='shared group block between the pointer list and Level_21',
                      labels={0x542F8: ['UnknownData_0x542F8']}),
        0x562DE: dict(segs=[('db', 0x562DE, 0x58000)],
                      comment='level-data tail after the last layout stream (level24.bin) in bank $15',
                      labels={0x562DE: ['UnknownData_0x562DE']}),
    },
    0x04: {
        0x1001D: dict(segs=[('db', 0x1001D, 0x1002D)],
                     comment='sound bank data; no direct reader found'),
        0x1007E: dict(segs=[('db', 0x1007E, 0x100DE)],
                     comment='sound data block, read via `ld hl, $407E` in the surrounding engine code (line 9482)'),
        0x10134: dict(segs=[('db', 0x10134, 0x1013A)],
                     comment='sound data block, read via `ld hl, $4134` in the surrounding engine code (line 9497)'),
        0x10152: dict(segs=[('db', 0x10152, 0x1015E)],
                     comment='sound data block, read via `ld hl, $4152` in the surrounding engine code (line 9506)'),
        0x1017C: dict(segs=[('db', 0x1017C, 0x10188)],
                     comment='sound data block, read via `ld hl, $417C` in the surrounding engine code (line 9522)'),
        0x101A3: dict(segs=[('db', 0x101A3, 0x101A9)],
                     comment='sound data block, read via `ld hl, $41A3` in the surrounding engine code (line 9537)'),
        0x101D3: dict(segs=[('db', 0x101D3, 0x101F3)],
                     comment='sound data block, read via `ld hl, $41D3` in the surrounding engine code (line 9560)'),
        0x1020B: dict(segs=[('db', 0x1020B, 0x10217)],
                     comment='sound data block, read via `ld hl, $420B` in the surrounding engine code (line 9574)'),
        0x1022F: dict(segs=[('db', 0x1022F, 0x10238)],
                     comment='sound data block, read via `ld hl, $422F` in the surrounding engine code (line 9587)'),
        0x10253: dict(segs=[('db', 0x10253, 0x10271)],
                     comment='sound data block, read via `ld hl, $4253` in the surrounding engine code (line 9607)'),
        0x1029E: dict(segs=[('db', 0x1029E, 0x102B2)],
                     comment='sound data block, read via `ld hl, $429E` in the surrounding engine code (line 9628)'),
        0x102CD: dict(segs=[('db', 0x102CD, 0x102E2)],
                     comment='sound data block, read via `ld hl, $42CD` in the surrounding engine code (line 9648)'),
        0x10333: dict(segs=[('db', 0x10333, 0x1034E)],
                     comment='sound data block, read via `ld hl, $4333` in the surrounding engine code (line 9682)'),
        0x10374: dict(segs=[('db', 0x10374, 0x1038E)],
                     comment='sound data block, read via `ld hl, $4374` in the surrounding engine code (line 9711)'),
        0x103C0: dict(segs=[('db', 0x103C0, 0x103DC)],
                     comment='sound data block, read via `ld hl, $43C0` in the surrounding engine code (line 9737)'),
        0x103FA: dict(segs=[('db', 0x103FA, 0x10408)],
                     comment='sound bank data; no direct reader found'),
        0x10431: dict(segs=[('db', 0x10431, 0x10465)],
                     comment='sound data block, read via `ld hl, $4431` in the surrounding engine code (line 9772)'),
        0x10486: dict(segs=[('db', 0x10486, 0x1049C)],
                     comment='sound bank data; no direct reader found'),
        0x104C2: dict(segs=[('db', 0x104C2, 0x104D8)],
                     comment='sound data block, read via `ld hl, $44C2` in the surrounding engine code (line 9816)'),
        0x10514: dict(segs=[('db', 0x10514, 0x10560)],
                     comment='sound data block, read via `ld hl, $4514` in the surrounding engine code (line 9849)'),
        0x1058D: dict(segs=[('db', 0x1058D, 0x1059B)],
                     comment='sound data block, read via `ld hl, $458D` in the surrounding engine code (line 9880)'),
        0x105CC: dict(segs=[('db', 0x105CC, 0x105F1)],
                     comment='sound data block, read via `ld hl, $45CC` in the surrounding engine code (line 9900)'),
        0x1061E: dict(segs=[('db', 0x1061E, 0x1062C)],
                     comment='sound data block, read via `ld hl, $461E` in the surrounding engine code (line 9935)'),
        0x10652: dict(segs=[('db', 0x10652, 0x10680)],
                     comment='sound data block, read via `ld hl, $4652` in the surrounding engine code (line 9958)'),
        0x106C6: dict(segs=[('db', 0x106C6, 0x106CC)],
                     comment='sound data block, read via `ld hl, $46C6` in the surrounding engine code (line 9551)'),
        0x106FA: dict(segs=[('db', 0x106FA, 0x1075A)],
                     comment='sound bank data; no direct reader found'),
        0x107A3: dict(segs=[('db', 0x107A3, 0x1080A)],
                     comment='sound data block, read via `ld hl, $47A3` in the surrounding engine code (line 10062)'),
        0x10844: dict(segs=[('db', 0x10844, 0x1089C)],
                     comment='sound data block, read via `ld hl, $4844` in the surrounding engine code (line 10095)'),
        0x108D4: dict(segs=[('db', 0x108D4, 0x108F7)],
                     comment='sound data block, read via `ld hl, $48D4` in the surrounding engine code (line 10123)'),
        0x10924: dict(segs=[('db', 0x10924, 0x10932)],
                     comment='sound data block, read via `ld hl, $4924` in the surrounding engine code (line 10153)'),
        0x10968: dict(segs=[('db', 0x10968, 0x10994)],
                     comment='sound data block, read via `ld hl, $4968` in the surrounding engine code (line 10177)'),
        0x109D9: dict(segs=[('db', 0x109D9, 0x109F9)],
                     comment='sound data block, read via `ld hl, $49D9` in the surrounding engine code (line 10222)'),
        0x10A26: dict(segs=[('db', 0x10A26, 0x10A34)],
                     comment='sound data block, read via `ld hl, $4A26` in the surrounding engine code (line 10241)'),
        0x10A6B: dict(segs=[('db', 0x10A6B, 0x10AEA)],
                     comment='sound data block, read via `ld hl, $4A6B` in the surrounding engine code (line 10266)'),
        0x10B04: dict(segs=[('db', 0x10B04, 0x10B1A)],
                     comment='sound data block, read via `ld hl, $4B04` in the surrounding engine code (line 10290)'),
        0x10B5B: dict(segs=[('db', 0x10B5B, 0x10B95)],
                     comment='sound data block, read via `ld hl, $4B5B` in the surrounding engine code (line 10309)'),
        0x10BBC: dict(segs=[('db', 0x10BBC, 0x10BC2)],
                     comment='sound data block, read via `ld hl, $4BBC` in the surrounding engine code (line 10346)'),
        0x10BFB: dict(segs=[('db', 0x10BFB, 0x10C2F)],
                     comment='sound data block, read via `ld hl, $4BFB` in the surrounding engine code (line 10367)'),
        0x10C42: dict(segs=[('db', 0x10C42, 0x10C48)],
                     comment='sound data block, read via `ld hl, $4C42` in the surrounding engine code (line 10384)'),
        0x10C6A: dict(segs=[('db', 0x10C6A, 0x10C72)],
                     comment='sound data block, read via `ld hl, $4C6A` in the surrounding engine code (line 10407)'),
        0x10C87: dict(segs=[('db', 0x10C87, 0x10C8F)],
                     comment='sound data block, read via `ld hl, $4C87` in the surrounding engine code (line 10420)'),
        0x10CAD: dict(segs=[('db', 0x10CAD, 0x10CE1)],
                     comment='sound data block, read via `ld hl, $4CAD` in the surrounding engine code (line 10434)'),
        0x10D12: dict(segs=[('db', 0x10D12, 0x10D38)],
                     comment='sound data block, read via `ld hl, $4D12` in the surrounding engine code (line 10455)'),
        0x10D56: dict(segs=[('db', 0x10D56, 0x10D6C)],
                     comment='sound data block, read via `ld hl, $4D56` in the surrounding engine code (line 10478)'),
        0x10DA4: dict(segs=[('db', 0x10DA4, 0x10DAE)],
                     comment='sound data block, read via `ld hl, $4DA4` in the surrounding engine code (line 10496)'),
        0x10DE1: dict(segs=[('db', 0x10DE1, 0x10DEB)],
                     comment='sound data block, read via `ld hl, $4DE1` in the surrounding engine code (line 10534)'),
        0x10E11: dict(segs=[('db', 0x10E11, 0x10E17)],
                     comment='sound bank data; no direct reader found'),
        0x10E3C: dict(segs=[('db', 0x10E3C, 0x10E43)],
                     comment='sound data block, read via `ld hl, $4E3C` in the surrounding engine code (line 10574)'),
        0x10E64: dict(segs=[('db', 0x10E64, 0x10E90)],
                     comment='sound data block, read via `ld hl, $4E64` in the surrounding engine code (line 10636)'),
        0x10ECE: dict(segs=[('db', 0x10ECE, 0x10EEB)],
                     comment='sound bank data; no direct reader found'),
        0x10F1E: dict(segs=[('db', 0x10F1E, 0x10F4B)],
                     comment='sound data block, read via `ld hl, $4F1E` in the surrounding engine code (line 10683)'),
        0x10F60: dict(segs=[('db', 0x10F60, 0x10F6A)],
                     comment='sound data block, read via `ld hl, $4F60` in the surrounding engine code (line 10697)'),
        0x10F7D: dict(segs=[('db', 0x10F7D, 0x10F82)],
                     comment='sound data block, read via `ld hl, $4F7D` in the surrounding engine code (line 10710)'),
        0x10F9D: dict(segs=[('db', 0x10F9D, 0x10FC5)],
                     comment='sound data block, read via `ld hl, $4F9D` in the surrounding engine code (line 10726)'),
        0x10FE0: dict(segs=[('db', 0x10FE0, 0x11008)],
                     comment='sound data block, read via `ld hl, $4FE0` in the surrounding engine code (line 10740)'),
        0x11026: dict(segs=[('db', 0x11026, 0x11030)],
                     comment='sound data block, read via `ld hl, $5026` in the surrounding engine code (line 10750)'),
        0x1105B: dict(segs=[('db', 0x1105B, 0x11086)],
                     comment='sound bank data; no direct reader found'),
        0x110AE: dict(segs=[('db', 0x110AE, 0x110DC)],
                     comment='sound data block, read via `ld hl, $50AE` in the surrounding engine code (line 10794)'),
        0x110FC: dict(segs=[('db', 0x110FC, 0x1111C)],
                     comment='sound data block, read via `ld hl, $50FC` in the surrounding engine code (line 10815)'),
        0x11137: dict(segs=[('db', 0x11137, 0x11163)],
                     comment='sound data block, read via `ld hl, $5137` in the surrounding engine code (line 10829)'),
        0x1119A: dict(segs=[('db', 0x1119A, 0x1119F)],
                     comment='sound data block, read via `ld hl, $519A` in the surrounding engine code (line 10849)'),
        0x111E2: dict(segs=[('code', 0x111E2, 0x111E8)]),
        0x111EE: dict(segs=[('code', 0x111EE, 0x111F4)]),
        0x11244: dict(segs=[('db', 0x11244, 0x11298)],
                     comment='sound data block, read via `ld hl, $5244` in the surrounding engine code (line 11075)'),
        0x112B4: dict(segs=[('code', 0x112B4, 0x112DD)]),
        0x112F7: dict(segs=[('db', 0x112F7, 0x113F3)],
                     comment='sound data block, read via `ld hl, $52F7` in the surrounding engine code (line 11087)'),
        0x11428: dict(segs=[('code', 0x11428, 0x11449)]),
        0x11573: dict(segs=[('code', 0x11573, 0x1157C)]),
        0x115EA: dict(segs=[('code', 0x115EA, 0x115F3)]),
        0x11753: dict(segs=[('code', 0x11753, 0x11755)]),
        0x11966: dict(segs=[('db', 0x11966, 0x11989)],
                     comment='sound data block, read via `ld hl, $5966` in the surrounding engine code (line 12014)'),
        0x11ACC: dict(segs=[('db', 0x11ACC, 0x13F5E)],
                     comment='music and sound data (song tracks; in-bank pointers into it live in the home.asm song table: `dw $6A00, $6D80, $7100, $7480` at line 972 and the $5xxx/$6xxx/$7xxx pairs at lines 5079-5093)'),
        0x13FFD: dict(segs=[('db', 0x13FFD, 0x14000)],
                     comment='bank tail (3 bytes); no direct reader found'),
    },
    0x16: {
        0x58040: dict(segs=[('db', 0x58040, 0x58101)],
                     comment='data block; no direct reader found'),
        0x58112: dict(segs=[('db', 0x58112, 0x5811A)],
                     comment='data block; no direct reader found'),
        0x5821E: dict(segs=[('db', 0x5821E, 0x58226)],
                     comment='data block; no direct reader found'),
        0x582E7: dict(segs=[('code', 0x582E7, 0x582EE)]),
        0x582F7: dict(segs=[('db', 0x582F7, 0x582FB)],
                     comment='data block; no direct reader found'),
        0x583B4: dict(segs=[('db', 0x583B4, 0x583BC)],
                     comment='data block; no direct reader found'),
        0x58461: dict(segs=[('db', 0x58461, 0x58463)],
                     comment='data block; no direct reader found'),
        0x5855E: dict(segs=[('db', 0x5855E, 0x58566)],
                     comment='data block; no direct reader found'),
        0x58646: dict(segs=[('db', 0x58646, 0x5864E)],
                     comment='data block; no direct reader found'),
        0x586EB: dict(segs=[('db', 0x586EB, 0x586EE)],
                     comment='data block; no direct reader found'),
        0x58807: dict(segs=[('db', 0x58807, 0x5880F)],
                     comment='data block; no direct reader found'),
        0x5885D: dict(segs=[('db', 0x5885D, 0x58865)],
                     comment='data block; no direct reader found'),
        0x588FA: dict(segs=[('code', 0x588FA, 0x58900)]),
        0x589BE: dict(segs=[('db', 0x589BE, 0x589CA)],
                     comment='data block; no direct reader found'),
        0x589E1: dict(segs=[('code', 0x589E1, 0x589E7)]),
        0x589F0: dict(segs=[('code', 0x589F0, 0x589F7)]),
        0x58A0E: dict(segs=[('code', 0x58A0E, 0x58A3D)]),
        0x58A7A: dict(segs=[('db', 0x58A7A, 0x58A82)],
                     comment='data block; no direct reader found'),
        0x58ADB: dict(segs=[('code', 0x58ADB, 0x58AE7)]),
        0x58B31: dict(segs=[('code', 0x58B31, 0x58B43)]),
        0x58B54: dict(segs=[('db', 0x58B54, 0x58B58)],
                     comment='data block; no direct reader found'),
        0x58BDE: dict(segs=[('db', 0x58BDE, 0x58BE6)],
                     comment='data block; no direct reader found'),
        0x58C7D: dict(segs=[('db', 0x58C7D, 0x58C85)],
                     comment='data block; no direct reader found'),
        0x58CFD: dict(segs=[('db', 0x58CFD, 0x58D01)],
                     comment='data block; no direct reader found'),
        0x58D4E: dict(segs=[('code', 0x58D4E, 0x58D78)]),
        0x58DE1: dict(segs=[('db', 0x58DE1, 0x58DE5)],
                     comment='data block; no direct reader found'),
        0x58E32: dict(segs=[('db', 0x58E32, 0x58E38)],
                     comment='data block; no direct reader found'),
        0x58E9B: dict(segs=[('db', 0x58E9B, 0x58EA7)],
                     comment='data block; no direct reader found'),
        0x58EBE: dict(segs=[('code', 0x58EBE, 0x58EC8)]),
        0x58EE4: dict(segs=[('code', 0x58EE4, 0x58EE9)]),
        0x58F05: dict(segs=[('code', 0x58F05, 0x58F0A)]),
        0x58F26: dict(segs=[('code', 0x58F26, 0x58F2B)]),
        0x58F39: dict(segs=[('code', 0x58F39, 0x58F4C)]),
        0x58F5F: dict(segs=[('db', 0x58F5F, 0x58F69)],
                     comment='data block; no direct reader found'),
        0x58F8C: dict(segs=[('code', 0x58F8C, 0x58FA5)]),
        0x58FC0: dict(segs=[('code', 0x58FC0, 0x5902D)]),
        0x5907A: dict(segs=[('db', 0x5907A, 0x59092)],
                     comment='data block; no direct reader found'),
        0x59125: dict(segs=[('db', 0x59125, 0x59136)],
                     comment='data block, read at line 29129'),
        0x59154: dict(segs=[('code', 0x59154, 0x59166)]),
        0x5918B: dict(segs=[('db', 0x5918B, 0x5918F)],
                     comment='data block; no direct reader found'),
        0x591CE: dict(segs=[('db', 0x591CE, 0x591D2)],
                     comment='data block; no direct reader found'),
        0x591F1: dict(segs=[('db', 0x591F1, 0x591F3)],
                     comment='data block; no direct reader found'),
        0x59216: dict(segs=[('db', 0x59216, 0x5921E)],
                     comment='data block; no direct reader found'),
        0x5923F: dict(segs=[('code', 0x5923F, 0x59243)]),
        0x59264: dict(segs=[('code', 0x59264, 0x59268)]),
        0x5928C: dict(segs=[('db', 0x5928C, 0x59298)],
                     comment='data block; no direct reader found'),
        0x59342: dict(segs=[('code', 0x59342, 0x5934A)]),
        0x59354: dict(segs=[('db', 0x59354, 0x5935C)],
                     comment='data block; no direct reader found'),
        0x5938E: dict(segs=[('db', 0x5938E, 0x59394)],
                     comment='data block; no direct reader found'),
        0x593F4: dict(segs=[('db', 0x593F4, 0x593F8)],
                     comment='data block; no direct reader found'),
        0x59448: dict(segs=[('code', 0x59448, 0x5944F)]),
        0x59475: dict(segs=[('code', 0x59475, 0x5947C)]),
        0x594A0: dict(segs=[('db', 0x594A0, 0x594A4)],
                     comment='data block; no direct reader found'),
        0x594AD: dict(segs=[('code', 0x594AD, 0x594EB)]),
        0x5950E: dict(segs=[('db', 0x5950E, 0x59512)],
                     comment='data block; no direct reader found'),
        0x595D3: dict(segs=[('db', 0x595D3, 0x595D7)],
                     comment='data block; no direct reader found'),
        0x5961D: dict(segs=[('db', 0x5961D, 0x59621)],
                     comment='data block; no direct reader found'),
        0x5966C: dict(segs=[('code', 0x5966C, 0x596D9)]),
        0x596E8: dict(segs=[('db', 0x596E8, 0x596EE)],
                     comment='data block; no direct reader found'),
        0x597DE: dict(segs=[('db', 0x597DE, 0x597EE)],
                     comment='data block; no direct reader found'),
        0x59838: dict(segs=[('code', 0x59838, 0x598CE)]),
        0x59927: dict(segs=[('code', 0x59927, 0x599A6)]),
        0x599B6: dict(segs=[('db', 0x599B6, 0x599C4)],
                     comment='data block, read at line 30260'),
        0x59A8D: dict(segs=[('db', 0x59A8D, 0x59AAD)],
                     comment='zero padding'),
        0x59AC6: dict(segs=[('db', 0x59AC6, 0x59ACA)],
                     comment='data block; no direct reader found'),
        0x59B31: dict(segs=[('db', 0x59B31, 0x59B35)],
                     comment='data block; no direct reader found'),
        0x59B49: dict(segs=[('code', 0x59B49, 0x59B54)]),
        0x59B68: dict(segs=[('code', 0x59B68, 0x59B73)]),
        0x59BC1: dict(segs=[('db', 0x59BC1, 0x59BC5)],
                     comment='data block; no direct reader found'),
        0x59BCB: dict(segs=[('db', 0x59BCB, 0x59BD1)],
                     comment='data block; no direct reader found'),
        0x59BE4: dict(segs=[('db', 0x59BE4, 0x59BE8)],
                     comment='data block; no direct reader found'),
        0x59C07: dict(segs=[('db', 0x59C07, 0x59CE7)],
                     comment='data block; no direct reader found'),
        0x59D01: dict(segs=[('db', 0x59D01, 0x59D05)],
                     comment='data block; no direct reader found'),
        0x59D72: dict(segs=[('db', 0x59D72, 0x59D7A)],
                     comment='data block; no direct reader found'),
        0x59E28: dict(segs=[('db', 0x59E28, 0x59E2C)],
                     comment='data block; no direct reader found'),
        0x59E72: dict(segs=[('db', 0x59E72, 0x59E7A)],
                     comment='data block; no direct reader found'),
        0x59F20: dict(segs=[('db', 0x59F20, 0x59F24)],
                     comment='data block; no direct reader found'),
        0x59F7F: dict(segs=[('db', 0x59F7F, 0x59F83)],
                     comment='data block; no direct reader found'),
        0x59FF2: dict(segs=[('db', 0x59FF2, 0x59FF8)],
                     comment='data block; no direct reader found'),
        0x5A04B: dict(segs=[('code', 0x5A04B, 0x5A04F)]),
        0x5A051: dict(segs=[('db', 0x5A051, 0x5A055)],
                     comment='data block; no direct reader found'),
        0x5A06F: dict(segs=[('code', 0x5A06F, 0x5A07E)]),
        0x5A0CD: dict(segs=[('db', 0x5A0CD, 0x5A0D5)],
                     comment='data block; no direct reader found'),
        0x5A140: dict(segs=[('db', 0x5A140, 0x5A148)],
                     comment='data block; no direct reader found'),
        0x5A18F: dict(segs=[('db', 0x5A18F, 0x5A197)],
                     comment='data block; no direct reader found'),
        0x5A206: dict(segs=[('db', 0x5A206, 0x5A20C)],
                     comment='data block; no direct reader found'),
        0x5A248: dict(segs=[('db', 0x5A248, 0x5A24A)],
                     comment='data block; no direct reader found'),
        0x5A275: dict(segs=[('db', 0x5A275, 0x5A27B)],
                     comment='data block; no direct reader found'),
        0x5A2ED: dict(segs=[('db', 0x5A2ED, 0x5A2F7)],
                     comment='data block; no direct reader found'),
        0x5A32E: dict(segs=[('db', 0x5A32E, 0x5A332)],
                     comment='data block; no direct reader found'),
        0x5A365: dict(segs=[('code', 0x5A365, 0x5A376)]),
        0x5A4ED: dict(segs=[('db', 0x5A4ED, 0x5A545)],
                     comment='data block; no direct reader found'),
        0x5A574: dict(segs=[('db', 0x5A574, 0x5A578)],
                     comment='data block; no direct reader found'),
        0x5A5E1: dict(segs=[('db', 0x5A5E1, 0x5A5E3)],
                     comment='data block; no direct reader found'),
        0x5A607: dict(segs=[('db', 0x5A607, 0x5A60F)],
                     comment='data block; no direct reader found'),
        0x5A67B: dict(segs=[('db', 0x5A67B, 0x5A683)],
                     comment='data block; no direct reader found'),
        0x5A693: dict(segs=[('db', 0x5A693, 0x5A69B)],
                     comment='data block; no direct reader found'),
        0x5A6FB: dict(segs=[('db', 0x5A6FB, 0x5A6FF)],
                     comment='data block; no direct reader found'),
        0x5A74D: dict(segs=[('db', 0x5A74D, 0x5A751)],
                     comment='data block; no direct reader found'),
        0x5A78B: dict(segs=[('db', 0x5A78B, 0x5A793)],
                     comment='data block; no direct reader found'),
        0x5A836: dict(segs=[('db', 0x5A836, 0x5A83E)],
                     comment='data block; no direct reader found'),
        0x5A85C: dict(segs=[('code', 0x5A85C, 0x5A8D2)]),
        0x5A915: dict(segs=[('db', 0x5A915, 0x5A91D)],
                     comment='data block; no direct reader found'),
        0x5A92D: dict(segs=[('code', 0x5A92D, 0x5A939)]),
        0x5A94D: dict(segs=[('db', 0x5A94D, 0x5A953)],
                     comment='data block; no direct reader found'),
        0x5A977: dict(segs=[('db', 0x5A977, 0x5A979)],
                     comment='data block; no direct reader found'),
        0x5A9B2: dict(segs=[('db', 0x5A9B2, 0x5A9B6)],
                     comment='data block; no direct reader found'),
        0x5A9BD: dict(segs=[('db', 0x5A9BD, 0x5A9C2)],
                     comment='data block; no direct reader found'),
        0x5A9C8: dict(segs=[('code', 0x5A9C8, 0x5A9D3)]),
        0x5AA16: dict(segs=[('db', 0x5AA16, 0x5AA20)],
                     comment='data block; no direct reader found'),
        0x5AA89: dict(segs=[('db', 0x5AA89, 0x5AA8F)],
                     comment='data block; no direct reader found'),
        0x5AABC: dict(segs=[('db', 0x5AABC, 0x5AAC6)],
                     comment='data block; no direct reader found'),
        0x5AB4E: dict(segs=[('db', 0x5AB4E, 0x5AB58)],
                     comment='data block; no direct reader found'),
        0x5AB7F: dict(segs=[('db', 0x5AB7F, 0x5AB89)],
                     comment='data block; no direct reader found'),
        0x5AC04: dict(segs=[('db', 0x5AC04, 0x5AC08)],
                     comment='data block; no direct reader found'),
        0x5AC3F: dict(segs=[('db', 0x5AC3F, 0x5AC47)],
                     comment='data block; no direct reader found'),
        0x5AC78: dict(segs=[('code', 0x5AC78, 0x5AC7D)]),
        0x5AC80: dict(segs=[('db', 0x5AC80, 0x5AC88)],
                     comment='data block; no direct reader found'),
        0x5ACE7: dict(segs=[('db', 0x5ACE7, 0x5ACED)],
                     comment='data block; no direct reader found'),
        0x5AD30: dict(segs=[('db', 0x5AD30, 0x5AD36)],
                     comment='data block; no direct reader found'),
        0x5AD50: dict(segs=[('db', 0x5AD50, 0x5AD5A)],
                     comment='data block; no direct reader found'),
        0x5ADE3: dict(segs=[('db', 0x5ADE3, 0x5ADED)],
                     comment='data block; no direct reader found'),
        0x5AE62: dict(segs=[('db', 0x5AE62, 0x5AEF4)],
                     comment='data block, read at line 32998'),
        0x5AEFA: dict(segs=[('db', 0x5AEFA, 0x5AF04)],
                     comment='data block; no direct reader found'),
        0x5AF55: dict(segs=[('db', 0x5AF55, 0x5AFD7)],
                     comment='data block, read at line 33080'),
        0x5AFDA: dict(segs=[('db', 0x5AFDA, 0x5AFE4)],
                     comment='data block; no direct reader found'),
        0x5B070: dict(segs=[('db', 0x5B070, 0x5B078)],
                     comment='data block; no direct reader found'),
        0x5B08C: dict(segs=[('db', 0x5B08C, 0x5B091)],
                     comment='data block; no direct reader found'),
        0x5B0DB: dict(segs=[('db', 0x5B0DB, 0x5B0E5)],
                     comment='data block; no direct reader found'),
        0x5B17D: dict(segs=[('db', 0x5B17D, 0x5B183)],
                     comment='data block; no direct reader found'),
        0x5B1CB: dict(segs=[('db', 0x5B1CB, 0x5B1D3)],
                     comment='data block; no direct reader found'),
        0x5B244: dict(segs=[('db', 0x5B244, 0x5B24A)],
                     comment='data block; no direct reader found'),
        0x5B28F: dict(segs=[('db', 0x5B28F, 0x5B295)],
                     comment='data block; no direct reader found'),
        0x5B3B9: dict(segs=[('code', 0x5B3B9, 0x5B3C6)]),
        0x5B488: dict(segs=[('db', 0x5B488, 0x5B4B4)],
                     comment='data block, read at line 33841'),
        0x5B52D: dict(segs=[('code', 0x5B52D, 0x5B539)]),
        0x5B57A: dict(segs=[('db', 0x5B57A, 0x5B57E)],
                     comment='data block, read at line 34013'),
        0x5B5A2: dict(segs=[('db', 0x5B5A2, 0x5B5A6)],
                     comment='data block, read at line 34053'),
        0x5B5D3: dict(segs=[('db', 0x5B5D3, 0x5B5D8)],
                     comment='data block, read at line 34096'),
        0x5B603: dict(segs=[('db', 0x5B603, 0x5B607)],
                     comment='data block, read at line 34136'),
        0x5B635: dict(segs=[('db', 0x5B635, 0x5B639)],
                     comment='data block, read at line 34165'),
        0x5B669: dict(segs=[('db', 0x5B669, 0x5B678)],
                     comment='data block, read at line 34194'),
        0x5B684: dict(segs=[('code', 0x5B684, 0x5B68B)]),
        0x5B70A: dict(segs=[('db', 0x5B70A, 0x5C000)],
                     comment='bank tail (packed data/tables); no direct reader found'),
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
    pref = {'call': 'UnknownCall', 'jp': 'UnknownJump', 'jt': 'UnknownJump', 'jr': 'UnknownRJump'}.get(kind)
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
    name = f'{pref}_0x{rom:04X}'  # convention: zero-padded to 4 digits ('0x03F1', '0x5BFC', '0x60E7C')
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
            if info['kind'] in ('call', 'jp') and info['target'] >= 0xFF00:
                pass  # HRAM/IO address (e.g. `call $FFA0` = OAM DMA stub) — keep the raw operand
            else:
                m = m.rsplit(' ', 1)[0] + ' ' + label_for(bank, info['target'], info['kind'])
        op = ROM[pc]
        if op in (0xC6, 0xCE, 0xD6, 0xDE):
            m = f"{['add', 'adc', 'sub', 'sbc'][(op - 0xC6) // 8]} {ROM[pc + 1]}"
        if op in (0xEA, 0xFA):  # $FFxx access: keep the ROM's 3-byte form via the project macro
            v = ROM[pc + 1] | ROM[pc + 2] << 8
            if v >= 0xFF00:
                macro = 'ldh_n_a' if op == 0xEA else 'ldh_a_n'
                m = f'{macro} ${v & 0xFF:02X}'
        out.append('\t' + m)
        pc += n
    assert pc == b, f'code segment overruns at ${a:05X}-${b:05X}'
    return out


def render_jt(bank, a, b):
    out = []
    for i, p in enumerate(range(a, b, 2)):
        t = ROM[p] | ROM[p + 1] << 8
        rom = to_rom(bank, t, 'jt')
        nm = CREATED.get(rom) or pick(bank, rom, 'jt')
        out.append(f'\tdw {nm if nm else f"${t:04X}"} ;${i:02X}')
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
        starts_with_code = ch['segs'][0][0] == 'code' and all(seg[0] == 'code' for seg in ch['segs'])
        above = []
        j = info[s]['line'] - 2  # 0-based index of line above INCBIN
        while j >= 0 and (re.match(r'^\w+:\s*(;.*)?$', main_lines[j]) or main_lines[j] == '\t'):
            if re.match(r'^\w+:', main_lines[j]):
                above.append(main_lines[j].split(':')[0])
            j -= 1
        d = []
        if starts_with_code:
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
                    if not (tgt['kind'] in ('call', 'jp') and tgt['target'] >= 0xFF00):
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
            elif kind == 'jt':
                body = render_jt(bank, a, b)
            elif kind == 'gfx':
                body = [f'INCBIN "{ch["files"][a]}"']
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
        assert re.match(rf'INCBIN "baserom\.gb", \$0*{s:X}, \$0*{info[s]["e"]:X} - ', old), old
        j = li - 2
        while j >= 0 and (re.match(r'^\w+:\s*(;.*)?$', main_lines[j]) or main_lines[j] == '\t'):
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
    import os
    for s, ch in spec.items():
        if s not in info:
            continue
        for kind, a, b in ch['segs']:
            if kind == 'gfx':
                path = f'{ROOT}/{ch["files"][a]}'
                os.makedirs(os.path.dirname(path), exist_ok=True)
                open(path, 'wb').write(ROM[a:b])
                print(f'extracted {ch["files"][a]} ({b - a} bytes) from ${a:05X}')
    open(MAIN, 'w').write('\n'.join(main_lines))
    nbytes = sum(info[s]['e'] - s for s in info)
    print(f'bank ${bank:02X}: converted {len(info)} chunks, {nbytes} bytes; '
          f'created {len(CREATED)} labels: ' + str(CREATED))
    print('dropped: ' + str(sorted(DROPPED)))


if __name__ == '__main__':
    main()
