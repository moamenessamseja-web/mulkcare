# HANDOFF.md — 60-second start

1. Read `README.md` → `ENGINEERING_RULES.md` → `IMPLEMENTATION_STATE.md`.
2. **Test target now:** nothing buildable yet. Branch `feature/flutter-migration` (docs only so far). Baseline = tag `baseline-react-prototype` (b428a8d). Last owner-confirmed: none. Distrust: none yet.
3. Owner's task list: (1) .agent bootstrap — DONE; (2) Flutter scaffold + MVP — Not started; (3) CI green APK — Not started; (4) README rewrite — Not started.
4. Do not: merge to main · change application id/signing/Play config · commit any secret (incl. GitHub token, Supabase service-role key) · redesign (DESIGN.md is normative) · build Phase 2 items (see DECISIONS.md) · claim device behavior from CI.
5. Environment: CI-only (GitHub Actions); token only via transient `http.extraheader`, never in URL/file/commit. The owner pasted a classic PAT in chat on 2026-11-01 -> owner should revoke it after the session.
