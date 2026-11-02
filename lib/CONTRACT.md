# Contract for Flutter screens

All screens are separate widgets under `lib/screens/`. Each screen uses `AppState.of(context)` and may import `lib/data/models.dart`, `lib/core/widgets.dart`, `lib/core/format.dart`, `lib/design/tokens.dart` and `lib/design/theme.dart`. Keep page widgets in their assigned file. Do not define duplicate models, translations, demo data, app shell or state.

## Required widget names

`AuthScreen`, `HomeScreen`, `PropertyDetailsScreen(propertyId: ...)`, `InspectionReportScreen(reportId: ...)`, `ServicesScreen`, `LocalInfoScreen`, `AssistantScreen`, `SubscriptionsScreen`, `ProfileScreen`, `NotificationsScreen`, and `NotFoundScreen`.

The signed-in route layer wraps each content page in `AppShell`, so page widgets should normally return a scrollable page body, not another `Scaffold` or `DemoBanner`. `AuthScreen` is standalone.

## `AppState` API

- Locale: `language` (`ar` or `en`), `isRtl`, `tr(key, values: {...})`, `text(LocalizedText)`, `setLanguage(language)`.
- Data: `user`, `properties`, `plans`, `serviceRequests`, `inspectionReports`, `subscriptions`, `invoices`, `notifications`, `upcomingVisits`, `notificationPreferences`, `unreadCount`, `openRequests`.
- Lookup helpers: `propertyById(id)`, `reportById(id)`, `planById(id)`, `requestsFor(propertyId)`, `invoicesFor(propertyId)`, `reportsFor(propertyId)`.
- Demo actions: `signIn(identity:, password:)` and `register(name:, identity:, password:)` return a translation key or null; `signOut()`; `updateProfile(name:, email:, phone:)` returns a translation key or null; `createServiceRequest(propertyId:, category:, description:, preferredDate:, preferredTime:, imagePaths:)` returns a translation key or null; `transitionRequest(id, nextStatus)` returns bool; `requestSubscription(planId)`; `requestLocalRecommendation(category)`; `markNotificationRead(id)`; `markAllNotificationsRead()`; `setNotificationPreference(key, enabled)`; `assistantReply(input)`.
- The legal transitions are `AppState.legalTransitions`; offer only actions allowed by `state.canTransition(from, to)`.

## Model fields

- `LocalizedText(ar, en)`.
- `PropertyModel`: `id`, `ownerId`, `name`, `location`, `propertyType`, `bedrooms`, `areaSqm`, `status`, `planId`, `images`.
- `ServiceRequestModel`: `id`, `reference`, `propertyId`, `ownerId`, `category`, `description`, `images`, `status`, `preferredDate`, `preferredTime`, `estimatedCost`, `finalCost`, `createdAt`, `updates`.
- `RequestUpdate`: `at`, `text`; `InspectionReportModel`: `id`, `reference`, `propertyId`, `inspectorName`, `inspectionDate`, `score`, `overallLabel`, `summary`, `checklist`, `notes`, `images`, `issuePhotos`, `recommendations`, `estimatedCostTotal`.
- `ChecklistGroupModel`: `category`, `items`; `ChecklistItemModel`: `id`, `label`, `result`; `IssuePhotoModel`: `id`, `caption`, `before`, nullable `after`; `RecommendationModel`: `id`, `label`, `estimatedCost`.
- `PlanModel`: `id`, `nameKey`, `monthlyPrice`, `featureKeys`; `SubscriptionModel`: `id`, `propertyId`, `planId`, `status`, `startDate`, nullable `renewalDate`; `InvoiceModel`: `id`, `propertyId`, `description`, `amount`, `status`, `createdAt`; `VisitModel`: `id`, `propertyId`, `date`, `type`, `note`.
- `NotificationModel`: `id`, `title`, `body`, `read`, `createdAt`, `href`; `UserModel`: `id`, `fullName`, `email`, `phone`, `role`.

## Shared widgets and assets

Available helpers in `lib/core/widgets.dart`: `SurfaceCard`, `SectionHeading`, `DemoBanner`, `InlineNotice` with `NoticeTone`, `EmptyState`, `StatusChip(status:, translationPrefix:)`, `LocalAssetImage`, and `MoneyText(amount:)`. Format helpers are `formatMoney`, `formatDate`, `formatTime`, and `formatRelative` in `lib/core/format.dart`.

Local images: `auth_hurghada_terrace.jpg`, `property_villa_pool.jpg`, `property_apartment_sea.jpg`, `property_chalet_interior.jpg`, `inspection_clipboard.jpg`, `service_maintenance_ac.jpg`, `service_cleaning_prep.jpg`, `marina_dusk.jpg`.

## Truth constraints

All data and login are demo/sample. No page may imply real authentication, live AI, live recommendations/maps, online payment, push delivery, remote photo upload, or generated PDF. Show the source disclaimers and preserve the eleven route screens listed in `src/App.jsx`.