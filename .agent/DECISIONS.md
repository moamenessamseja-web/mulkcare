# DECISIONS.md — owner decisions, frozen items, open questions

One source of truth for "what must not change without the owner". Date every line; quote the owner when possible.

## Decided
- 2026-11-01 — Target: Flutter Android app (APK), built CI-only via GitHub Actions; Supabase (Auth + Postgres + Storage + RLS); offline-first SQLite cache with sync. (Brief)
- 2026-11-01 — Same design system, "DO NOT redesign": DESIGN.md is normative (Primary #084A6F, Secondary #00A3A3, Accent #F4B400, Tajawal, Arabic RTL default, phone-first). (Brief)
- 2026-11-01 — MVP = auth, home/property list, property detail with history, service request with before/after photos + status workflow, simple invoices (no online payment), in-app admin via is_admin flag (no separate website). (Brief)
- 2026-11-01 — Work on branch `feature/flutter-migration`; reference pattern: manager-assistant-ready @ d2a17efe. (Task prompt)

## Frozen / out of scope until the owner says so
- Phase 2 (do NOT build): local city guide (/local), AI assistant (/assistant), subscriptions/payments, push delivery, PDF export, maps/places, workers/technicians management, industrial clients, English UI.
- Owner gates: never merge to main; never change application id, signing, or Play config; no secrets (service-role key, AI keys) in repo or client.
- Report honestly: CI green != works on device; state what was NOT verified. Update .agent/ after every green build.

## Open decisions (need the owner; give evidence + the 1-2 smallest options)
- Pages not named in KEEP/CUT: Profile, Notifications (in-app list vs. push delivery), NotFound. Smallest options: (a) Profile = minimal sign-out/role screen, Notifications cut entirely for MVP; (b) keep an in-app status-change list only. Engineer default if no answer: (a).
- Application id for the Flutter app: owner has not given one. Needed before first APK is considered final; for CI scaffolding a placeholder is required — owner decision, will not be changed later without say-so.
