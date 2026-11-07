# MulkCare — Your Holiday Home, Our Care

A bilingual (Arabic RTL / English LTR) property-care app for vacation-home owners
in Hurghada, Egypt who live abroad or in another city.

Owners follow their properties, request services, read photo inspection reports,
review expenses and talk to the MulkCare team.

> **This build runs on sample data.** Every screen that renders data shows a
> never presents sample data as real. See [Data & backend](#data--backend).

---

## Screens

| # | Route | Screen |
|---|---|---|
| 1 | `/auth` | تسجيل الدخول / إنشاء حساب — sign in, registration, language switcher |
| 2 | `/` | الصفحة الرئيسية — dashboard: property strip, quick actions, requests, visits, reports |
| 3 | `/property/:propertyId` | تفاصيل العقار — cover, gallery, facts, subscription, history, expenses |
| 4 | `/inspection/:reportId` | تقرير الفحص — condition score, 6-category checklist, notes, photos, recommendations |
| 5 | `/services` | الخدمات والصيانة — request form + request tracking with status workflow |
| 6 | `/local` | المواصلات والدليل المحلي — Hurghada guide with search and honest no-source state |
| 8 | `/subscriptions` | الباقات والاشتراكات — Basic / Premium plans, no payment UI |
| 9 | `/profile` | الملف الشخصي — edit profile, language, notification prefs, invoices, logout |

Plus `/notifications` (reached from the app-bar bell) and a designed not-found route.

---

## Stack

- **React 18** + **Vite 5**
- **React Router 6** (`BrowserRouter`, declarative routes)
- **Tailwind CSS 3** (build pipeline) + hand-written component CSS driven by design tokens
- **lucide-react** for monoline icons
- Plain React **Context** for state (session, data bundle, toasts, language)
- No UI kit, no chart library, no i18n library — all three are small and local

### Architecture

```
src/
  app/            store.jsx (session + data + mutations), AppShell.jsx (app bar / bottom nav)
  core/
    components/   Button, Field, StatusChip, Dialog, PhotoSlot, PropertyCard, StateBlock, Toast, Logo
    i18n/         ar.js, en.js, index.jsx (provider, `t()`, `pick()`)
    errors.js     typed AppError + stable error codes
    env.js        safe `import.meta.env` access
    format.js     currency / date / time / relative-time formatters
  data/
    mockData.js         the sample data set (clearly labelled)
    services/           authService, aiService
  pages/          one file per screen
  styles.css      design tokens (from DESIGN.md) + component styles
scripts/          smoke.mjs, check-i18n.mjs, resolve hooks
```

UI → `repository` → adapter → source. The UI never imports `mockData` directly,
so swapping the data source is a one-line env change.

---

## Run it

```bash
npm install          # or: pnpm install
npm run dev          # dev server
npm run build        # production build into dist/
npm run preview      # serve the production build
npm test             # business-logic smoke tests (21 checks)
npm run check:i18n   # asserts both dictionaries are complete and in sync
```

### Extra verification (optional)

`scripts/render-check.jsx` renders every route in both languages with the sample
data pre-seeded, to catch crashes in a screen's render path. It needs a JSX-aware
bundler, so it is not wired into `npm test`:

```bash
npx esbuild scripts/render-check.jsx --bundle --platform=node --format=cjs \
  --jsx=automatic --outfile=.render-check.cjs
node .render-check.cjs   # 32/32 routes rendered without error
```

It is a render check only — it says nothing about layout, colour or interaction.



```
password: any 6+ characters
```

Passwords are never stored, never logged and never transmitted — they exist only
inside the call that validates them. The sign-in screen states this in-app.

---

## Design system

`DESIGN.md` is the normative source for tokens (colours, type scale, radii,
spacing, component specs). Every value is applied through CSS custom properties
in `src/styles.css`, so nothing in the components hard-codes a colour or size.

- Primary `#084A6F`, secondary `#00A3A3`, accent `#F4B400`, canvas `#F5F7FA`, ink `#1E293B`
- Tajawal, **self-hosted** from `public/fonts/` (`@font-face` + `font-display: swap`).
  No font CDN and no CSS `@import` are used at runtime.
- Phone-first (390×844); tablet centres the column; desktop presents the app in a
  framed phone surface on a branded wash.
- Arabic is the default; the whole layout is authored with logical CSS properties,
  so switching to English is a direction flip, not a second layout.
- Status is always **icon + label + colour**, never colour alone.

---

## Data & backend

### What is real today

| Concern | Status |
|---|---|
| Screens, routing, navigation, RTL/LTR | working |
| Form validation, error states, loading skeletons, empty states | working |
| Profile editing, notification prefs, language switching | working (session-scoped) |
| Persistence | browser `localStorage` (session + data snapshot) |
| Image upload | file picker previews locally; **nothing is uploaded** |
| Payments | none, by design |

### Selecting a data source

Copy `.env.example` to `.env.local` and set:

```bash
VITE_API_BASE_URL=      # required only for remote modes
```

Until a backend is configured, `remote` modes fail fast with `NOT_CONFIGURED`
rather than pretending to succeed.

### REST contract the UI expects

```
GET    /api/v1/me/bundle
PATCH  /api/v1/me
POST   /api/v1/properties/:propertyId/service-requests
PATCH  /api/v1/service-requests/:id
POST   /api/v1/subscriptions
PATCH  /api/v1/notifications/:id
PATCH  /api/v1/notifications/read-all
```

### Entities

`User`, `Property`, `ServiceRequest`, `InspectionReport`, `Subscription`,
`Invoice`, `Notification`, `Plan` — field shapes are defined by the sample data in
`src/data/mockData.js` and by the types documented in `src/data/repositories/index.js`.

### Moving to Supabase

Supabase (Auth + Postgres + Storage + RLS) fits this architecture directly.

1. `npm i @supabase/supabase-js`, add `SUPABASE_URL` and `SUPABASE_ANON_KEY` as
   **public** env values.
   and select it with `VITE_DATA_SOURCE=supabase`.
3. Create the tables above with `owner_id uuid references auth.users` on every
   owned row.
4. **Enable Row Level Security on every table** and add policies of the form
   `auth.uid() = owner_id` for select/insert/update/delete. Without RLS an anon
   key exposes every row.
5. Storage: one private bucket, with a policy that restricts read/write to the
   owner's own folder path.
6. Auth: point `authService` at `supabase.auth.signInWithPassword` /
   `signUp` and return the same session shape.

> **Never** put `SUPABASE_SERVICE_ROLE_KEY` (or any AI provider key) in this
> client bundle — anything shipped here is readable by the user. Provider keys
> belong on a server route; `src/data/services/aiService.js` documents the
> server endpoint it expects instead.

### What still needs configuring

- A backend for real accounts, data and image storage
- A maps/places provider for `/local` (today it shows an honest "no live source" state)
- PDF export for inspection reports (the share action currently reports that it is not configured)
- Push notifications (alert preferences are stored but nothing is delivered yet)

---

## Sample data

`src/data/mockData.js` holds 3 properties, 6 service requests across every
status, 2 inspection reports, 3 subscriptions, 3 invoices, 4 notifications and
stale. All imagery is generated concept imagery — not photographs of real
properties, staff or clients. Plan prices (EGP 999 / 1,999) are **proposed test
prices** and are labelled as such in the UI.

## Assets

See `ASSETS.md` for the image manifest, sources and verification notes.
