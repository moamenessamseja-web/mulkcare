# نقطة التسليم — ابدأ من هنا

اقرأ `.agent/README.md` ثم `Implementation_Plan_and_Development_Instructions.md`, `IMPLEMENTATION_STATE.md`, `implementation.md`, و`VERIFICATION_REPORT.md`.

الفرع `feature/flutter-migration-complete` مبني من `main`، ويحمل commit `509de17` مع lockfile. Actions run 4 (الرابط في `IMPLEMENTATION_STATE.md`) مرّر analyzer، ومرّت 13/17 الاختبارات؛ الأربع المتبقية فشلت لأن بيانات Intl لم تُهيأ قبل DateFormat. أضيفت تهيئة `ar` و`en` في bootstrap وsetup smoke tests إلى شجرة العمل الحالية، لكن التعديل لم يُدفع.

الخطوة التالية: فحص `git diff --check`، commit إصلاح Intl، ثم push. تابع run 5 بواسطة GitHub API. إذا اجتاز الاختبارات، دع workflow يكمل `flutter build apk --release` وينزل artifact. عالج أي فشل عبر commit ثم Actions؛ لا تشغّل Flutter محليًا.

لا تدمج `main` ولا تغيّر `com.mullky`. لا يوجد اختبار جهاز فعلي أو توقيع إنتاجي أو نشر Play.