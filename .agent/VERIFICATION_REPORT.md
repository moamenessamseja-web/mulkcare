# تقرير التحقق — 2026-11-02

## فحوص المصدر الساكنة

| الفحص | النتيجة |
|---|---|
| مفاتيح ar/en | 397 في كل لغة؛ متطابقة |
| استدعاءات الترجمة الحرفية في Dart | 266؛ لا مفتاح مفقود |
| الأصول | 8 صور محلية موجودة |
| routes/screens | 11 مسارًا و11 ملفًا مستوردًا |
| توقيت القاهرة | `Africa/Cairo` مهيأة؛ لا `DateTime.now()` خارج helper ولا حساب يوم بـ`Duration(days: …)` |
| token scan | لا نمط GitHub token في المستودع |

## GitHub Actions run 3

[تشغيل 3 — commit `2e219a5`](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41396762658): نجحت تهيئة Flutter/Android و`pub get` ورفع `pubspec.lock`. فشل analyzer بسبب قوس صنف مفقود وثلاثة أقواس `SurfaceCard` مفقودة. الاختبارات وAPK تخطيا.

## GitHub Actions run 4

[تشغيل 4 — commit `509de17`](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41397097527): نجح `flutter analyze`. وصلت الاختبارات إلى 13 ناجحًا و4 فاشلة. الحالات الفاشلة هي تفاصيل العقار، تقرير الفحص، الاشتراكات والملف الشخصي؛ جميعها سجلت `LocaleDataException` لعدم تهيئة بيانات التاريخ المحلية (`initializeDateFormatting`). توقفت عملية APK بسبب فشل الاختبارات.

## الإصلاح والتحقق التالي

أضيفت تهيئة Intl للعربية والإنجليزية في `main()` و`setUpAll()` لاختبارات smoke. التغيير غير مرفوع حاليًا ولم يُشغّل بعد على GitHub. لا يوجد APK ناجح حتى run أخضر لاحق. لم يُختبر التطبيق على هاتف فعلي، والتوقيع الإنتاجي/نشر Play خارج النطاق.