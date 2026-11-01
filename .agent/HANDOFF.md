# HANDOFF.md — 60-second start

1. Read `README.md` → `ENGINEERING_RULES.md` → `IMPLEMENTATION_STATE.md`.
2. **Test target now:** **build-2** = commit 7f0faff on `feature/flutter-migration` (pre-release `build-2` in GitHub Releases; CI green; NOT device-tested). Baseline = tag `baseline-react-prototype` (b428a8d). Last owner-confirmed: none. Distrust: `debug-1`/commit 9f95356 (red, fixed).
3. Owner's task list: (1) .agent bootstrap — done; (2) Flutter Stage 1 (5 screens, sample data) — done, CI green; (3) green APK — done (build-2); (4) README rewrite — done; (5) Supabase + SQLite — Not started.
4. Do not: merge to main · change application id/signing/Play config · commit any secret (incl. GitHub token, Supabase service-role key) · redesign (DESIGN.md is normative) · build Phase 2 items (see DECISIONS.md) · claim device behavior from CI.
5. Environment: CI-only (GitHub Actions); token only via transient `http.extraheader`, never in URL/file/commit. The owner pasted a classic PAT in chat on 2026-11-01 -> owner should revoke it after the session.
