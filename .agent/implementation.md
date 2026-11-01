# implementation.md — inventory of what exists (honest statuses)

Statuses (use ONLY these, never promote without evidence): **Verified complete** · **Implemented, not yet verified** · **Partially implemented** ·
**Not started** · **Blocked** · **Deferred by product decision**.
Evidence levels: *read* < *sanity* < *CI* < *artifact inspected* < *owner's device*. "Verified complete" needs the owner's device for anything user-facing.

## 1. MVP (KEEP, per BRIEF.md)
| Item | Status | Notes |
|---|---|---|
| Auth (sign in / register, Supabase) | Not started | web: `AuthPage.jsx` (demo sign-in only) |
| Home: property list (villa/chalet, photo, vacant/rented) | Not started | web: `HomePage.jsx` |
| Property detail: history of requests + photos + invoices | Not started | web: `PropertyDetailsPage.jsx`, `InspectionReportPage.jsx` (mapping to be confirmed) |
| Service request (type, notes, before/after photos, status pending->in-progress->done) | Not started | web: `ServicesPage.jsx` |
| Invoices (amount, paid/unpaid, no online payment) | Not started | |
| In-app admin (is_admin): all requests, change status, add invoice | Not started | no separate dashboard |
| Offline-first SQLite cache + sync | Not started | |
| Supabase schema + RLS + Storage | Not started | |
| CI: analyze + test + APK, pinned Flutter | Not started | |

## 2. Deferred by product decision (Phase 2 — do NOT build)
| Item | Status | Notes |
|---|---|---|
| Local city guide | Deferred by product decision | web: `LocalInfoPage.jsx` |
| AI assistant | Deferred by product decision | web: `AssistantPage.jsx` |
| Subscriptions/payments | Deferred by product decision | web: `SubscriptionsPage.jsx` |
| Push notification delivery | Deferred by product decision | `NotificationsPage.jsx` fate to be confirmed |
| PDF export, maps/places, workers mgmt, industrial clients, English UI | Deferred by product decision | |

## 3. Unclassified web pages (need a decision, see DECISIONS.md)
| Item | Status | Notes |
|---|---|---|
| `ProfilePage.jsx`, `NotificationsPage.jsx`, `NotFoundPage.jsx` | Not started | not named in BRIEF KEEP/CUT lists |

## Verification log
| Build | Commit | CI | Device |
|---|---|---|---|
