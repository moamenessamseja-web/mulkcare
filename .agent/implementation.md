# جرد التنفيذ — MulkCare Flutter

الحالات: **منفّذ كودًا، لم يتحقق** · **متحقق عبر CI** · **مختبر على جهاز المالك** · **غير مدعوم في المصدر الأصلي**. وجود الملف أو نجاح فحص ساكن لا يرفع الحالة إلى متحقق.

| المطلب | الحالة | الدليل/الملحوظة |
|---|---|---|
| RTL/LTR واللغة العربية/الإنجليزية | منفّذ كودًا، لم يتحقق | ملفات الترجمة 397 مفتاحًا لكل لغة؛ 266 استدعاء Dart حرفيًا متطابقة |
| تسجيل الدخول والتسجيل التجريبي | منفّذ كودًا، لم يتحقق | `auth_screen.dart`, `AppState.signIn/register`; بلا backend |
| لوحة الرئيسية | منفّذ كودًا، لم يتحقق | `home_screen.dart` |
| تفاصيل العقار | منفّذ كودًا، لم يتحقق | `property_details_screen.dart` |
| تقرير الفحص | منفّذ كودًا، لم يتحقق | `inspection_report_screen.dart`; مشاركة PDF تظل غير مهيأة |
| الخدمات وتتبع الحالات | منفّذ كودًا، لم يتحقق | `services_screen.dart`; صور محلية وانتقالات قانونية في AppState |
| دليل محلي صريح الحدود | منفّذ كودًا، لم يتحقق | `local_info_screen.dart`; لا بيانات/خرائط مباشرة |
| مساعد demo | منفّذ كودًا، لم يتحقق | `assistant_screen.dart`; ردود محددة مسبقًا لا AI حيًا |
| اشتراكات وخطط بلا دفع | منفّذ كودًا، لم يتحقق | `subscriptions_screen.dart`; طلبات محلية فقط |
| الملف الشخصي والتفضيلات | منفّذ كودًا، لم يتحقق | `profile_screen.dart` |
| مركز الإشعارات | منفّذ كودًا، لم يتحقق | `notifications_screen.dart`; إشعارات داخل التطبيق فقط |
| Not Found | منفّذ كودًا، لم يتحقق | `not_found_screen.dart` |
| AppShell والتنقل وعلامة demo | منفّذ كودًا، لم يتحقق | `navigation/app_shell.dart`; خمسة وجهات سفلية |
| النماذج وبيانات demo والحفظ | منفّذ كودًا، لم يتحقق | `data/models.dart`, `data/demo_data.dart`, `state/app_state.dart` |
| تصميم MulkCare والأصول | منفّذ كودًا، لم يتحقق | `DESIGN.md`, Tajawal، 8 صور محلية |
| توقيت القاهرة وDST | منفّذ كودًا، لم يتحقق | `timezone`, `initializeAppTimeZone`, `cairoCalendarDate`; اختبار تقويم مؤلف ينتظر CI |
| اختبارات منطق الحالة | منفّذ كودًا، لم يتحقق | 6 اختبارات في `test/app_state_test.dart` |
| اختبارات رسم الشاشات | منفّذ كودًا، لم يتحقق | 11 اختبار widget في `test/screens_smoke_test.dart` |
| GitHub Actions: analyze/test/APK | منفّذ كودًا، لم يتحقق | `.github/workflows/build-apk.yml`; لم يجر تشغيل على الفرع بعد |
| `pubspec.lock` ثابت | غير مكتمل | سيُرفع كأثر مؤقت من أول Actions ثم يُلتزم ويُعاد build |
| اختبار جهاز Android | غير متحقق | لم يحدث؛ لا يوجد جهاز متصل أو اختبار مالك مسجل |
| التوقيع الإنتاجي ونشر Play | غير مدعوم/خارج النطاق | APK debug-signed فقط، ولا توجد بيانات keystore |
