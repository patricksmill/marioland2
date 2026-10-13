# WP7f handoff — the "ledge-side wall push-out" was the capture, and `traj14` closes it (2026-10-12)

Sixth doc of the 2026-10-12 series (wp7 → wp7b → wp7c → wp7d → wp7e → this). Read
wp7e first: it froze `captures/traj13_full.json` as the repro for the wall
push-out and prescribed reading `$1413`/`$181C`. **The repro was not a physics
divergence** — it is a tick-sampling artifact in that one capture — and the
push-out itself turns out to be unreachable in level 1. The port lives in
`sml2-rs/` and is **untracked by request**.

## Measured state (verified this session)

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb   # cmp exit 0, both bba4085…
cd sml2-rs && cargo build --release
for f in traj4_ff0 traj5 traj6 traj7 traj8 traj9 traj10 traj11 traj12 traj13 \
         traj14 death1 death2 death3; do
  ./target/release/sml2-runtime --level 0 --replay captures/$f.json | tail -1
done
```

Twelve captures all-zero plus the new **`traj14` (4718 records, 31 checks,
all-zero, 4717 frames compared)** — 13 gate captures in total. `traj4_ff0`
keeps its documented legacy `$FFF0` divergence (the only exemption) and its
numbers are unchanged by this session's port edit (it takes no push-out frame).
`traj13_full` diverges by design and is now **retired** (see below).

## What the divergence actually was

`traj13_full`'s record list is tick-sampled (one record per PyBoy tick). That is
1:1 with the console's logic frames only while every frame fits its VBlank slot.
The record-16 stream spawn (x=3016) makes that frame overrun, so the tick
boundary lands inside it:

- tick 4651 is sampled *mid-frame*, just before the spawn's `$8C8D`
  (`probe_frame_cadence.py`: `(05E4,0F71,8000,8C31,8C8D)` deltas `1 1 1 1 1`,
  with `sptr`/`standby` still stale in the record),
- tick 4652 enters `$05E4` **not at all** (deltas `0 0 0 0 0`) — the same console
  frame's completion, recorded a second time (only `sptr`/`standby` moved).

So the sim (which advances exactly one frame per record) is one console frame
ahead from f4652, then two after the second such record at 4661, and it never
resyncs. **Dropping records 4652 and 4661 replays the whole tail all-zero**
(x/cam/slots/frame/timer/dead zero; only the arc's last ~30 frames stay off,
because the death/fade stretch has the same lag-and-catch-up pattern and needs
the `$05E4` method the death captures use).

Corrections to wp7e's reading, all measured:

- **There is no wall at 2880.** `level01.decompressed.bin`, cols 180+ rows 26/27
  are `$60` (non-solid; the wall probe wants `<$38`). Mario lands *on* the row-28
  ledge (`$01`, top y=464) and its side is above his probe rows — so `$1413`
  never runs there and neither the console nor the sim ever pushes him out.
- **The console's x cadence there is the ordinary alternation** of hvel `$F3`
  (+2/+1 per frame). The "+0 steps" wp7e saw are the two duplicate records.
- **The death is the fallwalker's object contact.** Stream record 14 is anim 1
  at (2920, 448); Mario coasts into it at x≈2888 (dead 15 at the contact frame,
  `$FF` + vvel 95 the next), which is the documented *object-contact* ordering
  (`$2D7D` writes after `$319F`, so it dispatches one frame later than a
  `$1BFF` hazard). Nothing about it needed a port change.

## What this session changed

1. **`captures/trajectory_capture14.py` + `captures/traj14.json`** — the v13
   route verbatim (its tick count, **4719**, is the reproducibility check: the
   same as `traj13_full`'s record count), but the records come from a `$05E4`
   hook, i.e. one per logic frame (4718), then `apply_pairing.py`. This is the
   death_capture1-3 method applied to the whole trajectory. It is the first
   capture that replays the tail: the pickup, the coast, the drop onto the
   row-28 ledge, the record-16 spawn, the record-14 fallwalker contact, the
   dispatch and 55 arc frames, with `sptr`/`spx`/`odd`/`uphase`/`ff0`/
   `slots_raw`/`pcx` all matching.
2. **`crates/sml2-core/src/player_sim.rs` — `$181C` now adds the whole new
   `sMarioXSub` byte to x, not just the speed byte.** The ROM (`$3404-$3415`,
   verified against the raw bytes: `FA 02 A2` … `80` … `C6 10` … `D6 10`)
   accumulates `XSub = XSub_old + speed` and then adds *that* to x through the
   `add 16`/`sub 16` signed-byte trick; the probe side selector reads XSub's own
   sign. The two forms differ **only** when `$1413`'s push-out already folded
   its ±1 into XSub in the same frame, where the ROM moves 2 px (`x += ±1` then
   `x += speed ± 1`) and the port used to move 1. No-op for every capture in the
   suite (see below) — i.e. ROM-faithful but **not capture-verified**; flagged as
   such in DESIGN.md.
3. **`captures/probe_frame_cadence.py`** — the diagnostic that settled it. It
   re-runs capture13's route with cumulative call counters on `$05E4`, `$0F71`,
   `$8000`, `$8C31` and `$8C8D`, so the per-record deltas say which of them ran
   in each tick. Needs `baserom.gb.sym` next to the ROM (`rgblink -n sml2.sym -o
   /dev/null main.o; cp sml2.sym baserom.gb.sym`) because bank-2 hook addresses
   collide with PyBoy's VRAM-bank path; the capture14 hook (`$05E4`, bank 0)
   registers raw.
4. **`captures/traj13_full.json` retired** (file kept: it is the frozen evidence
   of the artifact) — superseded by `traj14`, documented in
   `captures/README.md`.
5. Docs: `captures/README.md` (traj14 + traj13_full rows, the sampling-method
   section, the cadence probe), `DESIGN.md` (the closed divergence, `traj14`, and
   a new verified-semantics bullet for the push-out).

## The push-out is unexercised, and unreachable in level 1

`$1413` fires only when Mario's *body* already overlaps a solid column at his
probe rows (x+11/x+20, y+20/+32/+40). Measured:

- **0 push-out frames** in the port across `traj4_ff0`, `traj8`-`traj13`,
  `death1`-`death3` (temporary trace on `$A218`/`sMarioXPushed`, the only byte
  `$1413` writes besides x/XSub).
- Level 1 has **no** `$0C-$0F` side-pipe cells and **no** `$04/$05` side-push
  cells (the only two tiles that move Mario *into* geometry), **no** `$0FBF`
  camera-clamp frame in any capture (`sx` stays in `[$10,$A0)`: measured on all
  15), and no horizontal screen transition (its one transition is the vertical
  pipe, traj9). Walking/falling into a column can't do it: `$129F`'s floor probe
  lands Mario on top a row earlier than the wall probe's rows reach the top row,
  and `$181C`'s revert undoes the offending x move.
- So the push-out is a safety net level 1 never needs. To capture it, take a
  level with a side pipe (`$0C-$0F`) or a `$04/$05` landing next to a wall —
  `$143D` arms the side pipe *from the push-out itself* — or a level where the
  camera can clamp; then the frames to compare are the push-out frame's 2 px and
  the `$181C` revert ("click") that follows.
- Related, unexercised for the same reason: `$12CE`'s landing side-push also
  `inc`s `sScrollDeltaRight` when hvel `>= $80` (`home.asm` `$2605`), which the
  port's `landing()` does not model. Only reachable on `$04/$05` tiles.

## Open items (measured order)

1. **Bounce blocks** (`$7F` tiles): `$1DFE` matches `tile & $FE == 7E`; `$5B06`
   (bank 1) draws the bump as `$FFC6 = 66` at the block's screen coords
   (`sBlockAnimTimer` = `$A23F`, `$5AE0` Y-offsets, `$5AF9` pose table
   `[$6D,$6E,$6F,$6E]`), and the block-anim system is slotted
   (`sBlockAnimSlots`, types 1-6). Repro: hop through x 3872-3887 (`traj12`
   deliberately walked past it).
2. **`$1BFF`'s exit-tile arm** (`$4A/$4B` → `$FF9B = 24` + fade 192 + music 3);
   reachable past x >= 4044.
3. **The unexercised item ids** (1-4/6/8/9) and the anim-16 post-touch arm: the
   writes are ported, no capture reaches them (they need block-spawned items or
   the sealed marker; the *goal bell* id 6 is pose86 at (4008, 360)).
4. **A push-out/side-push capture** (see above) — the only way to turn the
   `$181C` fix and the `$1413` path green.
5. Unchanged: the per-anim handlers with no ported body, the goal bell's own
   behaviour, the game-over screen, the scene system, the type-`$06` carry, and
   the `--play` gaps.

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. Capture JSON
  goes to `$OUT` = `~/.hermes/cache/scratch` (pruned after 24 h idle) — **copy it
  into `sml2-rs/captures/` the same session** (`apply_pairing.py <raw> <out>`
  writes the tree copy directly).
- New: `captures/probe_frame_cadence.py` (per-tick frame-address counters — the
  diagnostic for any "off by a frame" replay) and
  `captures/trajectory_capture14.py` (the hook-sampled route).
- `baserom.gb.sym` next to the ROM enables symbol-based hooks in PyBoy; it is
  gitignored and regenerated by the `rgblink -n` line above.
- `captures/probe_c6_selector.py` — the `$530D` (bank 1) selector hook.
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`.
- Route-authoring traps that have bitten: helper variables must not shadow `p`
  (the PyBoy object); and with the `$05E4` hook owning the records, a section
  must not also append to `frames` itself.

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** `traj4_ff0` + traj5-14 +
death1-3 replaying all-zero with no `note:` lines (`traj4_ff0` is the documented
exception; `traj13_full` is retired and not part of the gate).

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2decomp/sml2-rs` (untracked by request; `DESIGN.md` +
> `captures/README.md` are the docs). Read `.hermes/plans/2026-10-12_wp7f-handoff.md`
> and the wp7/wp7b/wp7c/wp7d/wp7e docs behind it. Entry gate: `make clean &&
> make compare && sha1sum baserom.gb sml2.gb` (cmp exit 0, both
> `bba408539ecbf8d322324956d859bc86e2a9977b`), then `cargo build --release` and
> replay traj4_ff0, traj5-14, death1-3: all must be all-zero with no `note:`
> lines (`traj4_ff0` is the documented exception). Capture records must come from
> a `$05E4` hook + `apply_pairing.py`, not per-tick sampling. Next target:
> **bounce blocks** (`$7F` → `$5B06` frame 66, repro hop x 3872-3887), then the
> `$1BFF` exit-tile arm (x >= 4044). Read the handler and the `$2EDD` box math
> first — do not tune inputs against PyBoy. If a replay goes "off by a frame",
> run `probe_frame_cadence.py` before touching the port: it is a capture-sampling
> symptom, not physics (that is what this WP was). Finish with the ROM gate
> re-run, `captures/README.md` + `DESIGN.md`, and a fresh handoff doc.
