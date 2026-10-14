# WP7h handoff — the exit-tile arm is console-verified, and the queue's boss item is honest again (2026-10-14)

Second doc of the 2026-10-14 series; the first is the port's own
`PORT_QUEUE.json` update that this session wrote. The 2026-10-13 doc is `wp7g`; read **wp7g**
first if you are new to the series — it closes the brick-bump system and the
capture methods. The port lives in the sibling repo `/home/pmill/sml2-rs` (its
own git history); the decomp is this tree via `SML2_DECOMP_ROOT`.

Two commits in each repo: the port at `7b62ea9` + **`fdd43cf`**, the decomp at
`a279c9a` + `b4e3a7f`.

## Measured state (verified this session)

```bash
cd /home/pmill/sml2decomp && make clean && make compare && sha1sum baserom.gb sml2.gb
# cmp exit 0, both bba408539ecbf8d322324956d859bc86e2a9977b

cd /home/pmill/sml2-rs && cargo test && bash captures/sweep.sh
# cargo test 137 passed; the sweep prints ONLY the traj4_ff0 exception's numbers
# (x=0 y=53 … objslots=490 odd=204) and no REGRESSION lines
```

**The gate is now 19 captures**: `traj4_ff0` + traj5-17 + death1-3 +
`crouch_pan1` + `screen_transition1`. `traj4_ff0` keeps its documented legacy
`$FFF0` divergence (its numbers must stay byte-identical across changes);
`traj13_full` is retired. `captures/sweep.sh` is new (committed) — it is the
one-command sweep, and it prints a line only for a capture with a nonzero field
or a `note:` line, so the output reads "clean unless a REGRESSION appears".

## What this session changed

1. **The tree was BROKEN when this session started** — the previous session left
   `cargo test` not compiling (a `player_sim.rs` test calling a non-existent
   `bonk_ceiling_cell`/`bump_slots` API; the port's names are
   `block_bonk`/`block_slots`) and the queue claiming `scene_boss_spawn` was
   `done`. **Always run `cargo test` first, not just the build**: `cargo build`
   passes with a broken test module.
2. **`scene_boss_spawn` is back to `pending`** with an ADVANCED note. What
   genuinely landed and is kept: the `sml2-extract` boss-spawn extraction
   (`extracted/scenes/boss_spawns.json`, 9 records) and
   `scene.rs:lookup_boss_spawn_def`, **independently re-derived from
   `baserom.gb`** (a throwaway script re-read `$4E3F`/`$4E9A`/`$4EAC` and matched
   9/9). Two ROM facts measured while landing it: the record table has a 9th
   entry at `$4E69` (count 0, sprite 99 — the no-boss record) whose
   `sObject0Def` image is `$4E9A[8]` = `$4F4C`; and the `$4EAC` table has EIGHT
   entries because `$8E6C` is `ld a,[sObjectDefCount] / and a / ret z` *before*
   it dereferences that table.
3. **Reverted: arming `sSceneState = $F0` in `CameraSim::finish_transition`.**
   `$0652` selects the `$8DA9` alternate driver *instead of* the `$8000` engine
   while `sSceneState & $F0 != 0`, and the port has neither that driver nor its
   deps — so arming it would park the port. The in-flight edit had also made the
   arm an `else if` that swallowed the ROM's independent `$0EE4`
   `sBossDefeated` clear; `finish_transition` now matches the ROM's two separate
   `if`s and carries the reason in its doc comment. This is the third time the
   series' own warning has applied: **`$2x`'s low-nibble arm and the high-nibble
   park are modelled together or not at all.**
4. **`captures/traj17.json` + `trajectory_capture17.py`** — the exit-tile arm
   (below). This is the item `exit_tile_arm_capture`, now `done`.
5. Harness: optional per-frame `exit`/`lowtime`/`fadelo`/`fadehi`/`tally` record
   fields and the one-shot `exit_arm` block, plus the
   `sml2-runtime/src/main.rs` `exit arm:` report line (a disagreement prints a
   `note:`, which fails the gate).
6. Docs: `captures/README.md` (the traj17 row, the two-hook sampling section),
   `DESIGN.md` (the exit-bell bullet is now CONSOLE-verified), and the parent
   plan now points at the port series' real records (`PORT_QUEUE.json`,
   `DESIGN.md`, `captures/README.md`, these handoff docs) instead of pretending
   to list WP7+.

## The exit-tile arm, and the technique the capture needed

`$1BFF`'s last sample is `(x+16, y+28)`; `$1CBA` tests `sCollisionTile & $FE ==
$4A` and runs the level-exit arm: `sLowTimeFlag = 0`, `sExitTileFlag = 0` (`$FF`
for the `$4B` twin), `sMusicRequest = 3`, the three SFX request bytes cleared,
`$FF9B = 24` (state `$18`), `sFadeTimer = 192`, `sSecretRouteFlag` and
`sTileAnimConfig` cleared. Level 1's only `$4A` cell is the bell at col 254 /
row 30 (world x 4064); traj12 stopped at 4026 on purpose, so the arm was
unit-pinned only.

**Measured on the console** (`trajectory_capture17.py` = traj16's whole-level
route + traj12's deliberate *walk* east, continued past 4026; the arm is
detected from `$FF9B == 24`, so the route lands on the console's own frame):

- the arm fires with Mario at **x = 4057** (the probe `(x+16, y+28)` =
  (4073, 496) → col 254), `sCollisionTile = $4A`, `sMusicRequest = 3`,
  `sLowTimeFlag = $00`, `sExitTileFlag = $00`, `$FF9B = $18`, `sFadeTimer = 192`;
- the fade holds state `$18` for **191 further ticks** (192 total with the arm
  frame), and `$3547`'s tail charges `sLevelTally` **`00` → `01`** in BCD as the
  state moves to `$14`;
- the port's `exit_fade_step` matches on **every** frame (192 modelled vs 192
  captured) and the tally charge with it: 6976 compared frames, all-zero, no
  `note:` lines.

**The trap, and the fix worth reusing.** `$05E4` is the state-`$04` body's
entry, so the FIRST frame whose state is no longer 4 produces **no record** — a
level-ending feature is invisible to the standard hook exactly when its writes
matter. The capture registers a SECOND hook at `$028D` (the main loop's
post-state point: `call $02AD`'s handler `ret`s past its own caller, so `$028D`
runs once per frame in EVERY state) and splices those samples for the frames
after the arm onto the same record list. Both hooks sample the same frame
boundary — a `$05E4` sample is its frame's start = the end of the frame the
record list already treats as "one frame earlier" — so one `apply_pairing.py`
pass covers the spliced stream. The one asymmetry: VBlank writes (the fade
timer) land between the two instants, and a `$028D` sample is pre-decrement —
which is exactly the value the sim's own post-step state holds, so the new
`fade` check is exact rather than off by one. Reuse this for anything that
leaves the level (the `$4B` twin, a boss clear, the death fade's own frames).

Two smaller measured facts: the last 9 ticks of the tail stay in state `$14` but
produce only ONE `$028D` fire between them (193 fires for the 200 ticks after
the arm), so the capture ends at the hand-off frame and the hand-off's own body
stays unexercised (`map_handoff_14_body`'s note now says exactly that); and the
console's camera reads `$FB0/$1C0` from the arm onwards — the map screen does
NOT move it — so the capture needs no trimming.

## The queue's state (39 items: 27 done, 12 pending)

Pending, cheapest first by the measured recipe each one needs:

1. **`bonk_single_slot_draw`** — level 1's `$00` block at x 576-607 (single-slot
   → `$FFC6 = 66`, the draw `traj15`'s two-slot `$01` bump cannot show). The
   only obstacle is the first walker: traj15's route already knows how to stomp
   it (`walker_slot(0)` + the stomp recipe) and then walk to the block.
2. **`scene_capture`** — level 3 (`--level 2`) is the intended level: `level03.scene.bin`
   cells (Yhi 0, Xhi 4) → id 7 and (Yhi 1, Xhi 5) → id 6, both `40 xx FF`
   teleports, so crossing a screen edge while standing on one of those two cells
   exercises the scene VM against the console for the first time. The port has no
   scene fields in the capture schema, so the checks would be the existing
   x/y/camx/camy/edge ones (enough to catch the teleport).
3. **`autoscroll_capture`** — levels 20/26/31 (`--level 19/25/30`) have
   `auto_scroll != 0`; the port prints a `note:` for them today, so adding one to
   the gate fails until the capture lands. Level20 also has `unknown = 8`
   (`sMapScrollLimit`).
4. `items_powerup_capture` / `fireball_type06_break` / `fireball_paths` /
   `bonk_big_mario_types_1_5` — all need an item pickup (mushroom/carrot/star/
   fire flower) that level 1's route does not reach.
5. `pushout_1413_capture` (`$0C-$0F`/`$04`/`$05` tiles), `obj_on_object_capture`
   (a `$23`-bit5 walker/platform), `scene_boss_spawn` (a boss arena) — other
   levels.
6. `overworld_map_state_0C` (the map state machine; only its entry decision is
   modelled) and `carry_item_type06` (spec complete, not implemented; needs a
   capture to be console-exact).

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. Capture JSON
  goes to `$OUT` = `~/.hermes/cache/scratch` (pruned after 24 h idle) — **copy it
  into `sml2-rs/captures/` the same session** (`apply_pairing.py <raw> <out>`
  writes the tree copy directly).
- New: `captures/trajectory_capture17.py` (the dual-hook exit capture) and
  `captures/sweep.sh` (the whole gate in one command).
- `baserom.gb.sym` next to the ROM enables symbol-based PyBoy hooks; gitignored
  (`rgblink -n sml2.sym -o /dev/null main.o; cp sml2.sym baserom.gb.sym`).
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`.
- Route-authoring traps that have bitten: helper variables must not shadow `p`
  (the PyBoy object); with the `$05E4` hook owning the records a section must not
  also append to `frames`; the walk from the tower must NOT hop (hopping through
  3872-3887 head-bumps the `$7F` block at row 26); `walker_slot(400)` and the
  240-frame fast-forward are only safe from the level start.

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** `cargo test` green **and**
the 19-capture sweep clean — no `REGRESSION` lines, no `note:` lines, and
`traj4_ff0`'s own numbers byte-identical to the pre-change build.

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2-rs` (sibling git repo; `PORT_QUEUE.json` + `DESIGN.md` +
> `captures/README.md` are the records; the decomp is `/home/pmill/sml2decomp`
> via `SML2_DECOMP_ROOT`). Read
> `/home/pmill/sml2decomp/.hermes/plans/2026-10-14_wp7h-handoff.md` and the
> wp7…wp7g docs behind it. Entry gate: in the decomp, `make clean && make
> compare && sha1sum baserom.gb sml2.gb` (cmp exit 0, both `bba4085…`); then in
> `/home/pmill/sml2-rs`, `cargo test` (137) and `bash captures/sweep.sh` (clean,
> `traj4_ff0`'s numbers unchanged) — **`cargo test`, not just the build: a
> broken test module passes `cargo build`**. Capture records must come from a
> `$05E4` hook + `apply_pairing.py`, with a `$028D` hook spliced in for any
> frames after the game leaves the in-level state. Next target: **the
> single-slot `$00`/`$03` bonk** (`captures` item `bonk_single_slot_draw`; level
> 1's `$00` block at x 576-607, stomp the first walker then walk east), then the
> **scene capture** on level 3 (`--level 2`). Read the handler first — do not
> tune inputs against PyBoy. Finish with the ROM gate re-run, the README +
> DESIGN updates, the queue item's measured note, and a fresh handoff doc in the
> decomp `.hermes/plans/`.
