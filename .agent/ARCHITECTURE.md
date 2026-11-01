# ARCHITECTURE.md — how it works NOW (not history)

Status 2026-11-01: **no Flutter code exists yet.** Only the legacy React/Vite prototype is in the repo (`src/`, baseline tag `baseline-react-prototype`).

## Target (from BRIEF.md, not yet built)
- Flutter Android app, Arabic RTL, theme taken from `/DESIGN.md` verbatim.
- Supabase: Auth, Postgres (RLS), Storage for photos. Admin = `is_admin` flag in the same app.
- Local SQLite cache + sync (offline-first).
- CI: GitHub Actions -> analyze + test + build APK, Flutter version pinned.

To be filled as each piece is implemented and verified.
