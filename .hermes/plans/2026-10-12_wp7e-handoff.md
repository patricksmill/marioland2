# WP7e handoff — `sml2-rs` port: item pickup verified (`traj13`) (2026-10-12)

Fifth doc of the 2026-10-12 series (wp7 → wp7b → wp7c → wp7d → this). Read wp7d
first for the hazard-death work; this one adds the item pickup and records one
new open divergence the route exposed. The port lives in `sml2-rs/` and is
**untracked by request**.

## Measured state (verified this session)

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb   # cmp exit 0, both bba4085…
cd sml2-rs && cargo build --release
for f in traj5 traj6 traj7 traj8 traj9 traj10 traj11 traj12 traj13 death1 death2 death3; do
  ./target/release/sml2-runtime --level 0 --replay captures/$f.json | tail -1
done
```

Twelve captures, every one **all-zero**, and no `note:` line on any of them
(traj5 381 / traj6 468 / traj7 838 / traj8 2126 / traj9 2348 / traj10 5129 /
traj11 6469 / traj12 6839 / **traj13 4644** / death1 537 / death2 837 /
death3 5806 compared). `traj4_ff0` keeps its documented legacy `$FFF0`
divergence and is the only exemption.

## What this session changed in the port

1. **`$2DC6`'s item branch** (`objects.rs::respond`): stages
   `pending_item = type & 0x7F` instead of flagging `$2DC6` unported. The
   runtime hands it to the sim after the object pass (the engine's `$0F71` tail
   consumes it on the *next* frame, exactly like `obj.mario_dead`).
2. **The `$3451` consumer** (`player_sim::item_consumer`, called at `step`'s
   tail right after `death_dispatch`): ids 1/2/3 → powerup 1/3/2 +
   `sInvincibilityTimer = 64`; 4 → star (4/64); 5 → 1-UP (BCD `inc a / daa`,
   the `$99` clamp); 6 → `sGoalBell = 12` + `vvel = 24` when below `$18`; 7 →
   `sSecretRouteFlag = $FF`; 8 → `sMoonPhysics` bit 2; 9 → +80 coins (BCD, the
   `$0999` clamp); id 0 returns **without clearing** (the `and a / ret z`).
   New `PlayerSim` fields: `pending_item`, `coins_low/high`, `secret_route`,
   `star_high/low`. `sfx0` is set where the ROM sets it; `sfx1`/music are not
   modelled.
3. **The touched-item cluster `$8611`/`$868A`** (`objects.rs`): no longer a
   blanket `note_unported`. It is a *switch* — `$86`-`$88` and `$8A`+ do
   **nothing** (`cp $86 / ret nc`), while `$80`-`$85` and `$89` set the anim
   (`+5`) to 16, clear the flip byte and run `$863C` (sprite re-derive +
   `sObjectDone = 1`). The type-`$06` carry arm still flags `$8611`.
4. **The runtime now feeds the interaction pass real `star_high` /
   `invincibility` / `moon_physics`** (they were hardcoded 0) — required once
   items can grant them. New optional checks `pow` / `inv` / `goal` / `secret`
   (plus the existing `lives`), all `#[serde(default)] Option<..>` so older
   captures still replay.
5. **`captures/trajectory_capture13.py` + `captures/traj13.json`** (4645 records,
   27 checks).

## `traj13`: what the route had to do, and the one open divergence

- **The pickup**: level 1's bit-7 objects are the anim-15 marker85 (3192, 496 —
  type `$85`, id 5 = 1-UP), the anim-22 pose86 (4008, 360 — `$86`, id 6 = goal
  bell) and the anim-23 pose87 (2792, 416 — `$87`, id 7 = secret route). The
  marker sits in a 2-tile cavity under the 448 ledge (rows 28 and 31 solid, no
  entrance) and pose86 is 108 px above the floor, so **pose87 is the only
  reachable one**. Its box sits *above* its slot y (the hop connects with Mario
  at y ≈ 355-405 while the object's y is 416), so the capture walks east from the
  hopper pair and hops with growing run-ups (6/10/14/18/22/26) until one crosses
  it; the second attempt (run-up 10) flips the console's `sSecretRouteFlag` to
  `$FF`, which the replay's new `secret` check confirms in the sim too.
- **The trim**: the *untrimmed* route continues east and its hops meet the 2880
  ledge's **side wall** from the floor — a geometry no earlier capture covers.
  There the sim's x step is +4 where the console's is +2 (first mismatch frame
  4652), which cascades: camera +2 → the scan edge (8-aligned) → the itempose
  record at 3016 spawns 2 frames early → `sptr`/`standby`/`uphase`/`ff0` diverge.
  `traj13` is trimmed at record 4645, the frame before it. **That divergence is
  the next target** — replay the untrimmed version (the scratch copy or by
  re-running the script, whose tail prints the full route) to reproduce. The run is frozen at `captures/traj13_full.json` (4719 records, sha1 `4e917a9bdd1ab7af629389570487928672fbab5f`).
  > **Superseded (wp7f, same day):** it is not a physics divergence and there is
  > no wall push-out there — two of the frozen run's records are *mid-frame*
  > snapshots (the record-16 spawn frame overruns its VBlank slot), which is why
  > x is a constant +2 off, and the death is the fallwalker's object contact.
  > See `.hermes/plans/2026-10-12_wp7f-handoff.md`; `captures/traj14.json` (the
  > same route, hook-sampled per logic frame) carries that tail as a gate
  > capture, and `traj13_full` is retired.
- **Sampling note**: this stretch is *tick-sampled* (like traj5-12) and its
  `$FFF0` deltas are 0/1 alternating, which is normal — do not read that as a
  slowdown. The lag-frame rule (use the `$05E4` hook) still applies to the death
  captures only, as wp7d documents.

## Open items (measured order)

1. **The ledge-side wall push-out** (above): the sim steps x by 4 where the
   console steps 2 when Mario runs into the 2880 ledge's side from below. Look at
   `$1413`'s push-out (`x += 1` + `x_pushed`) vs the integration order, and at
   the wall-probe revert in `$181C`; the repro is traj13's untrimmed tail.
2. **Bounce blocks** (`$7F` tiles): `$1DFE` matches `tile & $FE == 7E`, and
   `$5B06` (bank 1) draws the bump as `$FFC6 = 66` at the block's screen coords
   (`sBlockAnimTimer` = `$A23F`, `$5AE0` Y-offsets, `$5AF9` pose table
   `[$6D,$6E,$6F,$6E]`); the block-anim system is slotted (`sBlockAnimSlots`,
   types 1-6). Repro: hop through x 3872-3887.
3. **`$1BFF`'s exit-tile arm** (`$4A/$4B` → `$FF9B = 24` + fade 192 + music 3);
   reachable past x >= 4044.
4. **The unexercised item ids** (1-4/6/8/9) and the anim-16 post-touch arm: the
   writes are ported, no capture reaches them (they need block-spawned items or
   the sealed marker; the *goal bell* id 6 is pose86 at (4008, 360)).
5. Unchanged: the per-anim handlers with no ported body, the goal bell's own
   behaviour, the game-over screen, the scene system, the type-`$06` carry, and
   the `--play` gaps.

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. Capture JSON
  goes to `$OUT` = `~/.hermes/cache/scratch` (pruned after 24 h idle) — **copy it
  into `sml2-rs/captures/` the same session.**
- `captures/probe_c6_selector.py` — the `$530D` (bank 1) selector hook.
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`.
- Route-authoring trap that bit twice: a capture script's helper variables must
  not shadow `p` (the PyBoy object) — `sec, p, lv, ... = flag()` silently
  rebinds it.

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** traj5-13 + death1-3
replaying all-zero with no `note:` lines (`traj4_ff0` exempt).

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2decomp/sml2-rs` (untracked by request; `DESIGN.md` +
> `captures/README.md` are the docs). Read `.hermes/plans/2026-10-12_wp7e-handoff.md`
> and the wp7/wp7b/wp7c/wp7d docs behind it. Entry gate: `make clean &&
> make compare && sha1sum baserom.gb sml2.gb` (cmp exit 0, both
> `bba408539ecbf8d322324956d859bc86e2a9977b`), then `cargo build --release` and
> replay traj5-13 + death1-3: all must be all-zero with no `note:` lines
> (`traj4_ff0` is the documented exception). Next target: the **ledge-side wall
> push-out** (traj13's untrimmed tail: x +4 vs +2 at f4652 where the hops meet
> the 2880 ledge's side wall from below — reproduce it, then read `$1413`/`$181C`
> before touching anything). Then bounce blocks (`$7F` → `$5B06` frame 66, repro
> hop x 3872-3887) and the `$1BFF` exit-tile arm. Read the handler and the
> `$2EDD` box math first — do not tune inputs against PyBoy. Finish with the ROM
> gate re-run, `captures/README.md` + `DESIGN.md`, and a fresh handoff doc.
