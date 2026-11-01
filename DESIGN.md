---
version: alpha
name: MulkCare
description: >-
  Design tokens for MulkCare — "Your Holiday Home, Our Care." A bilingual,
  Arabic-first (RTL, with English LTR as a full alternate) property-care app
  for vacation-home owners in Hurghada, Egypt. Coastal-Egyptian premium: deep
  sea blue, lagoon teal and sun gold on a pale sea-mist canvas, built
  phone-first around a 390x844 viewport.
colors:
  primary: "#084A6F"
  primary-strong: "#063A55"
  primary-tint: "#E4EEF4"
  secondary: "#00A3A3"
  secondary-strong: "#0A6E75"
  secondary-tint: "#DFF3F3"
  accent: "#F4B400"
  accent-strong: "#8A6400"
  accent-tint: "#FDF1D4"
  background: "#F5F7FA"
  surface: "#FFFFFF"
  surface-muted: "#EDF1F6"
  elevated: "#FFFFFF"
  surface-inverse: "#072F47"
  border: "#E2E8F0"
  border-strong: "#CBD5E1"
  text: "#1E293B"
  on-surface-muted: "#55657A"
  on-brand: "#FFFFFF"
  on-inverse: "#FFFFFF"
  disabled-surface: "#E9EEF3"
  disabled-text: "#98A4B3"
  success: "#157347"
  success-tint: "#E6F4EC"
  warning: "#9A5B00"
  warning-tint: "#FBEEDA"
  danger: "#B3261E"
  danger-tint: "#FBE9E7"
  focus-ring: "#00A3A3"
  scrim: "rgba(8, 74, 111, 0.55)"
  chart-1: "#084A6F"
  chart-2: "#00A3A3"
  chart-3: "#F4B400"
  chart-4: "#D07A4E"
  chart-5: "#6B7A8F"
  chart-gridline: "#E6EBF1"
  chart-track: "#EDF1F6"
  chart-empty: "#E9EEF3"
typography:
  display:
    fontFamily: Tajawal
    fontSize: 32px
    fontWeight: 700
    lineHeight: 1.35
    letterSpacing: 0px
  h1:
    fontFamily: Tajawal
    fontSize: 26px
    fontWeight: 700
    lineHeight: 1.4
    letterSpacing: 0px
  h2:
    fontFamily: Tajawal
    fontSize: 22px
    fontWeight: 700
    lineHeight: 1.45
    letterSpacing: 0px
  h3:
    fontFamily: Tajawal
    fontSize: 18px
    fontWeight: 500
    lineHeight: 1.5
    letterSpacing: 0px
  body:
    fontFamily: Tajawal
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.8
    letterSpacing: 0px
  label:
    fontFamily: Tajawal
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.6
    letterSpacing: 0px
  caption:
    fontFamily: Tajawal
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.7
    letterSpacing: 0px
rounded:
  xs: 6px
  sm: 10px
  md: 14px
  lg: 18px
  xl: 24px
  full: 9999px
spacing:
  xxs: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  3xl: 64px
  gutter: 16px
  screen: 20px
  app-bar: 56px
  bottom-nav: 64px
  action-row: 72px
  phone-width: 390px
  app-column-max: 480px
  tablet-column: 720px
  desktop-max: 1280px
  touch-min: 44px
  hairline: 1px
components:
  app-bar:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.h3}"
    height: "{spacing.app-bar}"
    padding: "{spacing.sm}"
  app-bar-icon-button:
    backgroundColor: "{colors.surface-muted}"
    textColor: "{colors.primary}"
    size: "{spacing.touch-min}"
    rounded: "{rounded.full}"
  notification-dot:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.on-brand}"
    size: 10px
    rounded: "{rounded.full}"
  bottom-nav:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-muted}"
    height: "{spacing.bottom-nav}"
    typography: "{typography.caption}"
  bottom-nav-item:
    textColor: "{colors.on-surface-muted}"
    typography: "{typography.caption}"
    height: "{spacing.touch-min}"
    width: 64px
    padding: "{spacing.xxs}"
  bottom-nav-item-active:
    backgroundColor: "{colors.primary-tint}"
    textColor: "{colors.primary}"
    typography: "{typography.caption}"
    rounded: "{rounded.full}"
  sticky-action-row:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    height: "{spacing.action-row}"
    padding: "{spacing.md}"
  sheet:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    width: "{spacing.phone-width}"
    rounded: "{rounded.xl}"
    padding: "{spacing.lg}"
  dialog:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    width: 320px
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-brand}"
    typography: "{typography.label}"
    height: "{spacing.touch-min}"
    rounded: "{rounded.md}"
    padding: 14px
  button-primary-pressed:
    backgroundColor: "{colors.primary-strong}"
    textColor: "{colors.on-brand}"
  button-primary-disabled:
    backgroundColor: "{colors.disabled-surface}"
    textColor: "{colors.disabled-text}"
  button-primary-loading:
    backgroundColor: "{colors.primary-strong}"
    textColor: "{colors.on-brand}"
    size: 20px
  button-secondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.label}"
    height: "{spacing.touch-min}"
    rounded: "{rounded.md}"
    padding: 14px
  button-link:
    backgroundColor: "transparent"
    textColor: "{colors.secondary-strong}"
    typography: "{typography.label}"
    height: "{spacing.touch-min}"
  button-destructive:
    backgroundColor: "{colors.danger-tint}"
    textColor: "{colors.danger}"
    typography: "{typography.label}"
    height: "{spacing.touch-min}"
    rounded: "{rounded.md}"
    padding: 14px
  icon-button:
    backgroundColor: "{colors.surface-muted}"
    textColor: "{colors.primary}"
    size: "{spacing.touch-min}"
    rounded: "{rounded.full}"
  fab-send:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-brand}"
    size: "{spacing.touch-min}"
    rounded: "{rounded.full}"
  card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    rounded: "{rounded.lg}"
    padding: "{spacing.md}"
  card-title:
    textColor: "{colors.text}"
    typography: "{typography.h3}"
  property-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    width: 264px
    rounded: "{rounded.lg}"
    padding: "{spacing.sm}"
  quick-action-tile:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.label}"
    height: 104px
    rounded: "{rounded.lg}"
    padding: "{spacing.md}"
  list-row:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    height: 72px
    padding: "{spacing.md}"
  timeline-row:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    height: 64px
    padding: "{spacing.md}"
  status-chip:
    typography: "{typography.caption}"
    height: 28px
    rounded: "{rounded.full}"
    padding: 6px
  status-chip-pending:
    backgroundColor: "{colors.surface-muted}"
    textColor: "{colors.on-surface-muted}"
  status-chip-awaiting:
    backgroundColor: "{colors.warning-tint}"
    textColor: "{colors.warning}"
  status-chip-approved:
    backgroundColor: "{colors.secondary-tint}"
    textColor: "{colors.secondary-strong}"
  status-chip-scheduled:
    backgroundColor: "{colors.primary-tint}"
    textColor: "{colors.primary}"
  status-chip-in-progress:
    backgroundColor: "{colors.accent-tint}"
    textColor: "{colors.accent-strong}"
  status-chip-completed:
    backgroundColor: "{colors.success-tint}"
    textColor: "{colors.success}"
  status-chip-cancelled:
    backgroundColor: "{colors.danger-tint}"
    textColor: "{colors.danger}"
  inspection-result-ok:
    backgroundColor: "{colors.success-tint}"
    textColor: "{colors.success}"
    typography: "{typography.caption}"
    rounded: "{rounded.xs}"
  inspection-result-followup:
    backgroundColor: "{colors.warning-tint}"
    textColor: "{colors.warning}"
    typography: "{typography.caption}"
    rounded: "{rounded.xs}"
  inspection-result-repair:
    backgroundColor: "{colors.danger-tint}"
    textColor: "{colors.danger}"
    typography: "{typography.caption}"
    rounded: "{rounded.xs}"
  input-field:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    height: 52px
    rounded: "{rounded.sm}"
    padding: 14px
  input-field-focused:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
  input-field-error:
    backgroundColor: "{colors.danger-tint}"
    textColor: "{colors.text}"
  input-label:
    textColor: "{colors.text}"
    typography: "{typography.label}"
  helper-text:
    textColor: "{colors.on-surface-muted}"
    typography: "{typography.caption}"
  error-text:
    textColor: "{colors.danger}"
    typography: "{typography.caption}"
  textarea-field:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    height: 120px
    rounded: "{rounded.sm}"
    padding: 14px
  select-field:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    height: 52px
    rounded: "{rounded.sm}"
    padding: 14px
  photo-slot:
    backgroundColor: "{colors.surface-muted}"
    textColor: "{colors.on-surface-muted}"
    size: 88px
    rounded: "{rounded.md}"
  filter-chip:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.caption}"
    height: 40px
    rounded: "{rounded.full}"
    padding: 10px
  filter-chip-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-brand}"
  tab:
    backgroundColor: "transparent"
    textColor: "{colors.on-surface-muted}"
    typography: "{typography.label}"
    height: "{spacing.touch-min}"
  tab-active:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    height: "{spacing.touch-min}"
  banner-demo:
    backgroundColor: "{colors.accent-tint}"
    textColor: "{colors.accent-strong}"
    typography: "{typography.caption}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm}"
  banner-error:
    backgroundColor: "{colors.danger-tint}"
    textColor: "{colors.danger}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "{spacing.md}"
  banner-unsaved:
    backgroundColor: "{colors.primary-tint}"
    textColor: "{colors.primary}"
    typography: "{typography.label}"
    rounded: "{rounded.sm}"
    padding: "{spacing.md}"
  toast:
    backgroundColor: "{colors.surface-inverse}"
    textColor: "{colors.on-inverse}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm}"
  empty-state:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-muted}"
    typography: "{typography.body}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
  skeleton:
    backgroundColor: "{colors.surface-muted}"
    height: 16px
    rounded: "{rounded.sm}"
  metric-value:
    textColor: "{colors.text}"
    typography: "{typography.h1}"
  progress-track:
    backgroundColor: "{colors.chart-track}"
    height: 8px
    rounded: "{rounded.full}"
  progress-fill:
    backgroundColor: "{colors.secondary}"
    height: 8px
    rounded: "{rounded.full}"
  chart-area-fill:
    backgroundColor: "{colors.primary-tint}"
    height: 120px
    rounded: "{rounded.sm}"
  chart-empty-state:
    backgroundColor: "{colors.chart-empty}"
    textColor: "{colors.on-surface-muted}"
    height: 160px
    rounded: "{rounded.md}"
  chat-bubble-user:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-brand}"
    typography: "{typography.body}"
    rounded: "{rounded.lg}"
    padding: "{spacing.sm}"
  chat-bubble-assistant:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    rounded: "{rounded.lg}"
    padding: "{spacing.sm}"
  chat-message-failed:
    backgroundColor: "{colors.danger-tint}"
    textColor: "{colors.danger}"
    typography: "{typography.caption}"
    rounded: "{rounded.sm}"
    padding: "{spacing.xs}"
  demo-badge:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.text}"
    typography: "{typography.caption}"
    height: 24px
    rounded: "{rounded.full}"
    padding: "4px"
  price-note:
    backgroundColor: "transparent"
    textColor: "{colors.on-surface-muted}"
    typography: "{typography.caption}"
  map-placeholder:
    backgroundColor: "{colors.surface-muted}"
    textColor: "{colors.on-surface-muted}"
    height: 200px
    rounded: "{rounded.lg}"
---

# MulkCare — "Your Holiday Home, Our Care."

## Overview

MulkCare is the pocket concierge for an owner who is far away. Its audience is
**vacation-home owners in Hurghada, Egypt** who live abroad or in another city
and who cannot walk past their own front door. They open the app to answer four
anxious questions in order: *Is my property alright? What is happening there
now? What did it cost me? Who do I talk to?* The interface exists to answer
those four questions calmly, in one thumb, in Arabic first.

This is an **app, not a marketing website**. There is no hero, no pricing
ladder, no "learn more" page. The first viewport is the signed-in home
dashboard: a greeting with the owner's name, the notification bell, and the
horizontally scrollable strip of property cards — the owner's actual houses,
photographed, named, located and chipped with a live status. Before sign-in,
the first viewport is the full-bleed coastal-property photograph with a bottom
sheet card carrying the logo, the language switcher and the single primary
"تسجيل الدخول" button.

The mood is **calm, coastal and administratively precise** — the feeling of a
well-run building-management desk that happens to live in your pocket. Deep sea
blue carries structure and authority; lagoon teal marks living, interactive
state; sun gold is reserved for attention (badges, KPI emphasis, the demo
badge) and is never used as a large surface. Nothing is playful, nothing is
gamified, nothing shouts. Whitespace is generous, cards are white on sea-mist,
borders are one hairline pixel, and shadows are so quiet they read as light
rather than depth.

The product is **bilingual by construction**: Arabic (RTL) is the default and
English (LTR) is a full alternate, switchable from `/auth`, `/profile` and the
settings list. Every layout decision in this system is written in logical
(spacing, not left/right) terms so the mirrored build is a direction flip, not
a redesign. Latin digits (0–9) are used for dates, prices, request numbers and
phone numbers in both locales.

**Key characteristics**

- Deep-sea-blue structure, lagoon-teal interaction, one gold attention accent.
- Bilingual Arabic-first: logical spacing, mirrored chevrons, mirrored sheet
  and drawer edges, Arabic-tuned line heights, never a Latin type rhythm.
- A phone-first app shell — 56px contextual app bar, scrolling content, 64px
  five-destination bottom navigation — reused at every breakpoint.
- White cards with 1px `border` hairlines on a `background` canvas; elevation is
  tonal first and shadow second.
- Status is always icon + label + colour, never colour alone.
- Every data surface ships loading, empty, error, populated, edge, plus the
  global sample-data banner, because v1 runs on sample data only.

## Colors

The palette is a Hurghada morning: deep water, lagoon, sunlight on pale sand,
and a slate ink for text that never goes pure black.

- **Primary — deep sea blue (`#084A6F`)**: the structural colour. App bar
  titles, primary buttons, the active bottom-nav destination, the cover scrim
  on the auth screen, scheduled-state chips, and the first chart series. White
  on primary measures **9.5:1**.
- **Secondary — lagoon teal (`#00A3A3`)**: the interactive colour. Active
  states, focus rings, sliders, progress fills, chart series 2, and the ring
  around the send button. As a *text* colour on white it only reaches 3.1:1, so
  teal text is always the darker **secondary-strong (`#0A6E75`, 6.0:1 on
  white)**; `secondary` itself is used for fills, strokes and large/bold text
  and icons only.
- **Accent — sun gold (`#F4B400`)**: attention, used in small doses. Rating
  stars, KPI emphasis numbers, badge fills, and the demo-mode badge. Gold is
  never a text colour on light surfaces; use **accent-strong (`#8A6400`,
  4.8:1 on accent-tint)** for gold-toned text.
- **Neutral canvas**: `background` sea-mist (`#F5F7FA`) is the page;
  `surface` (`#FFFFFF`) is every card, sheet, list row and input;
  `surface-muted` (`#EDF1F6`) is the recessed tier behind photo slots,
  skeletons, chip grounds and inactive icon buttons; `elevated` (`#FFFFFF`) is
  the same white as `surface` but paired with the raised shadow below;
  `surface-inverse` (`#072F47`) is reserved for toasts and chart tooltips.
- **Ink (`#1E293B`)** carries body text (13.6:1 on the canvas), headings and
  numeric values. **on-surface-muted (`#55657A`)** carries captions, helper
  text, timestamps and inactive navigation (5.5:1 on the canvas, 5.2:1 on
  `surface-muted`). Nothing lighter than `#55657A` may carry text.
- **State colours** are always used as *tint ground + strong text* pairs, which
  is what keeps them accessible: `success` on `success-tint` 5.2:1, `warning`
  on `warning-tint` 4.7:1, `danger` on `danger-tint` 5.6:1, `primary` on
  `primary-tint` 8.0:1, `secondary-strong` on `secondary-tint` 5.2:1.
- **Categorical chart ramp**: `chart-1` deep sea → `chart-2` lagoon →
  `chart-3` sun → `chart-4` terracotta → `chart-5` slate blue. Series are read
  left-to-right in the chart itself and are never mirrored in RTL (chart axes
  stay mathematical). `chart-gridline` lines the plot, `chart-track` is the
  unfilled part of every progress ring/bar, `chart-empty` fills the frame when
  a chart has no data yet.
- **Scrim** `rgba(8, 74, 111, 0.55)` is the single photographic overlay, used
  behind the auth bottom sheet and behind pushed-screen modal sheets. It is
  always deep-sea-tinted, never neutral black, so photography stays coastal.
- **Focus ring** `#00A3A3` at 2px with a 2px surface-coloured offset: 3.1:1
  against white and 3.05:1 against primary buttons, so one ring token is
  legible on both light and brand-filled controls.

### Design Tokens

The `colors` block in the front matter is normative for every value above.

## Typography

MulkCare is set in one family: **Tajawal**, self-hosted at runtime (no font
CDN, no CSS `@import` from a font host; a local `@font-face` stack only, with
`system-ui` and Arabic-capable sans fallbacks). One family at three weights —
400, 500, 700 — keeps the Arabic and Latin builds visually identical in
character.

| Level | Size | Weight | Line height | Used for |
|---|---|---|---|---|
| display | 32px | 700 | 1.35 | KPI emphasis numbers, the inspection overall-condition score, plan name on `/subscriptions` |
| h1 | 26px | 700 | 1.4 | Screen title on pushed screens (property name, report title) |
| h2 | 22px | 700 | 1.45 | Section headings ("أحدث طلبات الخدمة", "نتائج الفحص") |
| h3 | 18px | 500 | 1.5 | Card titles, property names, list-row titles, app-bar contextual title |
| body | 16px | 400 | 1.8 | Paragraphs, checklist item labels, chat bubbles, descriptions |
| label | 14px | 500 | 1.6 | Buttons, form labels, nav labels, chips with longer text, table headers |
| caption | 13px | 400 | 1.7 | Timestamps, request numbers, helper text, chip text, chart axis labels |

**Arabic-first rules**

- Body line height is **1.8** and label/caption stay at 1.6–1.7 — harakat and
  descenders need the clearance that a Latin 1.4 rhythm does not give.
- **No letter-spacing anywhere** (`letterSpacing: 0px` on every level, including
  display) and **no uppercase transforms** — tracking breaks Arabic cursive
  joining and caps do not exist in the script.
- **No italics** and no synthetic bolding: use the 700 weight, and only for
  Arabic-safe emphasis (never a faux-bold `text-shadow`).
- Weight never drops below 400 for running text; 13px `caption` is the floor,
  used only for metadata — never for a label the user must read to act.
- Numerals are Latin in both locales, always wrapped with `dir="ltr"` inside
  Arabic runs (prices `1,250 ج.م`, dates `12 أكتوبر 2026`, request numbers
  `#MC-10432`, `20:30`). Use `font-variant-numeric: tabular-nums` on cost
  columns, inspection cost rows and KPI values so digits align across rows.
- Latin-script runs inside Arabic sentences (a technician's name, "Wi-Fi")
  are isolated with `<bdi>` rather than left to bidi reflow.

### Design Tokens

The `typography` block in the front matter is normative; `fontFamily: Tajawal`
is bound to all seven levels.

## Layout

MulkCare uses an **App Column** model rather than a marketing grid. The
canonical frame is a **390×844 phone**: `screen` (20px) horizontal padding, a
56px app bar, a scrolling content area, a 64px bottom navigation bar, and — on
detail screens — a 72px sticky action row that floats directly above the
bottom navigation. Content never touches the edges; the app bar and bottom bar
own the full bleed.

- **Phone (canonical, 390px).** Single column. Card gutters are 16px (`gutter`),
  screen padding is 20px (`screen`). The dashboard's property strip scrolls
  horizontally with 264px cards and 12px gaps, bleeding past the screen padding
  so the next card is visibly clipped — the owner sees there is more.
- **Tablet (≥768px).** The app column is centred at a max of 480px on
  `background`, and list-heavy screens (`/services` tracking list, `/local`
  place list, `/profile` settings groups, inspection checklist) may widen to
  two columns inside a 720px container. The bottom navigation stays the primary
  navigation at this width and remains centred under the app column.
- **Desktop (≥1280px).** The app is presented as a **framed phone surface**:
  a 390px-wide, `rounded.xl` device frame with the raised shadow, floating on a
  branded backdrop (a soft vertical wash from `primary-tint` to `background`,
  never a gradient stop parade, never glassmorphism). On `/` and
  `/inspection/:id` only, the frame may be accompanied by a second 1-up column
  of the same cards — a wider two-column reading of the dashboard and the
  report — while the frame itself keeps the bottom navigation visible. Bottom
  navigation is never replaced by a desktop sidebar or a top tab bar.
- **Safe areas.** The app bar and sticky action row respect the top and bottom
  safe-area insets; the bottom nav sits above the home indicator with its own
  `xs` padding.
- **Logical spacing everywhere.** All horizontal padding, gaps, icon placement
  and sheet edges are authored with logical properties (`padding-inline`,
  `margin-inline-start`, `inset-inline-end`, `border-inline-start`) and
  `text-align: start`. Screen padding is symmetric, so AR/EN mirroring is a
  direction flip with no layout edits. The one asymmetric element — the app
  bar's back chevron on the inline-start side — mirrors automatically because
  it is positioned logically.
- **Spacing scale.** `xxs` 4 / `xs` 8 / `sm` 12 / `md` 16 / `lg` 24 / `xl` 32 /
  `2xl` 48. Spacing is deliberately *not* uniform: an individual card interior
  uses `sm`–`md`, a card grid gap uses `md`, a section break on the dashboard
  uses `lg`, and a report block break (`نتائج الفحص` vs `التوصيات المقترحة`)
  uses `xl` — density where information belongs together, air where it must
  separate. Repeated "card → 24px → card → 24px" rhythm is a defect.
- **Touch targets.** Every interactive element is at least **44×44 CSS px**
  (`touch-min`): bottom-nav destinations are 64px wide, icon buttons are 44px
  circles, list rows are 72px tall, filter chips are 40px tall with 8px of
  vertical rhythm around them, and inline "التفاصيل" links inside body text sit
  in a 44px-tall row. Where a visible control is smaller (a status chip), it is
  not interactive.

### Design Tokens

The `spacing` block in the front matter is normative, including the shell
heights (`app-bar`, `bottom-nav`, `action-row`), the frame widths
(`phone-width`, `app-column-max`, `tablet-column`, `desktop-max`) and
`touch-min`.

## Elevation & Depth

Depth is **tonal first, shadow second**. The canvas is sea-mist
(`background` `#F5F7FA`); everything the owner reads or acts on sits on pure
white `surface`; recessed material (photo slots, skeletons, inactive icon
buttons, map placeholder, chart empty frames) drops to `surface-muted`
(`#EDF1F6`). Every card, sheet, row and input is outlined with a single
`1px` hairline in `border` (`#E2E8F0`); `border-strong` (`#CBD5E1`) is only for
the focused input edge and for dividers inside an already-bordered card.

| Level | Treatment | Used for |
|---|---|---|
| 0 — flat | no shadow, hairline `border` only | cards, list rows, quick-action tiles, property cards, checklist rows |
| 1 — raised | `0 1px 2px rgba(8, 42, 64, 0.05), 0 8px 20px -12px rgba(8, 42, 64, 0.14)` | the sticky property action row, the desktop phone frame, the auth bottom sheet, pinned section headers |
| 2 — floating | `0 2px 4px rgba(8, 42, 64, 0.06), 0 16px 32px -16px rgba(8, 42, 64, 0.20)` | dialogs (logout confirmation, delete-photo), dropdowns, map picker panel |
| scrim | `{colors.scrim}` (`rgba(8, 74, 111, 0.55)`) | behind the auth photo backdrop, and behind modal sheets |
| focus | `0 0 0 2px {colors.surface}, 0 0 0 4px {colors.focus-ring}` | keyboard focus on any control (see Components) |

Shadows are tinted with the primary hue (deep sea) rather than neutral black, so
elevation reads as sea light instead of grey soot. They are always low-spread
and soft — no hard rims, no inner shadows, no drop shadow on any card at rest.
**Glassmorphism, blurred translucent panels and stacked background blurs are
not part of this system**; the only translucency is the photographic scrim, and
even it is a flat overlay, not a blur.

## Shapes

The radius hierarchy is deliberate, not one value applied everywhere:

| Token | Value | Applied to |
|---|---|---|
| `rounded.xs` | 6px | inspection result markers (`سليم` / `يحتاج متابعة` / `يحتاج إصلاح` legend swatches), tiny inline tags, chart legend keys |
| `rounded.sm` | 10px | text inputs, selects, textareas, demo and error banners, skeletons, chart tooltips, thumbnails in the property photo strip |
| `rounded.md` | 14px | buttons, photo-attach slots, tab segments, toasts, map placeholder cards |
| `rounded.lg` | 18px | **the workhorse** — every content card, quick-action tile, property card, list container, dialog, inspection category group, chat bubble |
| `rounded.xl` | 24px | bottom sheets (auth card, request-detail sheet, filter sheet), media hero frames on `/property/:id` and `/inspection/:id`, the desktop phone frame |
| `rounded.full` | 9999px | status chips, filter chips, avatars, icon buttons, progress tracks/fills, the notification dot, the demo badge, the active bottom-nav pill |

Small controls are never rounded more than their container: an input inside a
sheet is `sm` inside `xl`, a chip inside a card is `full` inside `lg`. Pills are
reserved for genuinely rounded-things (chips, avatars, icon buttons, progress)
and never for cards or media — a card must not read as a pill, and a media hero
must not read as a tile. Where an Arabic RTL run sits in a rounded container,
corner radii are authored logically (`border-start-start-radius`) so a right-side
"first" corner is the right-side corner in RTL.

## Components

**App shell.** The app bar is 56px, `surface`, hairline-bottomed, containing a
contextual title in `h3` centred or start-aligned, an optional 44px circular
back button on the inline-start (the chevron mirrors in RTL), and a 44px
circular notification button on the inline-end carrying a 10px `danger`
`notification-dot` positioned at its top-inline-end corner. The bottom
navigation is 64px, `surface`, hairline-topped, with five equal destinations —
الرئيسية / الخدمات / المساعد / الدليل المحلي / حسابي — each a 24px monoline icon
above a `caption` label; the active destination takes `primary` text and a
`primary-tint` `full` pill behind the icon, the inactive destinations take
`on-surface-muted`. The active pill is the only brand-coloured fill in the
bottom bar. Secondary screens (`/property/:id`, `/inspection/:id`,
`/subscriptions`, a request detail) are pushed screens that keep the back
affordance and drop nothing else of the shell.

**Buttons.** Primary is `primary` fill with `on-brand` text at `label`, 52px
tall on forms and 44px in rows, `md` radius, pressed state deepens to
`primary-strong`; disabled is `disabled-surface` fill with `disabled-text` and
no shadow; loading keeps the `primary-strong` fill, holds the button's width,
and swaps the label for a 20px teal spinner (`button-primary-loading`) — the
label is never replaced by a spinner while the button resizes. Secondary is a
white button with `primary` text and a `border` hairline. A text-level action
is `button-link` in `secondary-strong` ("نسيت كلمة المرور؟"). Destructive
actions on `/profile` (logout) and in the request sheet use `danger-tint` ground
with `danger` text, never a solid red fill. No button anywhere carries a
payment, checkout or add-to-cart affordance.

**Chips and the status vocabulary.** The full request vocabulary is
قيد الانتظار → بانتظار الموافقة → تمت الموافقة → مجدول → قيد التنفيذ →
مكتمل / ملغي, and each maps to exactly one token: pending =
`status-chip-pending` (neutral), awaiting approval = `status-chip-awaiting`
(amber), approved = `status-chip-approved` (teal), scheduled =
`status-chip-scheduled` (blue), in progress = `status-chip-in-progress` (gold
tint), completed = `status-chip-completed` (green), cancelled =
`status-chip-cancelled` (red). **Every chip renders a small monoline glyph plus
the Arabic label plus the colour** — clock for waiting, hourglass for awaiting,
check for approved, calendar for scheduled, wrench for in progress, check-ring
for completed, slash for cancelled — so the tracking list, the dashboard
"أحدث طلبات الخدمة" list and the request-detail header remain readable in
greyscale, for colour-blind owners, and in a screen reader. The same rule
governs inspection results: `inspection-result-ok` / `inspection-result-followup`
/ `inspection-result-repair` each carry glyph + Arabic label, and the report
legend repeats the triple at the top of the checklist. Property status chips
("مؤجرة", "شاغرة", "تحت الصيانة") follow the same composition. Filter chips
(`/services` categories, `/local` categories) are `full` pills: white with a
`border` hairline when resting, `primary` fill with `on-brand` text when
selected — selection is state, so it uses primary, not accent.

**Cards and lists.** `card` is white, `lg`-radius, hairline-bordered, 16px
padded, with an `h3` title and an optional `caption` meta line. The
`property-card` is 264px wide with a top photo at `md` radius, name in `h3`,
location in `caption` with a small pin glyph, and a status chip in its footer.
`list-row` is 72px, white, hairline-separated, with a leading 40px illustration
or avatar, a `body` title, a `caption` sub-line, and a trailing chevron that
mirrors in RTL; `timeline-row` is the 64px variant used by "الزيارات القادمة",
with a vertical `border` rail and a 12px dot on the inline-start. No card in
this system carries a coloured left/start border accent — status lives in the
chip, never in a stripe on the container edge.

**Forms, inputs and validation.** `input-field`, `select-field` and
`textarea-field` are white, `sm`-radius, 52px (120px for the textarea), with a
1px `border` hairline, `body` text, and the label above in `label` — labels are
always visible, never placeholder-only. Placeholder text is `on-surface-muted`.
Focus moves the border to `border-strong` and adds the teal focus ring. Invalid
fields replace the hairline with `danger` and the field ground with
`danger-tint`, show an `error-text` message with a warning glyph and
`role="alert"`, set `aria-invalid`, and wire the message through
`aria-describedby`. Helper text (`helper-text`, `on-surface-muted`) sits below
until — or beside — the field it explains. Validation fires **on blur**, not on
first keystroke; the message clears the instant the value becomes valid. On
submit failure the form keeps every value, moves focus to the first invalid
field, and shows a `banner-error` summary at the top of the form. Intrinsically
Latin fields — email, phone, password, cost — are forced `dir="ltr"` inside
Arabic screens; free-text fields (description, message, search) use
`dir="auto"`. `/auth`'s password field carries the show/hide toggle as a 44px
inline-end icon button inside the field's logical padding.

**Photo attach slots.** The request form, the profile editor and the
inspection photo grid use `photo-slot`: an 88px `surface-muted` square at `md`
radius, hairline-bordered, with a monoline camera glyph and a `caption`
"إضافة صورة". A filled slot shows the photo with a 44px remove button in its
top-inline-end corner. Slots are labelled for screen readers by position
("صورة 1 من 4"), and the before/after pairing on `/inspection/:id` is rendered
as two labelled slots per issue ("قبل" / "بعد") with the same radius and
spacing, so the pair reads as one unit. Image files are referenced by
implementation, never by name in this document.

**Charts and data display.** Every chart is hand-built with CSS or inline SVG
and uses the chart ramp in order — `chart-1` for the primary series (monthly
expense bars), `chart-2` for the comparison series (services completed),
`chart-3` only for a highlighted/current value, `chart-4` and `chart-5` for
further categories. Gridlines are `chart-gridline` at 1px, axis labels are
`caption` in `on-surface-muted`, unfilled rings and bars are `chart-track`, and
a chart with no data renders `chart-empty-state` with an explanation and a
"لا توجد بيانات بعد" caption rather than an empty frame. Chart axes and
series order are **not mirrored in RTL** — the x-axis stays mathematical. Every
chart needs a text alternative: a `caption` summary line and an accessible
table or `aria-label` carrying the same numbers. KPI emphasis numbers use
`display` and may take `accent` on the value only where the metric is the
screen's single headline figure.

**States for every data surface.** Each list, card grid, form and report
implements five render states plus the global demo banner:

- **Loading** — skeletons (`skeleton`, `surface-muted`, `sm` radius) shaped
  like the content they replace (property card, list row, checklist row, chart
  frame); a spinner only for sub-second inline work; a "يتأخر التحميل أكثر من
  المعتاد…" line after 15 seconds; skeletons are announced with
  `role="status"` and never move focus.
- **Empty** — `empty-state` card: a monoline illustration, a headline in `h3`,
  one sentence of plain explanation, and a primary CTA. First-use empty on `/`
  invites the owner to add their first property; "/services" empty invites a
  first request; "/local" no-results echoes the search term and offers the
  category chips again; a genuinely blank panel is never acceptable.
- **Error** — `banner-error` with what happened, why where knowable, and a
  44px "إعادة المحاولة" button; retries back off at 2s / 4s / 8s, then swap to
  "تواصل مع الدعم" with a copyable error ID and "آخر محاولة قبل X ثانية". User
  input survives every failure.
- **Populated** — the designed case.
- **Edge** — 200-character property names wrap without breaking the card, a
  missing optional field collapses its row instead of leaving a blank label, a
  five-property strip scrolls horizontally, an RTL screen containing LTR
  numbers does not reflow, and a report with 40 checklist items scrolls inside
  its category group without pushing the sticky action row.

**Global sample-data and demo treatment.** Because v1 runs entirely on sample
data, `banner-demo` (gold tint, `accent-strong` text, `sm` radius, small info
glyph) is pinned at the top of the scrolling content on every data screen and
states plainly that the content is sample data. `/assistant` additionally
carries a `demo-badge` in the thread header plus an inline notice that no AI
provider is connected; `/local` renders the honest "لا يوجد مصدر بيانات مباشر
متصل" state instead of inventing pharmacy names, addresses, phone numbers,
routes, opening hours or prices, and its `map-placeholder` is a neutral
`surface-muted` panel with a caption — never a fake map with fake pins.
`/subscriptions` labels both plan prices with `price-note` ("سعر مقترح
للاختبار") and contains **no payment, checkout or transaction UI of any kind**;
the only action is a request to the MulkCare team. The AI assistant's bubbles
(`chat-bubble-user` primary-filled, `chat-bubble-assistant` white with a
hairline), the typing indicator (three `on-surface-muted` dots animating at a
reduced-motion-safe cadence), the `chat-message-failed` retry row, and the four
suggested-question chips all keep the demo badge visible in the same viewport.

**Feedback.** Success confirmations use `toast` on `surface-inverse` with
`role="status"` and do not steal focus; they appear in one fixed position for
the whole app and can be paused on hover/focus. Destructive confirmations
(logout, remove property, cancel a request) use `dialog` with
`role="alertdialog"`, focus moved into the dialog, Escape to dismiss, and the
destructive action styled `button-destructive`. Unsaved-changes warnings use
`banner-unsaved` (`primary-tint` ground, `primary` text) at the top of the form.

**Focus and accessibility.** Nothing in MulkCare removes a focus outline.
Keyboard focus draws the two-ring treatment — a 2px `surface`-coloured gap and
a 2px `focus-ring` ring — on every button, chip, input, row-level link and
bottom-nav destination, with ≥3:1 contrast against both the control and the
canvas. Document language and direction are set on the root
(`dir="rtl" lang="ar"` by default, `dir="ltr" lang="en"` for the English
build), alternate-language subtrees carry both attributes, icon-only buttons
carry `aria-label` in the active language, status chips are announced as
icon + label + state, and chart alt text is provided as described above.
Motion is short (120–180ms) and every transition is disabled under
`prefers-reduced-motion`.

## Do's and Don'ts

- Do keep Arabic (RTL) as the default build and author every offset, edge and
  radius logically — mirroring must be a direction flip, not a second layout.
- Do keep body line height at 1.8 and letter-spacing at 0px; do not import a
  Latin type rhythm onto Arabic text.
- Do use `primary` for structure, `secondary`/`secondary-strong` for
  interaction, and `accent`/`accent-strong` for attention only — never the
  reverse.
- Do pair every status with glyph + Arabic label + colour; never let colour
  alone carry قيد الانتظار / مجدول / مكتمل / ملغي or سليم / يحتاج متابعة /
  يحتاج إصلاح.
- Do keep normal-text contrast at 4.5:1 or better (body ink on canvas is
  13.6:1; muted text is 5.5:1) and every touch target at 44×44 CSS px.
- Do keep one hairline `border` on white cards over the sea-mist canvas, and
  let the tint tiers (`surface-muted`, `chart-empty`) do the recessed work.
- Do surface the sample-data banner on every data screen, and label the plan
  prices as proposed test prices.
- Do mirror directional affordances — back chevrons, list chevrons, sliders,
  non-media progress fills, sheet edges, drawer edges — while leaving clocks,
  refresh spinners, playback controls, photographs and chart axes unmirrored.
- Don't use purple, indigo or any two-stop "trust" gradient; the entire palette
  is the coastal five plus state colours.
- Don't sell, price-transact or check out: no cart, no payment form, no
  "اشترِ الآن" button anywhere, including `/subscriptions`.
- Don't invent local-guide facts — no business names, addresses, phone numbers,
  routes, opening hours or prices — and don't render a fake map with fake pins.
- Don't wrap the whole app in glassmorphism, translucent panels or background
  blurs; the only translucency is the deep-sea photographic scrim.
- Don't apply one radius everywhere or repeat a uniform card-to-card padding —
  use the radius hierarchy and vary density between grouped and separated
  content.
- Don't put a coloured left/start border stripe on a rounded card to signal
  state; that signal belongs in a status chip.
- Don't use solid red fills for destructive actions, gradient-filled buttons,
  emoji as icons, or a text-coloured `secondary`/`accent` that misses 4.5:1.
- Don't load fonts from a CDN or a CSS `@import`; Tajawal is self-hosted, and no
  image file is referenced by name in this system.
