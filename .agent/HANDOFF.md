# نقطة التسليم — ابدأ من هنا

اقرأ `.agent/README.md` ثم `Implementation_Plan_and_Development_Instructions.md`, `IMPLEMENTATION_STATE.md`, `implementation.md`, `TODO.md`.

الفرع الحالي `feature/flutter-migration-complete` مبني من `main` عند `b428a8d`. توجد ملفات Flutter لكل الشاشات الإحدى عشرة، لكن Flutter analyzer والاختبارات وبناء APK لم تُشغّل بعد. لا يوجد Flutter SDK أو Android SDK في sandbox؛ كل هذه الخطوات تتم عبر GitHub Actions كما طلب المالك.

الخطوة المباشرة: نفّذ مراجعة `git diff --check` ثم commit آمنًا على هذا الفرع وارفعه باستخدام جلسة GitHub CLI الموجودة، وبعدها تحقق من workflow run عبر `gh`/GitHub API. لا تقل للمستخدم أن يبني أو يجرب محليًا. عالج أخطاء analyzer/tests عبر commits على نفس الفرع. عند نجاح `flutter pub get`، نزّل artifact `MulkCare-pubspec-lock-<run>`، أضف `pubspec.lock` إلى commit، ثم شغّل Actions مرة أخرى ليكون الـAPK النهائي مبنيًا من lockfile ثابت.

سجّل SHA والنتيجة ورابط artifacts في `IMPLEMENTATION_STATE.md` و`VERIFICATION_REPORT.md`. نجاح CI لا يساوي اختبار هاتف؛ لا تذكر تجربة جهاز لم تحدث. لا تدمج `main`، ولا تبدل `com.mullky` أو التوقيع أو إعداد Play.