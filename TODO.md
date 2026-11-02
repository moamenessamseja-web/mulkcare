# قائمة التحويل والقبول

- [x] Flutter app shell والتنقل RTL/LTR ذوا خمس وجهات وراية demo.
- [x] نقل الشاشات الإحدى عشرة مع الحفاظ على هيكل تصميم MulkCare.
- [x] نقل Tajawal والصور الثماني وقواميس العربية والإنجليزية.
- [x] حالة demo محلية وحدود واضحة لعدم وجود backend أو دفع أو AI مباشر.
- [x] توقيت Africa/Cairo وحساب الأيام المحلية عبر DST.
- [x] GitHub Actions يستخدم Flutter 3.47.7 ويولّد Android على runner مع `pubspec.lock` ثابت.
- [x] `flutter analyze` ناجح على GitHub Actions.
- [x] جميع الاختبارات الـ17 ناجحة (6 حالة + 11 widget smoke).
- [x] بناء release APK ورفع artifact `MulkCare-APK-5`.
- [x] تنزيل APK وفحص نوعه وZIP وتوثيق SHA-256.
- [ ] اختبار التثبيت والتفاعلات على هاتف Android فعلي؛ لم يحدث ضمن هذه المهمة.
- [ ] توقيع إنتاجي/نشر Play؛ خارج النطاق ويتطلب keystore وطلبًا مستقلًا.
