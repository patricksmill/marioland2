# WP7g handoff — the brick-bump ("bounce block") system is ported, and `traj15` verifies it (2026-10-13)

First doc of the 2026-10-13 series; the 2026-10-12 series is wp7 → wp7b → wp7c →
wp7d → wp7e → wp7f. Read **wp7f** first (it closed the "ledge-side wall push-out"
as a capture-sampling artifact and retired `traj13_full`). This WP took the first
item off wp7f's open list: **bounce blocks**. The port lives in `sml2-rs/` and is
**untracked by request**; `DESIGN.md` + `captures/README.md` are its docs.

## Measured state (verified this session)

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb   # cmp exit 0, both bba4085…
cd sml2-rs && cargo build --release
for f in traj4_ff0 traj5 traj6 traj7 traj8 traj9 traj10 traj11 traj12 traj13 \
         traj14 traj15 death1 death2 death3; do
  ./target/release/sml2-runtime --level 0 --replay captures/$f.json | tail -1
done
```

**Fifteen** captures all-zero, no `note:` lines, plus the new **`traj15` (818
records, 35 checks, all-zero, 817 frames compared)** — 16 gate captures.
`traj4_ff0` keeps its documented legacy `$FFF0` divergence; `traj13_full` is
retired and not part of the gate.

## What the system is (all measured, not inferred)

`$1DFE`'s ceiling probe (`(x+16, y+28)` small, `y+18` big) hits when the tile is
`$7E` or `<$38`; `$15CF` snaps y back and arms vvel 24, and `$15F4` then calls
`$1993`, which classifies the tile (left in `sCollisionTile` by the probe) and
allocates into one of 8 `sBlockAnimSlots` (`$AA80`, `$10` bytes: `+0` type, `+1`
timer, `+2/+3` Y, `+4/+5` X, stored as the probe point `+8` and masked to `$F0`).

Classes: `$7E`/`$02` → 3; `$00` → 2 (small) / 1 (big); `$03` → 6 (small) / 5
(big); `$01` → `sSpinJumpBounce` (`$A220`) = `$FF`, a **type 3** slot, then
`$2C77` → `$591F` credits **+1 coin** (BCD via the `$0999` step table) and
allocates a **type 4** slot; `$04`-`$37` → return (the tile still bonked; the
flag was already cleared at `$1993`'s first store). The big-Mario arms' only
other effect is `sSfxRequest2` (audio).

Ticking is `$2C82` → `$5997`, called **after** the frame selection (`$2D0A`) and
before the object engine — that placement is why a drawing slot's `$FFC6` is what
the frame ends with. Per slot: timer increments first, then the type dispatches.

| type | draw | free | level-map write (`$5CF1`) |
| ---: | :--- | :--- | :--- |
| 1 | 102 ($5A07) at timers 3..$27 | timer $28 | 96 at 2, 96 at $28 — the block is destroyed |
| 5 | 102 | timer $28 | 127 at 2, 127 at $28 — destroyed |
| 2 | 66 ($5B8A/$5B06) timers 3-7 | timer 8 | 24 at 2, **0** at 8 |
| 3 | 66 ($5B06) timers 3-7 | timer 8 | 24 at 2, **7** at 8 |
| 6 | 66 ($5B8A) timers 3-7 | timer 8 | 24 at 2, **3** at 8 |
| 4 | the `$5AF9` cycle `[$6D,$6E,$6F,$6E]` by `(timer & $0C) >> 2` | timer $32 | never |

**A single `$01` bonk allocates two slots** (type 3 then type 4). The scan is in
slot order and the type-4 slot is second, so its cycle's **109/110/111** is what
survives in `$FFC6` — `66` is only observable from a *single*-slot bonk
(`$00`/`$03`/`$7E`/`$02`). That is why the old note ("a `$7F` bump shows frame
66") was true for `traj12`'s walk-past and false here.

**The bump rewrites the level map.** `$5CF1` stores a tile into WRAM's copy at
the slot's cell (address derived from the rounded Y/X), so every later probe
reads the new tile. Measured on cell (28,22): `$01` → `$24` at timer 2 → `$07`
at timer 8, i.e. after ~8 frames a second bonk there hits `$07` — a `$04`+ tile:
a plain bonk that clears the flag, credits nothing and allocates nothing. Small
Mario's `$00`/`$03` bumps leave those tiles bumpable again; big Mario's destroy
them (96 = `$60`, 127 = `$7F`, both non-solid).

## What this session changed

1. **`crates/sml2-core/src/player_sim.rs`** — `block_bonk(tile)` (`$1993`) and
   `block_update()` (`$5997`) with the table above, plus `spin_jump_bounce`
   (`$A220`), `object_bump_special` (`$A256`), `block_slots` (`[[u8;16];8]`,
   `$AA80`), `block_frame`, `ceiling_probe`, and `layout_writes`: a sparse
   `Vec<(u32, u8)>` overlay that `tile()` consults before the extracted map, so
   the bump's collision consequences are modelled without mutating the shared
   `LevelLayout`. Cleared in `respawn()` (the level map is re-read on a reload).
2. **`crates/sml2-runtime/src/main.rs`** — records `spin`/`coins`/`coinshi`/
   `bslots`, checks them (only when the capture carries them, so the older
   captures keep their check count), `frame_check` uses `block_frame`, and
   `block_update()` runs after the frame selection in both the replay loop and
   `run_play`.
3. **`captures/trajectory_capture15.py` + `captures/traj15.json`** — the bump
   capture (below).
4. **`captures/probe_block_bump.py`** — extended with `$15CF`/`$1993` hooks that
   log the probe point, the tile read and `sCollisionTile`; that is where the
   (360, 479) probe, the cell (28,22) and the `$24`/`$07` writes were measured.
5. Docs: `captures/README.md` (the `traj15` row, the v15 recorded fields, the
   bump probe paragraph, the `traj12` cross-reference), `DESIGN.md` (the bump
   bullet rewritten as ported+verified with the measured semantics, the open
   queue re-ordered).

## The capture, and one bug it caught

`trajectory_capture15.py` walks east on the row-31 floor to the `$01` block at
col 22 (x 352-367 — the probe `(x+16, y+28)` wants Mario at x ∈ [336,351]),
jumps three times, then runs into the first walker (a harmful side contact → the
dispatch + arc). Jump 1 = the two-slot bump + the coin; jumps 2 and 3 bonk the
rewritten `$07` cell (plain bonks: no coin, `spin` back to 0, `frame` stays 40)
— the console behaviour that a map-write-free model cannot produce.

The first replay was **not** all-zero: the sim re-bumped `$01` on jump 2 and
credited a second coin. Cause: `block_write_cell` recovered the row with
`sy & 0xF0` on the *16-bit* slot Y, so `$01D8` → `$00D0` → row **12** instead of
28 (a `& $FFF0` on the stamped value is needed). The `frame`/`spin`/`coins`/
`bslots` checks are what surfaced it — the physics checks were green throughout,
because the wrong cell changed nothing Mario did. Fixed, and 817 frames compare
all-zero.

## Route-authoring traps (new)

- The stomp recipe's `walker_slot(400)` filter fails once the walker has walked
  *west* of 400: the loop then sees no walker, breaks out, and Mario jumps into
  it and dies. Use `walker_slot(0)` (any walker) for the approach loops.
- The recipe's opening `run(['right','b'], 240)` is a 345-px fast-forward that
  is only safe from the level start: from x=344 it runs *into* the walker at
  ~416. Step one frame at a time when starting mid-level.
- The `$00` block at x=576-607 (col 36-37) is behind that walker; `traj15` did
  not reach it. It is the cheapest single-slot `$66` case if a future capture
  routes around the walker (hop over it, or stomp it from the right phase).

## Open items (measured order)

1. **`$1BFF`'s exit-tile arm** (`$4A/$4B` → `$FF9B = 24` + the 192-frame fade +
   music 3); reachable past x ≥ 4044 — `traj12` stops at 4026 on purpose.
2. **The unexercised item ids** (1-4/6/8/9) and the anim-16 post-touch arm: the
   `$3451` writes are ported, no capture reaches them (block-spawned items; id 6
   is pose86 at (4008, 360)).
3. **The bounce-block cases no capture reaches**: the single-slot `66` draw
   (`$00` at x ≥ 576, `$03` only at the tower), the big-Mario types 1/5 (needs a
   powerup), the fireball's `$06` break (`$3415` — a type-1 bump from the
   projectile, `sCollisionTile == $06`), and the spin-jump landing's `$1993` call
   (`$1327`, only while `sSpinJump` is set).
4. **A push-out/side-push capture** (wp7f): needs a `$0C-$0F` side pipe or a
   `$04/$05` landing next to a wall; also what would make the `$181C` fix and
   `$12CE`'s landing `inc sScrollDeltaRight` green.
5. Unmodelled by design (documented): the bump's **BG-map art writes** — `$5C01`/
   `$5C2C`/`$5BD3`'s `$FF`/`$F4-$FB`/`$F8-$FB` 2x2 and `$200C`'s `$97E0`-based
   address — are VRAM/art only, and the draw position (`$FFC4`/`$FFC5`, Y from
   the `$5AE0` offset table) is not checked because no capture records it. The
   renderer would need the 2x2 override to show a bumped block's art.
6. Unchanged: the goal bell's own behaviour, the game-over screen, the scene
   system, the type-`$06` carry, and the `--play` gaps.

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. Capture JSON
  goes to `$OUT` = `~/.hermes/cache/scratch` (pruned after 24 h idle) — **copy
  it into `sml2-rs/captures/` the same session** (`apply_pairing.py <raw> <out>`
  writes the tree copy directly).
- New: `captures/trajectory_capture15.py` (the bump route) and the `$15CF`/
  `$1993` hooks in `captures/probe_block_bump.py`.
- `baserom.gb.sym` next to the ROM enables symbol-based PyBoy hooks; gitignored
  (`rgblink -n sml2.sym -o /dev/null main.o; cp sml2.sym baserom.gb.sym`).
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`.
- Route-authoring traps that have bitten: helper variables must not shadow `p`
  (the PyBoy object); with the `$05E4` hook owning the records a section must
  not also append to `frames`; `walker_slot(400)` and the 240-frame fast-forward
  (see above).

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** `traj4_ff0` + traj5-15 +
death1-3 replaying all-zero with no `note:` lines (`traj4_ff0` is the documented
exception; `traj13_full` is retired and not part of the gate).

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2decomp/sml2-rs` (untracked by request; `DESIGN.md` +
> `captures/README.md` are the docs). Read `.hermes/plans/2026-10-13_wp7g-handoff.md`
> and the wp7…wp7f docs behind it. Entry gate: `make clean && make compare &&
> sha1sum baserom.gb sml2.gb` (cmp exit 0, both
> `bba408539ecbf8d322324956d859bc86e2a9977b`), then `cargo build --release` and
> replay traj4_ff0, traj5-15, death1-3: all must be all-zero with no `note:`
> lines (`traj4_ff0` is the documented exception). Capture records must come from
> a `$05E4` hook + `apply_pairing.py`, not per-tick sampling. Next target:
> **the `$1BFF` exit-tile arm** (`$4A/$4B` → `$FF9B = 24` + fade, reachable past
> x ≥ 4044), then the unexercised item ids. Read the handler and the `$2EDD` box
> math first — do not tune inputs against PyBoy. If a replay goes "off by a
> frame", run `probe_frame_cadence.py` before touching the port. Finish with the
> ROM gate re-run, `captures/README.md` + `DESIGN.md`, and a fresh handoff doc.
