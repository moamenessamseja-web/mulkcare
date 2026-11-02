# سجل التغييرات

## 2026-11-02 — تحويل Flutter وتشغيل Actions الأول

أضيفت بنية Flutter وشاشات المسارات الإحدى عشرة والأصول الأصلية واختبارات الحالة و11 smoke test. أضيف توقيت `Africa/Cairo` وworkflow يستخدم Flutter `3.47.7` ويولد Android في GitHub runner.

نجح run 3 في تثبيت Flutter وإنشاء scaffold وحل الاعتماديات ورفع `pubspec.lock` artifact. فشل analyzer بسبب قوس صنف مفقود وثلاثة أقواس `SurfaceCard` مفقودة؛ لم تصل الخطوات للاختبارات أو APK. أُصلحت الأقواس، واستبدلت وسيطتا `DropdownButtonFormField.value` بـ`initialValue`. نُزّل lockfile من GitHub runner وأُضيف إلى شجرة العمل.

النتيجة النهائية للتصحيحات ما تزال معلقة؛ يجب دفعها وتشغيل Actions مجددًا قبل ادعاء نجاح التحليل أو الاختبارات أو APK.