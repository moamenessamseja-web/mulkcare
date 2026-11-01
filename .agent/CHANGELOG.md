# Changelog (completed work only — never plans)

## 2026-11-01
- docs: bootstrap `.agent/` on `feature/flutter-migration` (baseline b428a8d); BRIEF.md = verbatim owner brief + task prompt · no CI (docs only) · not device-tested.
- feat: Flutter project `mullky` (appId com.mullky): theme from DESIGN.md, Tajawal TTF, Arabic RTL, 5 screens on in-memory sample data, demo auth, admin role, invoices, unit+widget tests; CI workflow (Flutter 3.47.7, analyze/test/APK, appId guard); README rewritten for Flutter (old one -> docs/legacy-web-README.md). Branch `feature/flutter-migration`. CI result: see build log below. Not device-tested.
- Red builds: #1 (9f95356) — widget test overflow in admin sheet invoice row (analyze OK, 15/16 tests OK). Fixed with Wrap in 7f0faff.
- build-2 (7f0faff) GREEN — analyze + 16 tests + release APK (51 MB fat APK); APK inspected: package com.mullky, label MulkCare, INTERNET, Tajawal TTFs, 4 images · not device-tested.
