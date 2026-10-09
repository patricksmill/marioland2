# AGENTS.md — read this before changing anything

This repo is a **byte-identical disassembly of Super Mario Land 2** (RGBDS v1.0.4).
`baserom.gb` is the reference ROM; the build must reproduce it **exactly**.

## The one hard invariant

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb
```

Both hashes must print `bba408539ecbf8d322324956d859bc86e2a9977b` and `cmp` must exit 0.

- **"No error" is not proof.** A passing build only proves it assembled. Only `cmp`
  against `baserom.gb` proves byte-identity. Always finish with it.
- **Never commit or hand off a red tree.** Run the gate before every commit.
- Run the gate **before your first edit** too, and STOP if it fails — you may be on a
  broken base.

## Work protocol (plans & handoffs)

Work is split into **Work Packages (WPs)**.

1. **Read the plan first:** `.hermes/plans/2026-10-08_133500-migrate-to-rgbds-v1-0-4.md`
   is the parent plan and lists every WP, its tier, scope and exit gate.
2. **Read the newest `*-handoff.md` in `.hermes/plans/`** for the WP you are doing.
   Handoff docs are written by the previous agent and contain the measured state, the
   per-chunk classification, the tools to use, and a copy-paste prompt.
3. **Follow the WP's entry criteria, method and exit gate exactly.** The handoff doc
   is authoritative over the parent plan when they disagree — it is newer and is based
   on measurement. Where a handoff doc states a classification as a *hypothesis*,
   verify it against the ROM bytes before relying on it.
4. **Work one batch (one bank, or one WP slice) at a time**; run the gate after each;
   revert the batch if `cmp` fails.
5. **When you finish a WP:** commit only with a green gate, then write the next
   `.hermes/plans/<date>_wp<N>-handoff.md` (measured state, verified facts, open
   questions, tools, exit gate, copy-paste prompt) and update the parent plan's status
   for that WP. Leave the tree clean.

## The dangerous encoding constraint (RGBDS v1.0.4)

The automatic `LD` → `LDH` conversion was **removed** in RGBDS 0.8.0. For any address in
`$FF00-$FFFF` the **mnemonic** decides the size:

| written | bytes |
| :--- | ---: |
| `ldh [rLCDC], a` | 2 |
| `ld [rLCDC], a` | 3 |

Keep whichever form the ROM already uses. A size change shifts every following label,
so `cmp` reports **thousands** of differing bytes rather than a local diff. `ldh` with a
short address (`ldh [$41], a`) is also invalid — always the full `$FFxx`.

## Layout / tools

- `main.asm` — all banked sections (`SECTION "bankNN", ROMX, BANK[$NN]`, *floating*:
  `@` is the within-section offset). `home.asm` — bank `$00`.
- Extracted assets are `INCBIN`ed binaries: `gfx/**/*.2bpp`, `tilemaps/**/*.bin`,
  `levels/*.bin`. They are plain slices of `baserom.gb`.
- Data left un-extracted is typed inline as `db`/`dw` (16 bytes per line) and **keeps
  its `UnknownData_0xNNNNN:` label** so cross-bank pointers still resolve.
- Tooling is in `.hermes/tools/`: `wp3/{sm83.py,addrmap.py,gen.py}` (decoder, address
  mapper, bank-0 chunk generator), `wp4/wp4.py` (per-bank chunk replacement).
  `gen.py` and `sm83.py`'s symbol loader are bank-0-specific — extend them for banked
  work. Regenerate the symbol table before each batch:
  `rgblink -n sml2.sym -o /dev/null main.o`.
- **Classify a chunk from the ROM bytes before acting on it.** Graphics tilesets render
  as structured pixel art and are blank-padded (`$00`/`$FF` heavy); packed/level data is
  `$AA`-heavy or high-bit-set and renders as static; code sweeps cleanly through
  `sm83.py` with no illegal opcodes. A length that is a multiple of 16 is **not**
  evidence of tiles.