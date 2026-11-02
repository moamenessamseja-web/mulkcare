# جرد التنفيذ — MulkCare Flutter

تُستخدم الحالات بدقة: **منفّذ**، **متحقق عبر CI** (مع تحديد نوع الاختبار)، **مختبر على جهاز**، أو **غير مدعوم/خارج النطاق**. نجاح smoke test لا يعني أن كل تفاعل أو جهاز قد اختُبر.

| الوحدة | الحالة بعد run 5 | الدليل والحدود |
|---|---|---|
| RTL/LTR والعربية/الإنجليزية | متحقق عبر analyzer وsmoke | 397 مفتاحًا في كل قاموس؛ 266 استدعاء ترجمة حرفيًا بلا مفاتيح ناقصة؛ التواريخ مهيأة للغتين |
| الدخول والتسجيل | متحقق عبر smoke | `auth_screen.dart`؛ المصادقة تجريبية بلا backend |
| لوحة الرئيسية | متحقق عبر smoke | `home_screen.dart`؛ بيانات demo |
| تفاصيل العقار | متحقق عبر smoke | `property_details_screen.dart` |
| تقرير الفحص | متحقق عبر smoke | `inspection_report_screen.dart`؛ مشاركة PDF غير مهيأة |
| الخدمات وتتبع الحالة | متحقق عبر smoke واختبارات حالة | `services_screen.dart`؛ إنشاء محلي وانتقالات الطلب محكومة، والمرفقات محلية |
| الدليل المحلي | متحقق عبر smoke | `local_info_screen.dart`؛ لا بيانات أو خرائط مباشرة |
| المساعد | متحقق عبر smoke | `assistant_screen.dart`؛ ردود demo محددة مسبقًا، لا AI حي |
| الاشتراكات | متحقق عبر smoke | `subscriptions_screen.dart`؛ بلا دفع إلكتروني |
| الملف الشخصي | متحقق عبر smoke | `profile_screen.dart` |
| الإشعارات | متحقق عبر smoke | `notifications_screen.dart`؛ إشعارات داخل التطبيق |
| Not Found | متحقق عبر smoke | `not_found_screen.dart` |
| AppShell والتنقل | متحقق عبر smoke | `navigation/app_shell.dart`؛ خمس وجهات |
| النماذج والحالة والحفظ | متحقق عبر 6 اختبارات حالة | `data/models.dart`, `data/demo_data.dart`, `state/app_state.dart` |
| التصميم والأصول | متحقق بالوجود والرسم | Tajawal و8 صور محلية؛ اختبارات الشاشات تتحقق من البناء لا من المطابقة البصرية الكاملة |
| توقيت القاهرة وDST | متحقق عبر اختبار حالة | `timezone`, `initializeAppTimeZone`, `cairoCalendarDate` |
| اختبار الشاشات | متحقق عبر CI | 11 widget smoke tests؛ نجحت كلها في run 5 |
| analyzer وAPK | متحقق عبر CI | [run 5 ناجح](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41397422327)، Flutter 3.47.7، APK artifact موجود |
| lockfile | متحقق ومرفوع | `pubspec.lock` committed من مخرجات Actions |
| اختبار تثبيت على جهاز Android | لم يُختبر | لا يوجد جهاز فعلي في دورة العمل |
| توقيع إنتاجي وGoogle Play | خارج النطاق | لا keystore إنتاجي أو إعداد متجر |
