# DECISIONS.md — owner decisions, frozen items, open questions

One source of truth for "what must not change without the owner". Date every line; quote the owner when possible.

## Decided
- 2026-11-01 — Target: Flutter Android app (APK), built CI-only via GitHub Actions; Supabase (Auth + Postgres + Storage + RLS); offline-first SQLite cache with sync. (Brief)
- 2026-11-01 — Same design system, "DO NOT redesign": DESIGN.md is normative (Primary #084A6F, Secondary #00A3A3, Accent #F4B400, Tajawal, Arabic RTL default, phone-first). (Brief)
- 2026-11-01 — MVP = auth, home/property list, property detail with history, service request with before/after photos + status workflow, simple invoices (no online payment), in-app admin via is_admin flag (no separate website). (Brief)
- 2026-11-01 — Work on branch `feature/flutter-migration`; reference pattern: manager-assistant-ready @ d2a17efe. (Task prompt)

- 2026-11-01 — MVP narrowed to 5 screens (login, home/units, unit detail, service request, in-app admin). Core loop: client -> unit -> request -> photos -> status -> invoice. (Owner msg 3)
- 2026-11-01 — Application id: owner said "ال ID mullky" -> implemented as `com.mullky` (flutter create --org com --project-name mullky). Guarded in CI. (Owner msg 4)
- 2026-11-01 — Flutter pinned to 3.47.7 stable (the version of manager-assistant-ready build #81, green and device-confirmed there). Bump only deliberately with a device test. (Owner: "ثبت flutter")
- 2026-11-01 — `android/` is generated in CI (`flutter create`) and never committed; CI injects INTERNET permission and the app label. (Pattern from reference workflow)
- 2026-11-01 — Only the needed parts of manager-assistant-ready were read (workflow + file list), per owner. (Owner msg 3)

## Frozen / out of scope until the owner says so
- Phase 2 (do NOT build): local city guide (/local), AI assistant (/assistant), subscriptions/payments, push delivery, PDF export, maps/places, workers/technicians management, industrial clients, English UI.
- Phase 2 (owner msg 3): AI assistant + subscriptions. Phase 3: local city guide. Cut now: website/dashboard, hand-written API/server, city database, workers/industrial/multi-client depth, online payment (invoice = paid/unpaid only). Supabase Storage upload of photos = Phase 2.
- Owner gates: never merge to main; never change application id, signing, or Play config; no secrets (service-role key, AI keys) in repo or client.
- Report honestly: CI green != works on device; state what was NOT verified. Update .agent/ after every green build.

## Open decisions (need the owner; give evidence + the 1-2 smallest options)
- Pages not named in KEEP/CUT: Profile, Notifications (in-app list vs. push delivery), NotFound. Smallest options: (a) Profile = minimal sign-out/role screen, Notifications cut entirely for MVP; (b) keep an in-app status-change list only. Engineer default if no answer: (a).
- Application id exact form: owner wrote "mullky"; Android needs >= 2 segments, so I used `com.mullky`. Smallest options: (a) keep `com.mullky`; (b) another form such as `com.mullky.app`. Cheap to change now, impossible after a Play release. Default: (a) until told.
- Photos in the MVP: my reading is local-only capture/attach now, Supabase Storage upload in Phase 2. Smallest options: (a) local photos in MVP (default); (b) no photos at all until Phase 2.
- App display name on the phone: I set "MulkCare" (from DESIGN.md). If the product is now called Mullky, say so.
