# ASSETS.md — MulkCare Image Manifest

Source of truth for every media resource the runtime is allowed to reference.

Photographic images are migrated to the platform CDN at publish time; the
publisher rewrites their runtime references to the CDN URLs listed below.
Non-photographic assets (fonts, favicon, placeholder) are served from
root-absolute local paths, never with a `public/` prefix and never relatively.

## Generation record

- Provider: `imageGenerate` (AI image generation tool).
- Images generated for this build request: **8** (ceiling 8, no additional
  approval requested).
- All 8 generated images are used in the rendered UI. No unused generated asset.
- No stock-library or web-searched imagery was used.
- No user-provided imagery was supplied for this build (the owner's brand sheet
  was supplied at the end of the conversation but is a UI mockup, not a photo
  asset, and is not reproduced here).
- Concept-imagery disclosure: the property and service photographs are
  **staged concept imagery**, not photographs of real MulkCare properties,
  real staff or real clients. Sample properties are labelled as sample data in
  the running app.

## Image Manifest

| # | Runtime path | Source | Role / intended usage | Status |
|---|---|---|---|---|
| 1 | `https://sc04.alicdn.com/kf/S7f882818ac584851b94acbc98c5e6aecz.jpg` | imageGenerate | Full-bleed photographic backdrop behind the `/auth` bottom sheet | ready · 1024×1536 · 260 KB |
| 2 | `https://sc04.alicdn.com/kf/Sd7c437dfd3eb46fabe290a06ccc99d4dJ.jpg` | imageGenerate | Sample property "Villa" cover — dashboard strip, `/property/:id` cover, gallery | ready · 1536×1024 · 329 KB |
| 3 | `https://sc04.alicdn.com/kf/Sea3224f5749f46b4bae0bf87a351951e9.jpg` | imageGenerate | Sample property "Apartment" cover — dashboard strip, `/property/:id` cover, gallery | ready · 1536×1024 · 223 KB |
| 4 | `https://sc04.alicdn.com/kf/Se48a7846b7aa4611b5fafd6eb07e589a4.jpg` | imageGenerate | Sample property "Chalet" cover — dashboard strip, `/property/:id` cover, gallery | ready · 1536×1024 · 222 KB |
| 5 | `https://sc04.alicdn.com/kf/S270377e5a2394c92af34452a2d625d93I.jpg` | imageGenerate | Inspection context photo — `/inspection/:id` header + `/property/:id` last-inspection row | ready · 1536×1024 · 90 KB |
| 6 | `https://sc04.alicdn.com/kf/S3de3719c54dd40daa17da98050deabdai.jpg` | imageGenerate | Service category tile / request row thumbnail (maintenance, HVAC, plumbing, electrical) | ready · 1536×1024 · 202 KB |
| 7 | `https://sc04.alicdn.com/kf/Sdb79242006e14059b3fa1f191345feaal.jpg` | imageGenerate | Service category tile / request row thumbnail (cleaning, pest control, pre-arrival prep) | ready · 1536×1024 · 144 KB |
| 8 | `https://sc04.alicdn.com/kf/S949981e93ddf4a8590045a3aea02ed14B.jpg` | imageGenerate | Wide header band on `/subscriptions` and `/profile` | ready · 1536×1024 · 144 KB |

## Non-photographic assets

| Runtime path | Source | Role | Status |
|---|---|---|---|
| `/assets/images/placeholder.svg` | bundled template placeholder | Honest fallback for any image slot whose file is missing | ready |
| `/favicon.svg` | hand-authored SVG (same mark as `src/core/components/Logo.jsx`) | Browser tab icon | ready |
| `/fonts/tajawal-arabic-{400,500,700}.woff2` | self-hosted (fontsource build of Tajawal) | Arabic subset, weights 400/500/700 | ready |
| `/fonts/tajawal-latin-{400,500,700}.woff2` | self-hosted (fontsource build of Tajawal) | Latin subset, weights 400/500/700 | ready |

Font note: Tajawal is self-hosted under `public/fonts/` and declared with
`@font-face` + `font-display: swap`. No font CDN and no CSS `@import` is used at
runtime. Total added bundle weight ≈ 57 KB (six subset files).

## Verification

- Every photo URL above was checked on the live site: HTTP 200, `image/jpeg`,
  byte size matching the generated file exactly.
- The published bundle was checked to reference all 8 CDN URLs.
- Fonts and the favicon were checked on the live site: HTTP 200 with the
  expected `font/woff2` and `image/svg+xml` content types.
- No arbitrary external image URL appears in source.
- No image is referenced by filename inside `DESIGN.md`.
