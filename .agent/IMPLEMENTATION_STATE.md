# IMPLEMENTATION_STATE.md — current checkpoint (2026-11-01)

Older detail lives in `archive/`. Rules: `ENGINEERING_RULES.md`. Per-feature statuses: `implementation.md`.

## Baselines and branches
- Default branch `main`: `b428a8d` ("Initial commit: MulkCare") — React/Vite prototype, tag `baseline-react-prototype`. Never device-tested as an app. DO NOT MERGE into main without owner's say-so.
- Working branch: `feature/flutter-migration` — latest CI-green build: **build-2** (commit 7f0faff, Flutter 3.47.7 / Dart 3.13.5), APK 51 MB fat (3 ABIs) in pre-release `build-2`. NOT device-tested, NOT merged.
- Rollback tags: `baseline-react-prototype` -> b428a8d

## This session (2026-11-01) — session 2: Stage 1 scaffold
- Changed (and why): read owner msg 3 (MVP narrowed to 5 screens; photos -> Storage = Phase 2); read ONLY the reference workflow; created Flutter project `mullky` (SDK-only deps so the first build is attributable), CI workflow with pinned Flutter 3.47.7 and applicationId guard (`com.mullky`), README rewritten, .agent updated (BRIEF has all three owner texts verbatim).
- Verified — and HOW: local sanity (bracket balance, YAML, no token in repo); fonts converted + glyph coverage (fontTools); **CI green build-2**: flutter analyze (0 errors/warnings), 16/16 tests (12 logic + 4 widget), release APK built; **artifact inspected**: APK manifest has package `com.mullky`, label MulkCare, INTERNET; 3 Tajawal TTFs + 4 images bundled; toolchain Flutter 3.47.7.
- NOT verified: anything on a real device (launch, Arabic shaping/RTL look vs DESIGN.md, touch targets, scrolling, bottom sheet with keyboard, whether the debug-key APK installs on the owner's 2019 Android phone); widget tests ran WITHOUT the real font (Ahem fallback), so text widths in tests are not real.
- Corrections of earlier wrong claims: none. (Assumption flagged: `workflow_dispatch` on a branch needs the file on the default branch, so the workflow also triggers on push to `feature/**`.)

## Needs owner device test (not verifiable in CI)
1. After a green build: install the APK from Releases (pre-release `build-<n>`): login (any email + 6 chars; `admin@x.com` = admin), open a unit, send a request, check Arabic/RTL look vs DESIGN.md.

## Open items / next (priority order)
1. (done) first green build = build-2.
2. Owner device test of the Stage 1 APK (look, RTL, Arabic text, flow).
3. Consider `--split-per-abi` (APK 51 MB -> ~19 MB per ABI) once the owner confirms the phone's ABI (probably arm64-v8a).
4. Stage 2a: Supabase Auth + schema/RLS (SQL kept in repo, no secrets; anon key via CI secret / --dart-define).
5. Stage 2b: SQLite cache + sync behind the existing AppState methods.
6. Stage 2c: local photo attach (image_picker) if owner confirms (DECISIONS).

## Build log
1 · 9f95356 · RED — widget test RenderFlex overflow (admin sheet invoice row); analyze OK, 15/16 tests OK
2 · 7f0faff · GREEN — fix with Wrap; analyze + 16 tests + APK (51 MB, fat). Not device-tested
