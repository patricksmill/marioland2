# WP7c handoff — `sml2-rs` port: `traj12` (tower) + two ROM-derived fixes (2026-10-12)

Continuation of `2026-10-12_wp7-handoff.md` (the three `traj10` fixes) and
`2026-10-12_wp7b-handoff.md` (docs correction + `traj11`). The port lives in
`sml2-rs/` and is **untracked by request** (`.gitignore` now carries `/sml2-rs`);
`git status` shows only `.gitignore` and these `.hermes/plans/` docs.

## Measured state (all verified this session)

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb   # cmp exit 0, both bba4085…
cd sml2-rs && cargo build --release
for f in traj5 traj6 traj7 traj8 traj9 traj10 traj11 traj12 death1 death2; do
  ./target/release/sml2-runtime --level 0 --replay captures/$f.json | tail -1
done
```

Every one of the ten captures replays **all-zero** (traj5 381 / traj6 468 /
traj7 838 / traj8 2126 / traj9 2348 / traj10 5129 / **traj11 6469** /
**traj12 6839** / death1 537 / death2 837 compared; `traj4_ff0` keeps its
documented legacy `$FFF0` divergence and is the only exemption). No
`note: unported …` line on any capture.

## What this session changed in the port

1. **`player_sim::hazard_probe` — `$1BFF`'s hazard arm** (was a listed omission).
   Tiles `$50/$51` (`tile & $FE == $50`) at `(x+16, y+22)` for big Mario on his
   feet, else `(x+16, y+28)`. The engine writes `sMarioDead = 15` unless
   `sInvincibilityTimer`/`sStarTimerHigh` runs, then *overwrites* with `$80` when
   `sMarioScreenY >= $80` — the `$1C4E`→`$1C6D` fall-through means that overwrite
   happens even while invincible. The byte is applied *after* `death_dispatch()`
   so the hit frame still moves normally, matching the object-contact path's
   one-frame delay (`sml2-runtime` writes `obj.mario_dead` post-step). The probe
   reads the **pre-update** x/y and the **previous** frame's ducking flag, which
   is what `$0F71`'s call order (`$1BFF` before `$129F`/`$14A6`) gives it.
   `PlayerSim` gained `camy` (`sCameraY` low byte) for `sMarioScreenY`; the
   runtime sets it beside `camx` in both the replay and the play loop.
   **The `$4A/$4B` exit-tile arm is still omitted** — see below.
2. **`objects::advance_stream` — the spawn scan's end-of-stream rule.** The
   stream is terminated by a `$FF` first byte one record past the last one, and
   `$8C56` (`add hl, de / ld a, [hl] / cp $FF / ret z`) returns **before storing**
   the advanced pointer, so consuming the *last* record leaves
   `sObjectStreamPtr` parked on it. The port used to advance one record further
   (`sptr sim=$AB90 exp=$AB8A` from frame 6605 on — the level's final record,
   the `$80`-type spawn at x=4008). Both the walk-forward and the mode-gate-skip
   paths now bail out instead of advancing past the terminator, and the spawn
   tail calls `advance_stream()` for its effect only.
3. **`captures/traj12.json` + `captures/trajectory_capture12.py`** (6840 frames,
   x 3586 → 4026) and **`captures/probe_c6_selector.py`** (the `$530D` hook).

## `traj12`: what the route had to do, and why

- **The tower (3616-3807)** is climbed with running hops only. The first attempt
  with a 6-frame run-up died at x=3709 clipping the `$81` spike row (3696-3727)
  — the console's own `$1BFF` probe at `(x+16, y+28)` lands on tile (232,29), a
  hazard tile, so the new hazard port makes that death explicit rather than a
  silent divergence. 18 frames of run-up clears the 33 px gap.
- **Hops stop at x >= 3800.** Past the tower the floor is flat, and hopping
  through **x 3872-3887 head-bumps the `$7F` bumpable block at row 26 (tile
  242)**: the console then draws the **block-bump pose for 5 frames**
  (`$FFC6 = 66`) while Mario's x/y/vvel are untouched. That pose is written by
  `$5B06` (bank 1) with the draw placed at the *block's* screen coords
  (`$FFC4`/`$FFC5` from `sBlockAnimTimer` = `$A23F`, indexing the `$5AE0`
  Y-offset table and the `$5AF9` pose table `[$6D,$6E,$6F,$6E]`). Walking under
  the block is clean.
- **The route stops at x=4026** so Mario's floor probe (`x+20`) never reaches
  the exit tile at 4064: reaching it makes the console enter the level-complete
  state (`$FF9B = 24` at f6746 in the earlier cut, and the `frame`/`ff0`/
  `uphase` checks all diverge from that frame on). The pose-86 object at x=4008
  still gets its whole life captured (spawn f6606, active f6616).
- Diagnostic that settled it: `probe_c6_selector.py` hooks `$530D` **in bank 1**
  and logs the selector's inputs per logic frame. They were all as the port
  models them (no invincibility, no on-object, no spin/moon/flutter, powerup 0),
  which is what pointed at "another routine wrote `$FFC6`" rather than "the
  selector used unrecorded state".

## Open items (measured order)

1. **Bounce blocks** (`$7F` tiles). Needed for any route that hops under one:
   the `$1DFE` ceiling hit (`tile & $FE == 7E`) must also do the block bump —
   tile replacement, `sBlockAnimTimer` ($A23F) phases, the `$5B06` `$FFC6 = 66`
   pose with `$FFC4`/`$FFC5` at the block, and the `$5AF9` `[$6D,$6E,$6F,$6E]`
   sprite list. Exact repro: hop through x 3872-3887 (row 26, tile 242) in
   `traj12`'s route; today that diverges on `frame` alone.
2. **`$1BFF`'s exit-tile arm**: `tile & $FE == $4A` → `sLowTimeFlag`/
   `sExitTileFlag` cleared (`$4B` sets `sExitTileFlag = $FF`), music 3, sfx
   cleared, `$FF9B = 24`, fade 192, `sSecretRouteFlag`/`sTileAnimConfig` cleared.
   Reachable by extending the route to x >= 4044 (the floor probe hits tile 254).
3. **A spike-death negative control**: the hazard *death* branch (`dead = 15`,
   and the `$80` overwrite when `sMarioScreenY >= $80`) has no capture yet. The
   arc/fade behind it is already covered by `death1`/`death2`, so this is a cheap
   capture: walk east into the spikes at 3696-3727 without jumping.
4. Unchanged from wp7b: the item pickup `$2DE0`/`$3451` consumer (the bobber's
   resting state is an item), the pose-86 goal object's own behaviour and the
   goal bell, the per-anim handlers with no ported body (list in DESIGN.md), the
   game-over screen, the scene system proper, the type-`$06` carry, and the
   `--play` gaps (Goomba Y, Koopa per-tile flip, enemies static, HUD zeros).

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. Scripts
  write their JSON to `$OUT` = `~/.hermes/cache/scratch` (pruned after 24 h idle)
  — **copy the result into `sml2-rs/captures/` in the same session.**
- `captures/probe_c6_selector.py` — the `$530D` selector hook (bank 1) for
  attributing a `frame`-check divergence. Writes `traj12_probe.json`.
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`.
  A failed capture run dumps partial frames to `traj12_fail.json`; analyse the
  first `dead != 0` frame plus its slot bytes, then decide from the ROM (the
  `$2EDD` box math and the handler, not jump timing).

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** traj5-12 + death1-2 replaying
all-zero (`traj4_ff0` exempt).

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2decomp/sml2-rs` (untracked by request; `DESIGN.md` +
> `captures/README.md` are the docs). Read `.hermes/plans/2026-10-12_wp7c-handoff.md`
> plus the wp7/wp7b docs behind it — they carry every closed divergence with its
> ROM evidence. Entry gate: `make clean && make compare && sha1sum baserom.gb
> sml2.gb` (cmp exit 0, both `bba408539ecbf8d322324956d859bc86e2a9977b`), then
> `cargo build --release` and replay traj5-12 + death1-2; all must be all-zero
> (`traj4_ff0` is the documented exception). Next target: **bounce blocks** —
> port the `$7F`-tile bump (`$1DFE` ceiling hit → tile replacement +
> `sBlockAnimTimer` phases + the `$5B06` `$FFC6 = 66` pose at the block's
> `$FFC4`/`$FFC5`), then re-cut `traj12`'s route to hop through x 3872-3887 and
> require zero. After that, the `$1BFF` exit-tile arm (and a route reaching
> x >= 4044), then the spike-death negative control. Read the handler and the
> `$2EDD` box math first — do not tune inputs against PyBoy; the bobber
> (`$584F3`) and the block bump both cost hours when approached that way. Finish
> with the ROM gate re-run, `captures/README.md` + `DESIGN.md`, and a fresh
> handoff doc.
