# Plan — the greedy handler tail: six handlers, four levels finished

**Repo:** `/home/pmill/sml2-rs` (its own git repo; the disassembly is `/home/pmill/sml2decomp`)
**Written:** 2026-10-16 11:15 EDT · for an implementer with **no prior context**
**Base commit:** `bbd53ac` (tree clean at planning time)

---

## Goal

Port the six unported bank-`$16` object handlers `0x586EB`, `0x5B0D5`, `0x5AFD7`, `0x5A773`, `0x5A545`, `0x591F9` — one ticket each, with byte-assertion tests — so levels **12, 19, 28 and 29** have every handler in their object streams implemented.

## Current context / assumptions

Everything below was **measured** at planning time (`extracted/objects.json`, `extracted/levels/*.manifest.json`, `baserom.gb` via `SML2_DECOMP_ROOT`, `handler_coverage.json`).

1. **Coverage today:** 17 of 100 spawn handlers implemented (457 of 949 static placements, 48.2%). 83 unported. Eight levels already have every handler ported: `level01`, `level03`, `level20`, `level26`, `level27`, `level30`, `level31`, `level32`.
2. **The six targets** (profiles are per level mode — A for level ids 0–9, B for 10–31):

   | ROM addr | module to create | anim (tables) | levels (placements) | entry bytes | profile `states` |
   |---|---|---|---|---|---|
   | `0x586EB` | `objects/handler_0x586eb.rs` | 30 (A+B) | level28 (1) | `CD 84 76 F0 D5 C6 66 E0 E2 C9` | none (plain routine) |
   | `0x5B0D5` | `objects/handler_0x5b0d5.rs` | 90 (B) | level19 (5), level29 (3) | `CD 21 75 F0 DF EF E5 70 F8 70 1E 71 37 71 5D 71` | 6 |
   | `0x5AFD7` | `objects/handler_0x5afd7.rs` | 88 (B) | level19 (1) | `F0 DF EF E4 6F F4 6F FB 6F 37 70 5E 70 3E 4D E0` | 6 |
   | `0x5A773` | `objects/handler_0x5a773.rs` | 77 (B) | level12 (8), level14 (2), level19 (9) | `F0 DF A7 20 0F 3E 4D E0 E2 CD C6 73 3E 18 E0 E9` | 4 |
   | `0x5A545` | `objects/handler_0x5a545.rs` | 68 (B) | level12 (3) | `F0 DF A7 20 1E 3E 20 E0 E2 3E 10 E0 DE CD C6 73` | 3 |
   | `0x591F9` | `objects/handler_0x591f9.rs` | 58 (A+B) | level06 (9), level12 (5), level17 (1), level23 (1), level28 (5) | `CD 21 75 F0 DF A7 20 0C 3E 56 E0 E2 3E 10 E0 DE` | A: 4 / B: 50 |

   `levelNN` = level id NN−1, so `--level 11` is level12, `--level 18` level19, `--level 27` level28, `--level 28` level29.
3. **Staging map** (`crates/sml2-core/src/objects/staging.rs`, `$FFD0` base): `$FFD5`=`B_DEF` (the staged anim byte), `$FFDE`=`B_FLASH`, `$FFDF`=`B_FSTATE`, `$FFE2`=`B_TYPE`, `$FFE9`=`B_T25`, `$FFF0`=`sim.fff0`. Handlers read/write `st.b[B_*]` for these.
   - Verified example: `0x586EB` is `call $7684; ldh a,[$FFD5]; add $66; ldh [$FFE2],a; ret`, and `$7684` (ROM `$5B684`) is `ldh a,[$FFF0]; and $03; ret nz; …; ldh a,[$FFDE]; xor $10; ldh [$FFDE],a; ret`. So it is a 4-frame gated flash toggle plus `B_TYPE = B_DEF + $66`.
   - Note: the existing helper `helpers.rs::flash_toggle` is the **mask-1** variant (`$768B`), *not* this one. Do not pass it as a dependency for `$7684` (different contract).
4. **Policy you must follow** (`PORTING.md`): one ticket = one handler; a `#[test]` that constructs state in memory and asserts **bytes**; a new test must **fail** when the line under test is reverted; full suite + frozen sweep once **per package** (not per handler). **Forbidden:** new `captures/*.json`, capture scripts, steering the emulator, touching `notes/`, reading `DESIGN.md`/`PORT_QUEUE*.json`/whole `main.asm` for a handler ticket.
5. **Tooling you will use** (`tools/README.md`): `tools/dispatch_prompt.py --addr 0x… --module <path>` **regenerates** `tasks/handlers/0x…md` and refuses to run if the brief is `INCOMPLETE`. The brief's ROM-addressed instruction listing is the **source of truth** for behaviour.
6. **Generated/ignored files — never commit:** `handler_coverage.json`, `extracted/`, `target/`, `captures/*_raw.json`.
7. Assumption: the six are independent; no new shared prerequisite is known. If a brief exits 2 / says INCOMPLETE, see *Risks* and stop for that ticket only.

## Architecture / proposed approach

Each handler becomes one focused sibling module under `crates/sml2-core/src/objects/` (body + inline `#[cfg(test)] mod tests`), registered with one `mod …;` line in `objects/mod.rs` and dispatched by one arm in `objects/dispatch.rs`. No shared file grows: bodies stay out of `walkers.rs`/`boss.rs`, and no module exceeds ~400 lines. Verification per ticket = targeted test → mutation check → full suite → one commit; then one package-level sweep, coverage refresh and doc update at the end.

---

## Step-by-step tasks

### Task 0 — preflight (5 min, no edits)

```bash
cd /home/pmill/sml2-rs
git status --short                      # expect: empty output
git log --oneline -3                    # expect: bbd53ac at the top
cargo test -p sml2-core 2>&1 | tail -3  # expect: test result: ok. 356 passed; 0 failed; … 0 filtered out
python3 tools/handler_coverage.py; echo "exit=$?"
# expect: wrote handler_coverage.json: 17/100 spawn handlers implemented; 16 boss-table handlers pending
#         exit=1   (1 = pending work; a 2 = invalid inputs, STOP and report)
```

Also confirm the disassembly gate once, since every brief reads the ROM through it:

```bash
cd /home/pmill/sml2decomp && make clean && make compare && sha1sum baserom.gb | cut -c1-40
# expect: cmp exits 0; sha1 starts bba408539ecbf8d322324956d859bc86e2a9977b
cd /home/pmill/sml2-rs
```

### The recipe (this is Task 1 in full; Tasks 2–6 repeat it with the listed address/module)

For `ADDR` (`0x586EB`) and `MODULE` (`crates/sml2-core/src/objects/handler_0x586eb.rs`):

**1.1 Generate the brief + the worker prompt.**

```bash
python3 tools/dispatch_prompt.py --addr 0x586EB --module crates/sml2-core/src/objects/handler_0x586eb.rs
```
Expected: stdout begins `Port object handler ROM 0x586EB.` and names exactly three files to touch (`MODULE`, `dispatch.rs`, `mod.rs`); `tasks/handlers/0x586EB.md` now exists and contains `**Slice status: COMPLETE**`.
If instead you see `dispatch error: incomplete brief; resolve dependencies before dispatch`, STOP this ticket → *Risks*.

**1.2 Read (only these).** `tasks/handlers/0x586EB.md` (instruction listing + "Existing helper dependencies" + "Unresolved work"), plus `crates/sml2-core/src/objects/walkers.rs` as the closest sibling (`handler_marker85`, `handler_marker66`, `handler_pickup16` — same `$58xxx` marker family), `objects/staging.rs`, `objects/helpers.rs`.

**1.3 Write the failing test (TDD step 1).** Create `crates/sml2-core/src/objects/handler_0x586eb.rs`:

```rust
//! Handler ROM `0x586EB` (bank `$16`, CPU `$46EB`) — anim 30 in both profile tables.
//!
//! `$5B6EB`: `call $7684; ldh a,[$FFD5]; add $66; ldh [$FFE2],a; ret`.
//! `$7684` is the 4-frame flash toggle (`$FFDE ^= $10` when `$FFF0 & 3 == 0`).

use super::*;

impl ObjectSim {
    pub(super) fn handler_0x586eb(&mut self, st: &mut Staging) {
        let _ = st; // replace with the real body in step 1.5
        unimplemented!()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    // If the body needs a layout or the tables, add these fixtures — and only
    // if a test uses them (an unused fixture is a `dead_code` warning, which
    // breaks the "no warnings" gate):
    //
    // fn tables() -> ObjectTables {
    //     serde_json::from_str(include_str!(concat!(
    //         env!("CARGO_MANIFEST_DIR"),
    //         "/../../extracted/objects.json"
    //     )))
    //     .unwrap()
    // }
    // fn layout() -> LevelLayout { LevelLayout::from_bytes(&[0x60; 0x3000]).unwrap() }

    #[test]
    fn handler_0x586eb_toggles_flash_on_the_four_frame_gate_only() {
        // ROM `$5B684`: `ldh a,[$FFF0]; and $03; ret nz` guards the `$FFDE ^= $10`.
        let mut sim = ObjectSim::new(vec![], 0);
        for (fff0, flash) in [(1u8, 0xA5u8), (3, 0xA5), (4, 0xA5 ^ 0x10)] {
            sim.fff0 = fff0;
            let mut st = Staging::default();
            st.b = [0x5A; 32];
            st.b[B_FLASH] = 0xA5;
            sim.handler_0x586eb(&mut st);
            let mut expected = [0x5A; 32];
            expected[B_FLASH] = flash;
            assert_eq!(st.b, expected, "fff0={fff0}");
        }
    }

    #[test]
    fn handler_0x586eb_sets_type_from_the_staged_anim_byte() {
        // `add $66` wraps: $FFD5 = $B0 -> $FFE2 = $16.
        let mut sim = ObjectSim::new(vec![], 0);
        sim.fff0 = 1; // blink gate closed: only the type write is observed
        let mut st = Staging::default();
        st.b = [0x5A; 32];
        st.b[B_DEF] = 0xB0;
        sim.handler_0x586eb(&mut st);
        let mut expected = [0x5A; 32];
        expected[B_DEF] = 0xB0;
        expected[B_TYPE] = 0x16;
        assert_eq!(st.b, expected);
    }
}
```

**Verify the test fails for the right reason, not a compile error:** the file compiles as written (`unimplemented!()`), so:

```bash
cargo test -p sml2-core handler_0x586eb 2>&1 | tail -8
# expect: 'panicked at … not yet implemented' and 'test result: FAILED. 2 failed; 0 passed; …'
```
The `expected` values above come from the ROM bytes; **if the brief's listing disagrees with any of them, the brief wins** — fix the test, say so in the commit body.

**1.4 Register and dispatch (so the test can run at all).**
- `crates/sml2-core/src/objects/mod.rs`: in the module list (after `mod helpers;` / near the other `mod handler_…` entries once they exist) add
  ```rust
  mod handler_0x586eb;
  ```
- `crates/sml2-core/src/objects/dispatch.rs`: add exactly one arm at the end of the level-handler block, directly after `0x5B28C => self.handler_floater95(st),`:
  ```rust
  0x586EB => self.handler_0x586eb(st),
  ```
  Take only the parameters the body needs; if a parameter is unused, name it `_x` (rustc warns on unused parameters otherwise). Allowed shapes seen in siblings: `(st)`, `(st, tables)`, `(st, layout)`, `(st, layout, tables)`.

**1.5 Implement minimally** (replace the `unimplemented!()` body with the brief's steps, in ROM order). For this handler the verified ROM shape is:

```rust
    pub(super) fn handler_0x586eb(&mut self, st: &mut Staging) {
        // $5B684: `ldh a,[$FFF0]; and $03; ret nz` — the 4-frame gate.
        if self.fff0 & 3 == 0 {
            st.b[B_FLASH] ^= 0x10;
        }
        // `ldh a,[$FFD5]; add $66; ldh [$FFE2],a`.
        st.b[B_TYPE] = st.b[B_DEF].wrapping_add(0x66);
    }
```

**1.6 Run to green:**

```bash
cargo test -p sml2-core handler_0x586eb 2>&1 | tail -3
# expect: test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 356 filtered out
```

**1.7 Mutation check (the "fails on revert" rule).** Run this — it edits the file, runs the test, and restores the file:

```bash
python3 - <<'PY'
from pathlib import Path
import subprocess
p = Path('crates/sml2-core/src/objects/handler_0x586eb.rs'); original = p.read_text()
try:
    # one-line mutation of the behaviour under test
    p.write_text(original.replace('B_TYPE] = st.b[B_DEF].wrapping_add(0x66)', 'B_TYPE] = st.b[B_DEF].wrapping_add(0x65)'))
    r = subprocess.run(['cargo', 'test', '-p', 'sml2-core', 'handler_0x586eb'], capture_output=True, text=True)
    print('rc =', r.returncode)
    assert r.returncode != 0, 'ERROR: mutation survived'
    print('\n'.join(l for l in r.stdout.splitlines() if 'test result' in l))
finally:
    p.write_text(original)
PY
# expect: rc = 101 and 'test result: FAILED. 1 failed; 1 passed; …'
```
Then re-run step 1.6 to prove the file was restored (`ok. 2 passed`).

**1.8 Commit (one focused commit per handler):**

```bash
git add crates/sml2-core/src/objects/handler_0x586eb.rs \
        crates/sml2-core/src/objects/dispatch.rs \
        crates/sml2-core/src/objects/mod.rs \
        tasks/handlers/0x586EB.md
git commit -m 'Port object handler 0x586EB (anim 30 marker) with byte tests' \
           -m 'ROM $5B6EB: $7684 4-frame flash toggle, then B_TYPE = B_DEF + $66.
Gate: cargo test -p sml2-core <N> passed; handler_0x586eb tests 2 passed, mutation fails.'
git log --oneline -1 && git status --short   # expect: your commit; empty status
```

### Task 2 — `0x5B0D5` (anim 90; completes **level29**, 5 placements in level19)

Same recipe, with:

```bash
python3 tools/dispatch_prompt.py --addr 0x5B0D5 --module crates/sml2-core/src/objects/handler_0x5b0d5.rs
```
- `mod handler_0x5b0d5;` · arm `0x5B0D5 => self.handler_0x5b0d5(st, …),` at the end of the level block.
- Test names: `handler_0x5b0d5_*` (e.g. `handler_0x5b0d5_unknown_state_reports`, mirroring `wario21_tests.rs`'s `handler_0x0aaa5_unknown_state_reports_without_staging_writes`).
- The entry is `call $7521; ldh a,[$FFDF]; rst $28` and the profile reports **6 states**; the recovered `rst $28` targets are a data table the brief lists — take them from the brief, do not infer them from the entry bytes. Assert the first state's writes **and** the state byte (`B_FSTATE` = `$FFDF`) for at least two states, plus a boundary (a state value past the table → the report path the brief shows — mirror the sibling's unknown-state test).
- Mutation hint: change one state-table target or one `B_T25`/`B_SCRX` write by ±1.

### Task 3 — `0x5AFD7` (anim 88; 1 placement in level19)

```bash
python3 tools/dispatch_prompt.py --addr 0x5AFD7 --module crates/sml2-core/src/objects/handler_0x5afd7.rs
```
- `mod handler_0x5afd7;` · arm `0x5AFD7 => self.handler_0x5afd7(st, …),`.
- Shape: the entry loads the state byte (`ldh a,[$FFDF]`) and does `rst $28`; the profile reports **6 states**, and after the `rst $28` operand the bytes `3E 4D E0 E2` are `ld a,$4D; ldh [$FFE2],a` — so the state byte ends up `$4D` on that path. Take the state targets and every other write from the brief.
- Mutation hint: the `$4D` constant, or a state arm's `B_FLASH` write.

### Task 4 — `0x5A773` (anim 77; completes **level19** with Tasks 2–3; 8 placements in level12, 2 in level14)

```bash
python3 tools/dispatch_prompt.py --addr 0x5A773 --module crates/sml2-core/src/objects/handler_0x5a773.rs
```
- `mod handler_0x5a773;` · arm `0x5A773 => self.handler_0x5a773(st, …),`.
- Entry: `ldh a,[$FFDF]; and a; jr nz,+$0F; ld a,$4D; ldh [$FFE2],a; call $73C6; ld a,$18; ldh [$FFE9],a; …` — a 4-state machine that calls `$73C6` (bank-22 CPU `$73C6`, ROM `$5B3C6`). If `$73C6` is not in the brief's dependency list, check whether the port already models it (`grep -rn "73C6" crates/sml2-core/src/objects/`) — if yes, tell the supervisor to re-run the slicer with `--dependency '0x73C6=<file>::<method>'`; if no, that is a prerequisite: stop this ticket and split it (Risks).
- Mutation hint: the `$4D` constant or the `$18` written to `$FFE9`.

### Task 5 — `0x5A545` (anim 68; completes **level12** with Task 6; 3 placements)

```bash
python3 tools/dispatch_prompt.py --addr 0x5A545 --module crates/sml2-core/src/objects/handler_0x5a545.rs
```
- `mod handler_0x5a545;` · arm `0x5A545 => self.handler_0x5a545(st, …),`.
- Entry: `ldh a,[$FFDF]; and a; jr nz,+$1E; ld a,$20; ldh [$FFE2],a; ld a,$10; ldh [$FFDE],a; call $73C6; …` — 3 states; same `$73C6` caveat as Task 4.
- Mutation hint: `$20` → `$1F`, or `$10` → `$11`.

### Task 6 — `0x591F9` (anim 58; **the big one** — 50 states in mode B; completes level12 and level28)

```bash
python3 tools/dispatch_prompt.py --addr 0x591F9 --module crates/sml2-core/src/objects/handler_0x591f9.rs
```
- `mod handler_0x591f9;` · arm `0x591F9 => self.handler_0x591f9(st, …),`.
- If the slicer exits 2 and names the state budget, re-run with a larger budget **and keep the same module path**:
  ```bash
  python3 tools/dispatch_prompt.py --addr 0x591F9 --max-states 2000 --module crates/sml2-core/src/objects/handler_0x591f9.rs
  ```
  Never hand-roll the state table from the ROM: the brief's expanded listing is the contract.
- If this module approaches 400 lines, split the handler family by state group into a second module per `PORTING.md`/tools README — do **not** push it over 400.
- Minimum coverage for this ticket: one test per *distinct* state (the brief numbers them), one test for the entry gate (`ldh a,[$FFDF]`), and one boundary (state past the table).
- Mutation hint: any single state arm's byte write.

### Task 7 — package closeout (after all six commits)

1. **Full suite, no warnings:**
   ```bash
   cargo test 2>&1 | grep -E "test result|^warning|^error"
   # expect: core = 356 + (tests you added) passed; runtime 11 passed; no warning lines
   ```
2. **Frozen sweep (once for the package):**
   ```bash
   set -o pipefail; bash captures/sweep.sh 2>&1 | tail -n 25
   # expect exactly two lines: the traj4_ff0 mismatch line and 'gate done'; no 'note:' lines
   ```
3. **Coverage refresh + acceptance of the six:**
   ```bash
   python3 tools/handler_coverage.py; echo "exit=$?"
   # expect: wrote handler_coverage.json: 23/100 spawn handlers implemented; 16 boss-table handlers pending
   #         exit=1 (still pending work, 63 handlers left)
   python3 - <<'PY'
   import json
   d = json.load(open('handler_coverage.json'))
   want = {0x586EB, 0x591F9, 0x5A545, 0x5A773, 0x5AFD7, 0x5B0D5}
   missing = want - set(d['ported_spawn_reachable'])
   assert not missing, [hex(h) for h in missing]
   assert not (want & set(d['unported_spawn_reachable']))
   print('all six implemented;', len(d['unported_spawn_reachable']), 'handlers left')
   PY
   # expect: all six implemented; 63 handlers left
   ```
4. **Level-completion check (the package's reason to exist):**
   ```bash
   python3 - <<'PY'
   import json
   obj = json.load(open('extracted/objects.json')); cov = json.load(open('handler_coverage.json'))
   idx = json.load(open('extracted/levels/index.json')); ported = set(cov['ported_spawn_reachable'])
   done = []
   for e in idx['levels']:
       lid = e['level_id']; key = f'level{lid+1:02d}'
       man = json.load(open(f'extracted/levels/{key}.manifest.json'))
       prof = obj['anim_profiles_b' if lid >= 0x0A else 'anim_profiles_a']
       if not ({prof[r['anim_index']]['handler'] for r in man['spawns']['records']} - ported):
           done.append(key)
   print(len(done), done)
   PY
   # expect: 12 ['level01', 'level03', 'level12', 'level19', 'level20', 'level26', 'level27', 'level28', 'level29', 'level30', 'level31', 'level32']
   ```
5. **Docs:** in `docs/feature-inventory.md`, add one row per handler family (copy the format of the `wario-sprite-cycle` row: `| <name> | <addr> ($16) | \`ObjectSim::handler_0x…\` | <tests; mutations fail; N core tests> | <what is still open> |`) and update the `object-dispatch` row's counts (`17/100` → `23/100`). **Do not** commit `handler_coverage.json` (git-ignored) or `extracted/`.
6. **Optional human smoke (not a gate; needs a display):**
   ```bash
   cargo run -p sml2-runtime -- --level 27 --play --keys "................R.........RR......A...."
   # expect at tape end: a `tape end at frame …` line whose `unported={:?}` list is EMPTY
   ```
   Weak evidence by construction — it only proves the objects the tape actually reached dispatched without reports. Repeat for `--level 11`, `--level 18`, `--level 28` if desired. Do **not** turn this into a capture.
7. **Final commit:**
   ```bash
   git add docs/feature-inventory.md
   git commit -m 'Docs: handler tail package — six handlers, L12/L19/L28/L29 complete'
   git status --short   # expect: empty
   ```

## Tests / validation (summary)

| Level | Check | Command | Expected |
|---|---|---|---|
| per handler | targeted test | `cargo test -p sml2-core handler_0x<ADDR>` | `ok. <n> passed; 0 failed` (after the RED step) |
| per handler | revert-one-line | the mutation script in 1.7 | nonzero rc, `test result: FAILED` |
| per handler | suite | `cargo test -p sml2-core` | all pass, no warnings |
| per package | frozen corpus | `bash captures/sweep.sh \| tail -25` | `traj4_ff0` baseline unchanged + `gate done` |
| per package | coverage | `tools/handler_coverage.py` + the assertion script | 23/100; all six in `ported_spawn_reachable` |
| per package | levels | the level-completion script | 12 levels, including L12/L19/L28/L29 |
| hygiene | no stray files | `git status --short` after each commit | empty |

## Execution log (update as tickets land)

- **Task 1 `0x586EB` — DONE** `2a3825b` (2 tests; supervisor re-verified: 358+11 green, an
  independent mutation of the `& 3` gate mask rejected).
- **Task 2 `0x5B0D5` — DONE** `6025b60` (5 tests; supervisor re-verified: 363+11 green, an
  independent swap of `sprite_toggle1`→`sprite_toggle` killed 2 tests). Two verified
  corrections to this plan's notes: `$7521` *is* `sprite_toggle1` and `$73C6` is a thin
  wrapper over `$73E0` (the routine `face_mario` inlines) — both byte-checked; and the
  profile's 6th "state" is the slicer reading one word past the 5-entry table.
- **Task 3 `0x5AFD7` — BLOCKED, prerequisite split out.** Its state-3 arm runs
  `ld a,$70 / ld [sObjectSpawnSprite] / ld a,$59 / ld [sObjectSpawnAnim] / call $5B36D`
  at `$5B052`. `$5B36D` is the shared "spawn a child into the first free slot" routine and
  it stamps the child's `+6`/`+7` from `sObjectSlotPtrHi/Lo` (`$AF28/$AF29`) — the *current*
  slot's pointer, which the ROM's `$8131` loop writes per slot and the port only models on
  the boss path (`boss_slot_ptr_lo`). `$5B36D` is called from 8 sites, three of them ours
  (Task 3 `$5B052`, Task 4 `$5A7EB`, Task 6 `$596F7`), so it is a package prerequisite.
  Dispatched as its own ticket; re-dispatch Task 3 when it lands.
- Also discovered while verifying: `helpers.rs::bonus_spawn` derives the child pointer as
  `0xAD + (i >> 1)` / `(i & 1) * 0x20`, while the ROM's slot walk (`$AD00 + i*$0x20`, state
  byte at `+8`) decomposes to `0xAD + (i >> 3)` / `((i & 7) * 0x20) + 8`. No test pins those
  bytes. Not in scope here — reported, not changed.

## Risks, tradeoffs, open questions

1. **INCOMPLETE briefs.** `handler_task.py` exits 2 (no brief) when it hits a computed transfer, an unknown bank write, a stack return, or a budget limit. Response, in order: (a) budget → re-run with `--max-states 2000`; (b) a call target that already exists in the port → re-run with `--dependency '0x…=<file>::<method>'` **only** if the ROM entry and the Rust method have the same effects (mask/limits included) as the tools README demands; (c) otherwise the target is an unported prerequisite → write it as its own ticket first and stop this one. Never guess behaviour from bytes when the brief is incomplete.
2. **`$73C6` and `$7521` may be unported prerequisites** (Tasks 2, 4, 5, 6 call them). If so, the package shrinks: finish the tickets whose briefs are COMPLETE, and report the prerequisite list instead of forcing the rest. This is the single most likely way this plan changes shape.
3. **`0x591F9` is 50 states in mode B** — the largest slice here and the most likely to blow the 400-line module rule. Split by state group; keep one dispatch arm.
4. **`--keys` tape smoke is weak and needs a display** — it is listed as optional on purpose. The unit tests are the acceptance evidence (`captures/` stays frozen; no new captures, per `PORTING.md`).
5. **"Most used" here is static placement**, not runtime frequency: `handler_coverage.py` counts declared dispatch from the level manifests, and dynamic spawn chains (objects spawning objects) are explicitly out of its scope. Finishing L12/L19/L28/L29 does **not** prove those levels are completable end-to-end (exit tiles, scenes, the map hand-off are separate milestones).
6. **Do not touch the queue's `remaining_handler_classes` item** — it covers all 83 handlers and stays pending until the tail is done. Do not add `note` fields to queue items (`PORTING.md`).
7. **Open question for the owner (not a blocker):** the six handlers are chosen for level completion; if breadth matters more than completion, the same measurement ranks `0x59CE7` (27 placements) and `0x5AA71`/`0x59763` (19/18 in two levels each) higher — swap them in for Tasks 5–6 if the goal changes.
