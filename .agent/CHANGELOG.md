# سجل التغييرات

## 2026-11-02 — تحويل MulkCare إلى Flutter

أضيفت بنية Flutter للشاشات الإحدى عشرة، ونُقلت الأصول وقواميس اللغتين، وأضيفت حالة محلية واختبارات وتوقيت `Africa/Cairo`. أُنشئ فرع مستقل من `main` مع workflow يبني Android عبر GitHub Actions.

كشف run 3 أقواسًا ناقصة، ثم كشف run 4 غياب تهيئة بيانات Intl للتواريخ؛ عولج السببان قبل run 5. نجح run 5 بالكامل: التحليل، 17 اختبارًا، وبناء release APK ورفع artifact. نُزّل الملف وفُحصت سلامة ZIP.

سجل SHA وحجم APK ورابط التشغيل في `IMPLEMENTATION_STATE.md` و`VERIFICATION_REPORT.md`. لم يحدث اختبار هاتف فعلي ولا إعداد توقيع إنتاجي أو نشر Play.