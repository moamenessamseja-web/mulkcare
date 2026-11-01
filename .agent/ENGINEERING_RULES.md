# ENGINEERING_RULES.md — how to work on MulkCare (read before coding)

Audience: any engineer or AI agent. The owner may not be a programmer: explain results in plain language, never claim what was not verified,
do not ask for routine technical decisions (decide, then report), do ask for product/identity/irreversible ones.

## 1. Definition of done — UI-only vs a real feature
A screen that looks right is NOT a feature. A feature is done only if ALL are true:
1. **Persisted** through the project's storage layer and survives restart (a test re-initialises storage and re-reads).
2. **Consumed**: something reads it (a list, a scheduler, a report). A record nobody reads is UI-only.
3. **Same pipeline for every entry point** (UI, chat, import…): they write the same records. No parallel store "for the UI".
4. **Visible** where the owner looks (lists/dashboards that should show it).
5. **Real effect** (notification really scheduled, request really sent) — assert on a fake of the platform seam, not on a status string.
6. **Honest errors**: failures are visible states; never "success" for something that did not happen.
7. **Tested**: pure-logic unit tests + a flow/widget test + a restart-persistence test; CI green.
8. **Verification level stated** (CI-green ≠ device-verified).

## 2. Reuse map — do not duplicate
| Need | Use (file) |
|---|---|
| (no Flutter code yet) | add entries as models/services/screens are created |
Before adding a model/service/screen: grep for an existing one. Extend before creating.

## 3. Stack facts (verified, with dates) — Flutter/Android (CI-only) + Supabase
- 2026-11-01 — NOT yet determined (no Flutter project exists, no CI run yet). To fill after the first CI run: pinned Flutter/Dart version, `android/` generated-or-committed decision, permissions (camera/photo picker), what CI injects.
- Environment: no Flutter/Dart SDK in sandbox; GitHub Actions is the only compiler. Reference pattern: `moamenessamseja-web/manager-assistant-ready` commit d2a17efe (**not yet inspected this session**).
- Design authority: `/DESIGN.md` (Primary #084A6F, Secondary #00A3A3, Accent #F4B400, Tajawal self-hosted, Arabic RTL default, phone-first). Never alter colours/type/layout direction/component shape.

## 4. Data / storage rules
- Planned (owner brief): Supabase (Auth + Postgres + Storage + RLS) as source of truth; local SQLite cache with sync (offline-first). Not implemented yet.
- Secrets: Supabase service-role key and any AI keys must never be in the repo or the client. Only the public anon URL/key may be supplied at build time (via CI secrets / --dart-define), never committed.
- Schema evolution additive only. Entities documented in `/README.md` ("Entities", "Moving to Supabase") — currently the React README; to be rewritten for Flutter.

## 5. Testing and regression
- How verification works here (local SDK? CI only? where do logs live?).
- Known test gotchas (write each as: symptom → cause → what to do). Add to `LESSONS.md` first, promote here when general.
- Every bug fixed gets a regression test. Never weaken or delete an old test to get green.
- Pre-push checklist: imports used · no name clashes · tests for the change · docs updated.

## 6. Process
- Start gate: read `README.md`, `IMPLEMENTATION_STATE.md`, `HANDOFF.md`; inspect git + latest CI; trust code over docs and fix the docs.
- Work on a branch; the default branch gets only what the owner has tested; never force-push; tag anchors before risky merges.
- After every green build update: STATE, `implementation.md`, CHANGELOG, HANDOFF. Archive, never delete.
- Final report: plain language · what changed · verified (level) · needs device test · deliberately not done · decisions needed.
- Secrets: use tokens only via transient headers; never write to files/remotes/logs; tell the owner to revoke.

## 7. Owner-frozen / out of scope
(see `DECISIONS.md` — keep the list there, one source of truth)
