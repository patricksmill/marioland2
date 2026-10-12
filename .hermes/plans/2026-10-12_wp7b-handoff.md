# WP7b handoff — `sml2-rs` port: docs corrected, suite extended east (`traj11`) (2026-10-12)

Continuation of `2026-10-12_wp7-handoff.md` (read that first — it has the three
`traj10` fixes and the ROM evidence for each). This session verified that state,
corrected the two stale docs, and added an 11th capture. The port lives in
`sml2-rs/` (`crates/sml2-core`, `sml2-extract`, `sml2-runtime`); it is
**untracked by request** — `git status` shows only `.gitignore` and the
`.hermes/plans/` docs.

## Entry/exit gate (re-run at the start and end of this session — both green)

```bash
make clean && make compare && sha1sum baserom.gb sml2.gb
# cmp exit 0; both hashes bba408539ecbf8d322324956d859bc86e2a9977b
cd sml2-rs && cargo build --release
for f in traj5 traj6 traj7 traj8 traj9 traj10 traj11 death1 death2; do
  ./target/release/sml2-runtime --level 0 --replay captures/$f.json | tail -1
done   # every one all-zero; traj4_ff0 keeps its documented legacy divergence
```

| capture | frames | result |
| :--- | ---: | :--- |
| `traj5` 381 / `traj6` 468 / `traj7` 838 / `traj8` 2126 / `traj9` 2348 / `traj10` 5129 | — | all-zero (as WP7 verified) |
| **`traj11`** | **6469 compared** | **all-zero, first replay** — ends mx=3586 my=468 dead=0 |
| `death1` 537 / `death2` 837 | — | all-zero (`traj4_ff0`: legacy only) |

No `note: unported …` line on any capture, including the new one.

## What this session changed

1. **`crates/sml2-core/src/player_sim.rs` module header** — the "Omitted" list
   was stale (it still claimed pipes, water, deaths, the pipe-travel gate and
   camera scroll deltas were missing; all were ported). It now names what is
   really missing there: the `$126F` spin jump (`$1327`), bounce blocks, the
   goal bell's behaviour, coin/fireball paths, the hazard probes. The
   implemented list gained the pipe arming/entry/travel (`$134F`/`$1189`/
   `$10EC`) and the death arc/fade/respawn (`$315C`/`$3186`/`$0F2A`) entries.
2. **`DESIGN.md`** — the "Open:" paragraph blamed "anim 8, 12, 20, 23 —
   dispatched but no-ops", which is measurably wrong: those four handlers are
   `$5862E`/`$584E0`/`$58755`/`$587D7` and all four are ported and covered by
   existing captures. The real unported set is the `$58040`/`$59C07` targets
   with no ported body (measured from `extracted/objects.json`:
   `anim_profiles_a` unported = anims 0/3/4/7/13/14/16/26/30-34/40-48/51-58/
   61-69/77-90/92-95, plus their mode-B counterparts), and `$58100`, which the
   ROM shows is a **bare `ret`** (`baserom.gb` $58100 = `C9`) — a genuine no-op
   handler to dispatch explicitly rather than flag. Also recorded: level 1's 23
   spawn records need none of them (they resolve to walkers, fallwalkers,
   hoppers, crawler, bobber, the item poses, poses 86/87 and `marker85`), so
   "extend the capture east" is the next target, not "implement anims".
   Added the WP7 milestone paragraph (the three `traj10` fixes) and the
   bobber/item semantics below.
3. **`captures/trajectory_capture11.py` + `captures/traj11.json`** — the east
   extension (below). Also `captures/README.md` gained the `traj11` row, the
   venv path and the "copy the JSON out of the scratch dir immediately" warning.

## `traj11`: extending east of x=3094

Prefix is `trajectory_capture10.py` byte-for-byte, so the capture reproduces
traj10's first 5129 frames and then continues. New span x 3094 → 3586, ending
just west of the 496/480/464 staircase tower at x=3616.

Terrain (measured from `extracted/levels/level01.decompressed.bin`, row-major
`txt[y*W+x]`, W=256 H=48) — this is the map for the *next* session:

| x (px) | what |
| ---: | :--- |
| 2880-3615 | floor top y=496 continuous (no pits); ledges row 28 (top 448) at 2880-3039 and 3120-3279; another at 3376-3535 |
| 3192 | the anim-15 `marker85` object (type `$85`, sits at y=496) |
| 3352 | walker (anim 9) |
| 3456 | the anim-12 bobber (the hard one — see below) |
| 3616-3807 | tower: solid at row 30 (y=480), row 29 (y=464, solid 3632-3695 and 3728-3791), row 28 (y=448, 3648-3695 and 3728-3775) |
| 3696-3727 | `$81` hazard (spike) tiles at y=464, in the gap of the row-29 shelf |
| 3672 / 3744 | walker / fallwalker (anim 1) |
| 4008 (y=360) | the anim-22 `pose86` object (`$587BD`: type `$86`, state 1 = shared spin when `+23` bit4 is set) |
| 4064 (tile 254, row 30) | the level's `exit` tile (`$4A`) — the goal; stop short of it |

### The bobber, derived from the ROM (do not re-derive by trial and error)

`$584F3` (state 0) writes type `$80` to `sObjectType`, then `call $5B4B4`
(= `dist_mario_x`) / `cp $18` / `ret c`: **it returns while Mario is within
24 px**, so it cannot arm while he stands beside it. Outside 24 px it sets
state 1, `+24` = `+25` = 32 and type `$44` (68). `$5850C` etc. then travel
1 px/frame: 32 frames up, 32 down, 24 frames rest (`bobber_reload`).

- Type `$44` has bit 6 set → `$2E6F` kills (`harm_or_star`), and `$44 & $23 ==
  0` sends **both** arms of the `$2DC6` response to harm — there is no stomp.
- Its harm box is x ∈ [objX−19, objX+2), y ∈ [objY−51, objY−25) (measured: the
  two deaths landed at exactly `marioY = objY − 51`, both with `vvel` 0-1, i.e.
  the `y_delta >= $0C` arm). A walker on the 448 ledge has `y=436`, inside that
  y-band at **both** ends of the 28 px travel, so no jump height or timing
  clears it — four route attempts died proving that.
- **The crossing**: park inside the 24 px trigger but outside the 21 px box
  (x ∈ (objX−24, objX−19) = (3432, 3437)), wait for the object to cycle into
  state 0 (it then latches `$80` and stays), then walk through. Contact takes
  the `$80` branch, writing `sPendingItemId = 0`, which `$3451`'s `and a / ret z`
  drops — no item, no death.
- Route mechanics that matter: **brake to `hvel = $80` before parking** (coasting
  carries Mario into the box), and creep in with single-frame taps; a straight-up
  stomp on the walker at 3352 at dx=−19 is a side contact — jump *over* it.

## Open items (next targets, in measured order)

1. **The hazard probe `$1BFF`** (`player_sim.rs` "hazard/death probes omitted"):
   the spikes at x 3696-3727 are `$81` hazard tiles, so any route over the tower
   needs the probe ported (the tile class vocabulary is already extracted:
   solid < `$38`, standable < `$48`, coin `$48/$49`, exit `$4A/$4B`, water
   `$4C-$4F`, hazard `$50/$51`, moon `$52-$57` — and `$81` renders as `hazard`
   in `level01.manifest.json`'s `metatile_classes`).
2. **Item pickup `$2DE0`/`$2DC6` + the `$3451` consumer** — the bobber's resting
   state is an item (`$80`); the port currently only sets the slot flag and
   `note_unported(0x2DC6)`. No current capture reaches it (traj11's crossing
   produced no note — verify if you extend again), but the path is 30 lines and
   is the item half of `$2DC6`. Also the listed `--play` bug "floating
   item/mushroom".
3. **East of the tower**: the pose-86 object at 4008 and the exit tile at 4064
   (the goal bell — `$goal_bell` exists in the player state but the behaviour is
   unported; the `$58000` prologue already reads `sGoalBell`).
4. Unchanged from WP7: the per-anim handlers with no ported body (list above),
   the game-over screen, the scene system proper, the type-`$06` carry, and the
   `--play` gaps (Goomba Y, Koopa per-tile flip, enemies static, HUD zeros).

## Tools

- PyBoy venv (durable): `/home/pmill/.venvs/sml2-pyboy/bin/python`. The earlier
  one lived under the scratch dir and was pruned; recreate with
  `python3 -m venv ~/.venvs/sml2-pyboy && ~/.venvs/sml2-pyboy/bin/pip install pyboy pillow`.
- Capture scripts write their JSON to `$OUT` = `~/.hermes/cache/scratch`, which is
  pruned after 24 h idle — **copy the result into `sml2-rs/captures/` in the same
  session**. `trajectory_capture11.py` also writes `traj11_<frame>_<tag>.png`
  screenshots there for eyeballing.
- Replay: `./target/release/sml2-runtime --level 0 --replay captures/<f>.json`
  (`--level 0` = `level01.bin`; the CLI index is 0-based). Aborts of a capture
  script dump their partial frames to `traj11_fail.json` — analyse the first
  `dead != 0` frame and the slot fields around it.

## Exit gate

ROM gate green (`cmp` exit 0, both hashes
`bba408539ecbf8d322324956d859bc86e2a9977b`) **and** every capture in the table
above replaying all-zero (`traj4_ff0` exempt: its documented legacy `$FFF0`
divergence).

## Copy-paste handoff prompt

> Continue the live-verified Rust port of Super Mario Land 2 in
> `/home/pmill/sml2decomp/sml2-rs` (untracked by request; `DESIGN.md` +
> `captures/README.md` are the docs). Read `.hermes/plans/2026-10-12_wp7-handoff.md`
> and then `2026-10-12_wp7b-handoff.md` — they carry the measured state, the ROM
> evidence for every closed divergence, and the bobber state machine. Entry gate:
> `make clean && make compare && sha1sum baserom.gb sml2.gb` — `cmp` exit 0 and
> both hashes `bba408539ecbf8d322324956d859bc86e2a9977b`, else STOP. Then
> `cargo build --release` and replay traj5-11 + death1-2; all must be all-zero
> (`traj4_ff0` is the documented exception) and `traj11` must end mx=3586
> dead=0. Next target, in this order: (1) port the `$1BFF` hazard probe so the
> tower at x=3616 can be crossed (spikes `$81` at 3696-3727); (2) port the
> `$2DE0`/`$3451` item pickup; (3) extend the route past the tower to the
> pose-86 object at 4008, stopping short of the exit tile at 4064. Derive route
> decisions from the ROM (the terrain table in the wp7b doc) — do not tune jump
> timing against PyBoy; read the handler and the `$2EDD` box math first. Finish
> with the ROM gate re-run and a fresh handoff doc.
