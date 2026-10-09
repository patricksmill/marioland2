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
