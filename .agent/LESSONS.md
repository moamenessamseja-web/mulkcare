# LESSONS.md — symptom → real cause → what to do (evidence-based)

Add an entry after every red build, surprise, or owner correction. Promote general lessons to `ENGINEERING_RULES.md`.
If a lesson is useful beyond this project, tell the owner it should go into the shared skill.

## L1. Web prototype fonts (woff2) cannot be used by Flutter on Android
- Cause found: Flutter's font loader accepts TTF/OTF/TTC only; the Accio export ships `tajawal-{arabic,latin}-{400,500,700}.woff2` (read: Flutter docs knowledge + `public/fonts` listing; not device-proven either way).
- What to do next time: convert with fontTools (+brotli), merge Arabic and Latin subsets per weight into one TTF so one family covers both scripts (done: 398 glyphs, م/A/1 present).
- Test/guard added: pubspec declares the TTF assets, so `flutter build` fails if a font file is missing; visual correctness of Arabic shaping is NOT verified until the owner opens the app.
