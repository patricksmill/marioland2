# WP7d handoff — `sml2-rs` port: the hazard death is verified, and it moved a fix (2026-10-12)

Fourth doc of the 2026-10-12 series. Read wp7 (the three `traj10` fixes), wp7b
(docs correction + `traj11`) and wp7c (`traj12` + the hazard probe + the stream
terminator) first — this one corrects wp7c on one point and adds the capture that
found it. The port lives in `sml2-rs/` and is **untracked by request**.

## Measured state (verified this session)

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb   # cmp exit 0, both bba4085…
cd sml2-rs && cargo build --release
for f in traj5 traj6 traj7 traj8 traj9 traj10 traj11 traj12 death1 death2 death3; do
  ./target/release/sml2-runtime --level 0 --replay captures/$f.json | tail -1
done
```

Eleven captures, every one **all-zero** (traj5 381 / traj6 468 / traj7 838 /
traj8 2126 / traj9 2348 / traj10 5129 / traj11 6469 / traj12 6839 / death1 537 /
death2 837 / **death3 5806** compared, the last with 25 checks incl. `pcx`).
`traj4_ff0` keeps its documented legacy `$FFF0` divergence and is the only
exemption. No `note: unported …` line on any capture.

## The correction: a hazard hit dispatches in the SAME frame

wp7c claimed the `$1BFF` byte lands *after* the `$319F` dispatch, giving the hit
frame a normal move and a one-frame dispatch delay "like the object path". The
spike-death capture shows the opposite:

```
f5685 x=3708 y=452 vvel=$00 g=0 dead=00   ← last alive record
f5686 x=3710 y=452 vvel=$5F g=1 dead=FF   ← already dispatched
```

Reason, from the frame's routine order: `$1BFF` runs **inside** `$0F71`, and
`$319F` runs later in the same frame, so the 15 it writes is consumed
immediately. An object contact is different: `$2D7D` (the interaction pass) runs
*after* `$319F`, so its 15 waits for the next frame's `$319F` — which is what
`death1`/`death2` pin. Nothing between `$1BFF` and `$319F` reads `sMarioDead`
(the only readers are `$2D7D` at home.asm:6044, which runs after both, and the
dispatch itself), so placement at the probe vs at the dispatch is equivalent.

`player_sim::step` now applies the hazard byte immediately **before**
`death_dispatch()`. With the old placement `death3` diverged at frame 5688
(`slot 0 +0A sim=$D5 exp=$D6`, `pcx sim=$0EA0 exp=$0E9F`, then x/vvel through the
arc); with the order fixed it is zero.

## `death3`: the negative control itself

- `captures/death_capture3.py` — `trajectory_capture12.py`'s route with
  `death_capture1.py`'s `$05E4` hook sampling, then a deliberate hazard death:
  after the tower climb, walk east off the end of the 448 tier. Row 28 has no
  cell at 3696-3727, so Mario drops through the gap onto the `$81` spike cells
  and the probe at `(x+16, y+28)` (tile (232,29)) kills him ~10 frames into the
  fall. Level 1's hazard run is *only* these tiles (`$81` at row 29, tiles
  231-232) — confirmed by scanning all three level manifests, so a spike death
  cannot be captured earlier in the level.
- `captures/death3_raw.json` → `apply_pairing.py` → `captures/death3.json`
  (5807 records; **re-add `death3_raw.json`/`death3.json` to the copy-out list —
  the raw file lives in the pruned scratch dir**).

### Pitfall that cost a debugging round (now documented in the script)

With a `$05E4` hook owning the records, **the route must not append frames
itself**. `trajectory_capture12.py`'s pipe-exit section still did
`p.button_press(...)` + `frames.append(state(...))` per tick; keeping that in the
hook build double-recorded that stretch (the state repeats, alternating
no-keys/keys), which pushed the replay out of sync ~80 frames later at the pipe
travel exit. Fixed by routing that section through the same `set_keys()` helper
as everything else.

## Open items (measured order)

1. **Bounce blocks** (`$7F` tiles) — unchanged from wp7c and still first:
   `$1DFE` matches `tile & $FE == 7E`, and `$5B06` (bank 1) draws the bump as
   `$FFC6 = 66` at the block's screen coords (`sBlockAnimTimer` = `$A23F`,
   `$5AE0` Y-offsets, `$5AF9` pose table `[$6D,$6E,$6F,$6E]`). Repro: hop through
   x 3872-3887 (row 26, tile 242). The block-anim system is a *slotted* one
   (`sBlockAnimSlots`, types 1-6, entries created by the hit at main.asm ~690).
2. **`$1BFF`'s exit-tile arm** (`$4A/$4B` → `$FF9B = 24` + fade 192 + music 3 +
   `sExitTileFlag`/`sLowTimeFlag`; reachable once a route passes x >= 4044).
3. **Item pickup `$2DE0`/`$2DC6` + the `$3451` consumer** (the bobber's resting
   state is an item with id 0; ids 1-4 set powerup/star and, via `$3534`,
   `sInvincibilityTimer = 64`).
4. Unchanged: the per-anim handlers with no ported body, the goal bell / pose-86
   behaviour, the game-over screen, the scene system, the type-`$06` carry, and
   the `--play` gaps.

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. Capture JSON
  goes to `$OUT` = `~/.hermes/cache/scratch` (pruned after 24 h idle) — **copy it
  into `sml2-rs/captures/` the same session** (both `_raw` and paired files for
  the death captures).
- `captures/probe_c6_selector.py` — the `$530D` (bank 1) selector hook, for
  attributing a `frame`-check divergence.
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`.

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** traj5-12 + death1-3 replaying
all-zero (`traj4_ff0` exempt).

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2decomp/sml2-rs` (untracked by request; `DESIGN.md` +
> `captures/README.md` are the docs). Read `.hermes/plans/2026-10-12_wp7d-handoff.md`
> and the wp7/wp7b/wp7c docs behind it — every closed divergence is there with its
> ROM evidence, including the hazard death's same-frame dispatch (wp7d corrects
> wp7c on that). Entry gate: `make clean && make compare && sha1sum baserom.gb
> sml2.gb` (cmp exit 0, both `bba408539ecbf8d322324956d859bc86e2a9977b`), then
> `cargo build --release` and replay traj5-12 + death1-3; all must be all-zero
> (`traj4_ff0` is the documented exception). Next target: **bounce blocks** —
> model the `$7F`-tile bump (`sBlockAnimSlots`: the hit that creates an entry,
> `sBlockAnimTimer` phases, the tile replacement, and the `$5B06` `$FFC6 = 66`
> draw at the block's `$FFC4`/`$FFC5`), then re-cut `traj12`'s route to hop
> through x 3872-3887 and require zero. Then the `$1BFF` exit-tile arm and the
> item pickup. Read the handler and the `$2EDD` box math first — do not tune
> inputs against PyBoy; the bobber (`$584F3`), the block bump and the spike-drop
> geometry all cost hours when approached that way. Finish with the ROM gate
> re-run, `captures/README.md` + `DESIGN.md`, and a fresh handoff doc.
