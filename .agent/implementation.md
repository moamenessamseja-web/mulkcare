# جرد التنفيذ — MulkCare Flutter

الحالات المتاحة: **Verified complete** · **Implemented, not yet verified** · **Partially implemented** · **Not started** · **Blocked** · **Deferred by product decision**. لا تُرفع حالة UI إلى متحقق لمجرد نجاح analyzer أو اختبار بناء شاشة منفردة.

| الوحدة | الحالة الحالية | الدليل/الحد |
|---|---|---|
| بدء التطبيق وتهيئة البيانات | Implemented, not yet verified | APK-5 عُبّئ؛ المالك أبلغ عن شاشة بيضاء بعد الدخول. يلزم اختبار تدفق فعلي عبر CI ثم جهاز. |
| تسجيل الدخول إلى لوحة المعلومات | Partially implemented | الكود كان يحدّث الحالة دون تبديل مسار Navigator. أضيف انتقال صريح واختبار انحدار؛ CI لم يُشغّل بعد. |
| التسجيل إلى لوحة المعلومات | Partially implemented | أضيف انتقال صريح واختبار widget؛ النتيجة بانتظار CI. |
| AppShell والـNavigationBar | Partially implemented | كان Center غير محدود الارتفاع؛ أضيف حد 80 logical px واختبار موضع/ضغط؛ بانتظار CI وجهاز. |
| لوحة الرئيسية | Implemented, not yet verified | ملف موجود واختبار رسم سابق؛ لا دليل موثوق من رحلة تشغيل على هاتف. |
| تفاصيل العقار وتقرير الفحص | Implemented, not yet verified | ملفات موجودة واختبارات بناء منفردة؛ الاستخدام من التنقل لم يُؤكد بعد. |
| الخدمات وتتبع الحالات | Implemented, not yet verified | حالة demo واختبارات منطق؛ اختبار وصول من الشريط مضاف لكنه ينتظر CI. |
| الدليل المحلي والمساعد | Implemented, not yet verified | ميزات demo بلا بيانات مباشرة أو AI حي؛ يلزم فحص وصولها واستخدامها في التطبيق. |
| الاشتراكات والملف الشخصي والإشعارات | Implemented, not yet verified | ملفات واختبارات رسم منفردة؛ التفاعلات الطرفية لم تُختبر من جلسة تطبيق كاملة. |
| Not Found والترجمات RTL/LTR | Implemented, not yet verified | فحوص قاموس ورسم سابقة؛ لا تعتبرها تحققًا من رحلة مستخدم. |
| النموذج المحلي وبيانات demo وتوقيت القاهرة | Verified complete (unit-level only) | اختبارات الحالة الستة نجحت في run 5؛ لا backend أو دفع أو خدمة AI مباشرة. |
| اختبارات الشاشات المنفردة | Verified complete (build-only smoke) | 11 اختبارًا سابقًا مرّت، لكنها لم تكشف عيوب مسار التطبيق أو هندسة الشريط. لا تساوي قبول UI. |
| اختبارات login/navigation الجديدة | Implemented, not yet verified | `test/app_navigation_test.dart` يغطي login، تسجيل حساب، ظهور Home، قياس موضع NavigationBar، والنقر على الخدمات؛ لم يصل بعد إلى CI. |
| analyzer وبناء APK السابق | Verified complete (CI/build level only) | run 5 أخضر على `fcbaa5d`؛ APK-5 غير موثوق لسلوك التطبيق وفق بلاغ المالك. |
| التحقق من الإصلاح الجديد | Blocked pending CI | لا Flutter SDK محليًا؛ انتظر Actions على commit الإصلاح. |
| التثبيت على جهاز المالك | Not started in this correction | مطلوب بعد APK جديد؛ لا يمكن استنتاجه من CI. |
| توقيع إنتاجي وGoogle Play | Deferred by product decision | لا keystore إنتاجي أو إعداد نشر متجر. |
