# تقرير التحقق — 2026-11-02

## تدقيق ساكن

| الفحص | النتيجة |
|---|---|
| مفاتيح ar/en | 397 في كل لغة؛ متطابقة |
| استدعاءات الترجمة الحرفية في Dart | 266؛ لا مفاتيح ناقصة |
| الصور المحلية | 8/8 موجودة |
| الشاشات والمسارات | 11 ملفًا و11 مسارًا |
| توقيت القاهرة | `Africa/Cairo` وتهيئة Intl لـar/en، واختبار DST |
| أسرار المستودع | لم يظهر نمط token في ملفات Git |

## GitHub Actions

| Run | Commit | النتيجة |
|---|---|---|
| [3](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41396762658) | `2e219a5` | فشل analyzer بسبب أقواس ناقصة؛ أُصلحت. لم يصل إلى الاختبارات أو APK. |
| [4](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41397097527) | `509de17` | analyzer ناجح؛ 13/17 اختبارًا. الأربع المتبقية أظهرت غياب تهيئة Intl للتواريخ؛ أُصلح السبب في commit تالٍ. |
| [5](https://github.com/moamenessamseja-web/mulkcare/actions/runs/41397422327) | `fcbaa5d` | نجاح كامل: analyzer، **17/17 اختبارًا**، release APK، ورفع artifact. |

## فحص APK

GitHub artifact: `MulkCare-APK-5` (معرّف artifact `13120745255`). نُزّل إلى `/home/ubuntu/mulkcare-output/MulkCare-release.apk`. الحجم `59,383,659` بايت (59.4 MB)، ونوعه Android package. نجح `unzip -t` مع `No errors detected in compressed data`.

SHA-256: `903384be2cc648920a50cf54a9ba1cd3556a1fc118c06b7c593292a113508541`.

## حدود الاختبار

اختبارات الشاشات هي widget smoke tests للتحقق من الرسم بلا استثناءات؛ واختبارات الحالة تغطي التهيئة واللغة وتدفقات بيانات demo. لا يثبت CI جودة تجربة كل جهاز/مقاس شاشة، ولم يُجر اختبار تثبيت على هاتف فعلي. APK لا يحتوي على توقيع إنتاجي أو تجهيز Play.