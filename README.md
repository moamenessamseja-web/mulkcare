# MulkCare — Your Holiday Home, Our Care

Flutter Android app for vacation-home owners in Hurghada, Egypt. The Arabic RTL / English LTR interface and screen content follow `DESIGN.md`; the original React/Vite code remains under `src/` as the behavioral reference. The current app uses clearly labeled sample data only.

## Screens

| Route | Screen |
|---|---|
| `/auth` | Demo sign-in and registration |
| `/` | Dashboard: properties, requests, visits, and inspections |
| `/property/:propertyId` | Property facts, gallery, plan, and history |
| `/inspection/:reportId` | Inspection score, checklist, photos, and recommendations |
| `/services` | Local demo request form and status tracking |
| `/local` | Hurghada guide with an explicit no-live-source state |
| `/assistant` | Prewritten demo assistant responses; no live AI |
| `/subscriptions` | Sample plans and local plan requests; no payment |
| `/profile` | Profile, language, notification preferences, and invoices |
| `/notifications` | In-app notification center |
| unknown route | Designed Not Found screen |

## APK via GitHub Actions

The project is built **only in GitHub Actions** on `feature/flutter-migration-complete` using the pinned Flutter `3.47.7` toolchain. The workflow generates Android platform scaffolding in the runner, runs `flutter analyze`, `flutter test`, and `flutter build apk --release`, then uploads an APK artifact. It also uploads the resolved `pubspec.lock` as a separate artifact so the exact dependency graph can be committed and used for the final repeat build.

Open **GitHub → Actions → Build MulkCare APK**, select the successful run, then download `MulkCare-APK-<run>`. No GitHub Release or Play publication is created. Package ID is `com.mullky`; the APK uses Flutter's default debug signing and is not Play-ready. CI success is not evidence of a physical-device test.

## Design, demo data, and limitations

`DESIGN.md` is normative: Tajawal, the original color system, spacing, and phone-first layout. Eight local images and the original Arabic/English dictionaries are bundled with the app.

The local demo bundle contains three properties, six service requests, two inspection reports, three subscriptions, three invoices, four notifications, and two visits. Sign in with `owner@mulkcare.demo` and a password of at least six characters. Passwords are not stored.

There is no backend, real account service, cloud photo upload, live AI, live map/directory provider, online checkout, push delivery, or generated PDF. Service photos stay local; plan requests are local demo actions. Proposed prices are sample values, not verified market prices.

## Project structure

`lib/screens/` contains one Dart file for each of the eleven original routes. `lib/state/` and `lib/data/` provide local state and models; `lib/core/` contains translation, formatting, and shared widgets; `lib/design/` implements the design tokens; `assets/` contains fonts, imagery, and dictionaries. `.agent/` records the implementation plan, state, handoff, architecture, and verification evidence.