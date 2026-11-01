# IMPLEMENTATION_STATE.md — current checkpoint (2026-11-01)

Older detail lives in `archive/`. Rules: `ENGINEERING_RULES.md`. Per-feature statuses: `implementation.md`.

## Baselines and branches
- Default branch `main`: `b428a8d` ("Initial commit: MulkCare") — React/Vite prototype, tag `baseline-react-prototype`. Never device-tested as an app. DO NOT MERGE into main without owner's say-so.
- Working branch: `feature/flutter-migration` — Flutter project pushed; first CI run in progress/pending (no green build yet).
- Rollback tags: `baseline-react-prototype` -> b428a8d

## This session (2026-11-01) — session 2: Stage 1 scaffold
- Changed (and why): read owner msg 3 (MVP narrowed to 5 screens; photos -> Storage = Phase 2); read ONLY the reference workflow; created Flutter project `mullky` (SDK-only deps so the first build is attributable), CI workflow with pinned Flutter 3.47.7 and applicationId guard (`com.mullky`), README rewritten, .agent updated (BRIEF has all three owner texts verbatim).
- Verified — and HOW: local sanity only (`dart_sanity.py` bracket balance, YAML parse of workflow + pubspec, grep: no token in repo). Fonts converted and glyph coverage checked with fontTools.
- NOT verified: EVERYTHING compile-related — Dart written blind, no analyzer/test/build run yet; Arabic text shaping/RTL on device; photo-less request flow acceptance by owner.
- Corrections of earlier wrong claims: none. (Assumption flagged: `workflow_dispatch` on a branch needs the file on the default branch, so the workflow also triggers on push to `feature/**`.)

## Needs owner device test (not verifiable in CI)
1. After a green build: install the APK from Releases (pre-release `build-<n>`): login (any email + 6 chars; `admin@x.com` = admin), open a unit, send a request, check Arabic/RTL look vs DESIGN.md.

## Open items / next (priority order)
1. Get the first CI run green (read the failure log if red, fix root cause).
2. Owner device test of the Stage 1 APK (look, RTL, Arabic text, flow).
3. Stage 2a: Supabase Auth + schema/RLS (SQL kept in repo, no secrets; anon key via CI secret / --dart-define).
4. Stage 2b: SQLite cache + sync behind the existing AppState methods.
5. Stage 2c: local photo attach (image_picker) if owner confirms (DECISIONS).

## Build log
(no builds yet)
