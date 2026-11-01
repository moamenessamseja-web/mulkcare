# LESSONS.md — symptom → real cause → what to do (evidence-based)

Add an entry after every red build, surprise, or owner correction. Promote general lessons to `ENGINEERING_RULES.md`.
If a lesson is useful beyond this project, tell the owner it should go into the shared skill.

## L1. Web prototype fonts (woff2) cannot be used by Flutter on Android
- Cause found: Flutter's font loader accepts TTF/OTF/TTC only; the Accio export ships `tajawal-{arabic,latin}-{400,500,700}.woff2` (read: Flutter docs knowledge + `public/fonts` listing; not device-proven either way).
- What to do next time: convert with fontTools (+brotli), merge Arabic and Latin subsets per weight into one TTF so one family covers both scripts (done: 398 glyphs, م/A/1 present).
- Test/guard added: pubspec declares the TTF assets, so `flutter build` fails if a font file is missing; visual correctness of Arabic shaping is NOT verified until the owner opens the app.

## L2. CI red build #1: RenderFlex overflowed by 10px in the admin request sheet (widget test failed; analyze + 15/16 tests passed)
- Cause found: `Row` with fixed-width children (paid chip + text button) inside a 350px sheet. In `flutter test` the Tajawal font is not loaded, so text renders in the wide Ahem test font, which exposed (and exaggerates) a layout that depends on text width (CI log `debug-1`, admin_screen.dart:191). Whether it overflowed on a real device with Tajawal is unknown.
- What to do next time: use `Wrap`/`Expanded`/`Flexible` for rows that mix chips and buttons; never assume text widths.
- Test/guard added: same widget test (admin flow) now passes through that sheet; it fails on any future overflow.
