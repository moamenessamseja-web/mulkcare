# حالة التنفيذ الحالية — 2026-11-02

## الأساس والفرع

المستودع `moamenessamseja-web/mulkcare`، والفرع المستقل `feature/flutter-migration-complete` مبني من `main` عند `b428a8d32c45780e7c72fe818df00125ceac4770`. بقي `main` دون تعديل. آخر commit مرفوع: `509de17a2e025cda7e50d2b4ad00c3a590e938cd` (`Fix Flutter analysis and lock dependencies`). يحتوي الفرع `pubspec.lock` الذي أنتجه GitHub runner الأول.

## التنفيذ

توجد بنية Flutter وملفات منفصلة لكل الشاشات الإحدى عشرة. نُقلت 3 خطوط Tajawal و8 صور وقواميس العربية والإنجليزية الأصلية. توجد حالة وبيانات محلية، GitHub Actions ببناء Android داخل runner، و17 اختبارًا (6 للحالة و11 لرسم الشاشات). التوقيت يستخدم `Africa/Cairo` والحسابات التقويمية الصريحة.

## الفحوص الساكنة

- القواميس متطابقة: 397 مفتاحًا لكل لغة.
- 266 استدعاء ترجمة حرفيًا؛ لم توجد مفاتيح مفقودة.
- كل الشاشات والمسارات الأحد عشر والصور الثماني موجودة.
- لا token GitHub في ملفات المستودع.

## تشغيل Actions 3

الرابط: https://github.com/moamenessamseja-web/mulkcare/actions/runs/41396762658 . نجحت تهيئة Flutter `3.47.7` وAndroid و`pub get` ورفع lockfile. فشل analyzer بسبب قوس إغلاق ناقص في `main.dart` وثلاثة أقواس في تفاصيل العقار، ولم تصل الخطوات للاختبارات أو APK. أُصلحت الأخطاء وأُضيف lockfile في commit `509de17`.

## تشغيل Actions 4

الرابط: https://github.com/moamenessamseja-web/mulkcare/actions/runs/41397097527 . نجح `flutter analyze`، ونجحت 13 من 17 الاختبارات. فشلت أربع شاشات (تفاصيل العقار، تقرير الفحص، الاشتراكات، الملف الشخصي) بسبب عدم تهيئة بيانات تواريخ Intl العربية/الإنجليزية؛ لم يُبنَ APK.

## الإصلاح الحالي غير المرفوع

أضيفت `initializeAppDateFormatting()` باستخدام `intl/date_symbol_data_local.dart`، مع استدعائها في bootstrap وفي `setUpAll` لاختبارات الشاشات. لم تُدفع هذه التغييرات ولم تُتحقق بعد. الخطوة التالية commit على الفرع نفسه، ثم مراقبة Actions run 5 ومعالجة أي فشل حتى نجاح analyzer والاختبارات وبناء APK.

كل Flutter validation يتم عبر GitHub Actions فقط؛ لم يُجر اختبار على جهاز Android فعلي، ولا يوجد توقيع إنتاجي أو نشر Play.