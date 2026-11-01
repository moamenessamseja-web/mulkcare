# implementation.md — inventory of what exists (honest statuses)

Statuses (use ONLY these, never promote without evidence): **Verified complete** · **Implemented, not yet verified** · **Partially implemented** ·
**Not started** · **Blocked** · **Deferred by product decision**.
Evidence levels: *read* < *sanity* < *CI* < *artifact inspected* < *owner's device*. "Verified complete" needs the owner's device for anything user-facing.

## 1. MVP (5 screens) — Stage 1 = UI + logic on in-memory sample data
| Item | Status | Notes |
|---|---|---|
| Login / register screen | Implemented, not yet verified | DEMO auth only (any email + 6-char password; `admin@…` = admin). NOT Supabase Auth. CI green build-2; not device-tested |
| Home: units list (villa/chalet, photo, vacant/rented) | Implemented, not yet verified | 3 sample units, local asset photos |
| Unit detail: request history + invoices | Implemented, not yet verified | in-memory data |
| Service request (type + notes -> pending) | Implemented, not yet verified | **No photos yet** |
| Status workflow pending -> in progress -> done | Implemented, not yet verified | admin-only change (unit-tested logic) |
| Invoices (amount, paid/unpaid, no online payment) | Implemented, not yet verified | admin adds + toggles paid |
| In-app admin (all requests, filter, status, invoice) | Implemented, not yet verified | role = demo `admin@` email until Supabase `is_admin` |
| Design system (colors, type, radii, Tajawal TTF, RTL) | Implemented, not yet verified | from DESIGN.md tokens; fonts converted woff2 -> TTF (merged Arabic+Latin) |
| CI: analyze + test + APK, Flutter pinned 3.47.7, appId guard | Implemented, not yet verified | build-2 green (artifact inspected: com.mullky, label, INTERNET, fonts, images); red build-1 = overflow, fixed |
| Photos before/after (local pick) | Not started | needs image_picker; owner confirmation pending (see DECISIONS) |
| Supabase Auth + Postgres + RLS | Not started | Stage 2 |
| Offline SQLite cache + sync | Not started | Stage 2 |
| Real is_admin role from Supabase | Not started | Stage 2 |

## 2. Deferred by product decision
| Item | Status | Notes |
|---|---|---|
| Photo upload to Supabase Storage | Deferred by product decision | Phase 2 (owner msg 3) |
| AI assistant, subscriptions | Deferred by product decision | Phase 2 |
| Local city guide | Deferred by product decision | Phase 3 |
| Website/dashboard, custom API/server, city DB, workers/industrial/multi-client, online payment, push, PDF, maps, English UI | Deferred by product decision | cut |

## 3. Legacy
| Item | Status | Notes |
|---|---|---|
| React/Vite code in `src/`, `public/`, `package.json` | Deferred by product decision | kept only as reference; owner decides when to delete |

## Verification log
| Build | Commit | CI | Device |
|---|---|---|---|
| build-1 | 9f95356 | RED (widget overflow) | - |
| build-2 | 7f0faff | GREEN: analyze + 16 tests + APK | not tested |
