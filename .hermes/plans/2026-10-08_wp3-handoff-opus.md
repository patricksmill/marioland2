# WP3 Handoff — Bank $00 Dynamic Dispatch & RST $28 Jump Tables

**Assigned model:** Opus 5.5 (Tier 2 — high-intelligence)
**Repo:** `/home/pmill/sml2decomp`
**Entry commit:** `34949ec` (WP2 complete) on `master`
**Parent plan:** `.hermes/plans/2026-10-08_133500-migrate-to-rgbds-v1-0-4.md`
**Prerequisites:** WP1 (`0b351d9`) and WP2 (`34949ec`) complete.

---

## Entry criteria (verify BEFORE touching anything)

```bash
cd /home/pmill/sml2decomp
make clean && make compare && sha1sum baserom.gb sml2.gb
```

Both hashes must print `bba408539ecbf8d322324956d859bc86e2a9977b` and `cmp` must exit 0.
If this does not pass, STOP — do not start WP3 on a broken tree.

---

## Scope

Bank $00 (`home.asm`, section `bank00`, ROM0 $0000-$3FFF) is **84.0% disassembled**;
**16.0% (2,615 bytes) is still raw `INCBIN`**, spread across **59 chunks**. Two jobs:

1. **Reverse the `rst $28` dispatcher** and annotate its call sites.
2. **Replace the 59 `INCBIN` chunks** with real disassembly or typed data.

### 1. `rst $28` dispatcher (home.asm lines 6-17)

The RST $28 vector at `$0028` is an indirect table jump. The source already carries a
comment and the raw instructions:

```rgbasm
;rst28 jumps to address of address table, where a is the index
	add a
	pop hl          ; HL = return address (just after the rst)
	ld e, a
	ld d, 0
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	pop hl
	jp hl
```

Task: trace every `rst $28` call site in Bank $00, identify each inline pointer table
(word-sized entries, indexed by `a`), and annotate the mechanism (register A = table
index; the table immediately follows the call; entry = 16-bit destination). Do **not**
rewrite the dispatcher itself unless you can prove byte-identity.

### 2. Remaining `INCBIN` chunks (59 chunks, 2,615 bytes)

Cleanly separate **code** from **data**:
- Pointer tables (tables of `$xxxx` little-endian words) → `dw` directives.
- Byte tables / graphics leftovers → `db` directives.
- Actual code → disassembled instructions with accurate labels.

Largest chunks first (byte lengths): 248, 239, 190, 189, 143, 124, 107, 105, 79, 68 …
Full list: `grep -n 'INCBIN' home.asm`. Every chunk runs from its `$start` to the next
non-INCBIN label.

**Do not** blindly disassemble a table as code or vice-versa — an `INCBIN` boundary
must land on the exact byte offset of the following label, or the ROM will drift.

---

## Hard constraint (RGBDS v1.0.4) — applies to EVERY edit

The automatic `LD` → `LDH` conversion was **removed in RGBDS 0.8.0**. For any address
in `$FF00-$FFFF` (including equates such as `hKeysHeld = $FF80`), the **mnemonic**
decides the byte size:

| Source | Bytes | ROM form |
| :--- | :--- | :--- |
| `ldh [rLCDC], a` / `ld [addr], a` (addr < $FF00) | 2 | `E0 40` |
| `ld [rLCDC], a` | **3** | `EA 40 FF` |

Never turn a 2-byte `ldh` into a plain `ld`, and never introduce a symbol in a form
that changes its size. A size change shifts every following label, so `cmp` shows
thousands of differing bytes starting at the culprit — **not** a local diff. The two
`JR`/bank-overflow errors that appear during such drift are symptoms, not the cause.
`hardware.inc` (v6.0.0) is already included at the top of `main.asm`; standard
register symbols (`rLCDC`, `rSCX`, `rAUD*`, …) are available; WP2 already named all
numeric standard-register literals in `home.asm`/`main.asm`.

---

## Workflow rules

- Work in small batches; run `make clean && make compare` after **every** batch.
- Revert any batch where `cmp` fails. Never hand off a red tree.
- Do not change program logic or control flow semantics — only replace raw bytes with
  equivalent source that assembles to the identical bytes.
- Keep the pre-existing label naming scheme (`UnknownCall_0xNNNN`, `UnknownRJump_0xNNNN`,
  `UnknownData_0xNNNN`); promote a label to a semantic name only when the behaviour is
  proven.
- Commit when the exit gate passes.

## Exit gate

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb
```

Both hashes `bba408539ecbf8d322324956d859bc86e2a9977b`; `cmp` exit 0.

---

## Copy-paste handoff prompt

> You are an expert Game Boy reverse engineer (Tier 2, Opus-class) working on
> `/home/pmill/sml2decomp`, a Super Mario Land 2 disassembly built with RGBDS v1.0.4.
> First confirm the entry state: run `make clean && make compare && sha1sum baserom.gb sml2.gb`
> — both hashes must print `bba408539ecbf8d322324956d859bc86e2a9977b` and `cmp` must exit 0
> before you change anything. Then complete Work Package 3 (see
> `.hermes/plans/2026-10-08_wp3-handoff-opus.md`): in `home.asm` (Bank $00, ROM0), reverse
> the `rst $28` indirect jump-table dispatcher at `$0028` and its call sites, and replace
> the 59 remaining `INCBIN` chunks (2,615 bytes = 16.0% of the bank) with real disassembly
> or typed data (`dw` for pointer tables, `db` for byte tables, instructions for code).
> Distinguish code from data carefully — each `INCBIN` boundary must land on the exact
> offset of the following label. **RGBDS v1.0.4 encoding constraint (applies to every
> edit):** the automatic `LD`->`LDH` conversion was REMOVED in RGBDS 0.8.0, so a plain
> `ld [addr], a` emits 3 bytes while `ldh [addr], a` emits 2. For any address in
> `$FF00-$FFFF` (including equates such as `hKeysHeld = $FF80`) the mnemonic decides the
> size: keep whichever encoding the ROM already uses, never turn a 2-byte `ldh` into a
> plain `ld`, and never introduce a symbol in a form that changes its size. A size change
> shifts every following label, so `cmp` will show thousands of differing bytes. Do not
> change logic. Run `make clean && make compare` after each batch and revert any batch
> where `cmp` fails. Commit only when the exit gate passes.
