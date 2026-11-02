# تقرير التحقق — 2026-11-02

## فحوص المصدر الساكنة

| الفحص | النتيجة |
|---|---|
| مفاتيح الترجمة ar/en | 397 في كل لغة؛ متطابقة |
| الاستدعاءات الحرفية في Dart | 266؛ لا مفتاح مفقود |
| الصور المحلية | 8 من 8 موجودة |
| الشاشات والمسارات | 11 import و11 ملفًا موجودة |
| التوقيت | `Africa/Cairo` مهيأة؛ لا `DateTime.now()` خارج helper القاهرة ولا حساب يوم بـ`Duration(days: ...)` |
| token scan | لا نمط GitHub classic token في الملفات الملتزمة |
| `git diff --check` | ناجح في فحص ما قبل commit الأول |

## GitHub Actions

**Run 3 / commit `2e219a53e90836d0a4b6f88b1fb43c16ea8234b7`:** [رابط التشغيل](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41396762658)

نجحت عملية تثبيت Flutter `3.47.7`، توليد Android scaffold في runner، `flutter pub get`، ورفع `pubspec.lock` artifact. فشل `flutter analyze` بسبب:

1. غياب إغلاق صنف `MulkCareApp` قبل تعريف `_route` و`_RouteScreen`.
2. غياب ثلاثة أقواس إغلاق حول `SurfaceCard` في `property_details_screen.dart`.
3. ظهرت ملاحظتا deprecation على `DropdownButtonFormField.value`؛ استُبدلتا بـ`initialValue`.

نتيجة ذلك: لم تُشغّل اختبارات Flutter ولم يُبنَ APK في run 3.

## الحالة بعد run 3

صُححت الأخطاء المذكورة في شجرة العمل، ونُزّل lockfile الناتج من artifact الرسمي `MulkCare-pubspec-lock-3` إلى `pubspec.lock`. هذه التصحيحات وملف lock لم تُدفع بعد، لذلك لم تتحقق عبر Actions. لا يُوصف التطبيق بأنه ناجح التحليل أو البناء حتى يظهر تشغيل أخضر جديد.

لم يحدث اختبار على جهاز فعلي، ولا يوجد توقيع إنتاجي أو نشر إلى Play.