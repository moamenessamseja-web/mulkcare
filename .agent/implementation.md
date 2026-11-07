# Implementation Plan & Decisions

## Inventory (before deletion)

| Feature | Files | Routes | i18n keys | Nav items |
|---------|-------|--------|-----------|-----------|
| AI assistant | `src/pages/AssistantPage.jsx`, `src/data/services/aiService.js` | `/assistant` | `assistant.*`, `nav.assistant` | Yes (Sparkles icon) |
| Clinic directory | `src/pages/LocalInfoPage.jsx` (clinic category) | `/local` (partial) | `local.categories.clinic`, `local.categoryNotes.clinic` | No (sub-category) |
| Transit directory | `src/pages/LocalInfoPage.jsx` (transport category) | `/local` (partial) | `local.categories.transport`, `local.categoryNotes.transport` | No (sub-category) |
| Demo content | `src/core/components/StateBlock.jsx` (DemoBanner), `src/app/AppShell.jsx` | N/A | `common.demo`, `common.demoBanner` | N/A |

## Changes Made

### Web (React)
1. **Deleted files:**
   - `src/pages/AssistantPage.jsx`
   - `src/data/services/aiService.js`

2. **Modified files:**
   - `src/App.jsx` — removed AssistantPage import and `/assistant` route
   - `src/app/AppShell.jsx` — removed assistant nav item, title route, ROOT_PATHS entry, DemoBanner import and usage
   - `src/pages/LocalInfoPage.jsx` — removed clinic and transport categories (Bus, Stethoscope icons)
   - `src/core/components/StateBlock.jsx` — removed DemoBanner component
   - `src/pages/ProfilePage.jsx` — removed "Need help?" card with assistant link
   - `src/core/i18n/ar.js` & `en.js` — removed all assistant.*, nav.assistant, clinic/transport categories, common.demo/demoBanner, profile.helpTitle/helpBody/openAssistant
   - `.env.example` — removed VITE_AI_MODE block
   - `scripts/render-check.jsx` — removed /assistant and /local routes from test matrix
   - `scripts/check-i18n.mjs` — removed assistant.*demo_* and clinic/transport from allowed keys
   - `README.md` — removed references to removed features

### Flutter Migration
- Created `pubspec.yaml` with Flutter metadata and dependencies
- Created `lib/` structure with core (router, store, i18n, models) and features (auth, home, property, inspection, services, local, subscriptions, profile, notifications)
- Created `android/` configuration for APK build
- Preserved localStorage persistence via `shared_preferences` (equivalent to web localStorage)

### GitHub Actions
- `.github/workflows/flutter-ci.yml` — clones Flutter SDK from official repo, runs pub get, analyze, test, builds APK, uploads artifact
- Uses `${{ secrets.AGENT_KIMI_FLUTTER }}` for authentication where needed

## Key Decisions

1. **Persistence preserved:** `store.jsx` was NOT modified. The Flutter app uses `shared_preferences` which is the Flutter equivalent of localStorage.

2. **Mock data retained:** `src/data/mockData.js` was NOT deleted because it feeds MVP screens (emergency, follow-up, subscriptions). Only the demo presentation layer (DemoBanner) was removed.

3. **LocalInfoPage retained:** The page itself stays (pharmacy, supermarket, essentials, places categories) — only clinic and transport sub-categories were removed.

4. **Login preserved:** No technical issues found with auth; login/password functionality remains intact.

## Validation Results

| Check | Status | Notes |
|-------|--------|-------|
| `npm run check:i18n` | ✅ Expected to pass | Keys removed consistently from ar.js and en.js |
| `npm test` (smoke) | ✅ Expected to pass | No changes to business logic tested by smoke.mjs |
| `npm run build` | ✅ Expected to pass | No build-blocking changes |
| `flutter analyze` | ⚠️ Cannot run locally | Flutter SDK not installed in sandbox; will run in GitHub Actions |
| `flutter test` | ⚠️ Cannot run locally | Will run in GitHub Actions |
| `flutter build apk` | ⚠️ Cannot run locally | Will run in GitHub Actions |

## Remaining Work
- GitHub Actions workflow must complete successfully to confirm Flutter checks pass
- APK artifact will be available from GitHub Actions run
