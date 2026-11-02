import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

bool _timeZoneInitialized = false;

void initializeAppTimeZone() {
  if (_timeZoneInitialized) return;
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
  _timeZoneInitialized = true;
}

void _ensureTimeZone() {
  if (!_timeZoneInitialized) initializeAppTimeZone();
}

DateTime cairoNow() {
  _ensureTimeZone();
  return tz.TZDateTime.now(tz.local);
}

DateTime cairoCalendarDate(
  int year,
  int month,
  int day, [
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
]) {
  _ensureTimeZone();
  return tz.TZDateTime(tz.local, year, month, day, hour, minute, second, millisecond, microsecond);
}

DateTime addCairoCalendarDays(DateTime value, int days) => cairoCalendarDate(
      value.year,
      value.month,
      value.day + days,
      value.hour,
      value.minute,
      value.second,
      value.millisecond,
      value.microsecond,
    );

String serializeCairo(DateTime value) {
  _ensureTimeZone();
  return tz.TZDateTime.from(value, tz.local).toUtc().toIso8601String();
}

DateTime parseCairo(String value) {
  _ensureTimeZone();
  final parsed = DateTime.parse(value);
  final hasExplicitZone = RegExp(r'(?:Z|[+-]\d{2}:?\d{2})$', caseSensitive: false).hasMatch(value);
  if (hasExplicitZone) return tz.TZDateTime.from(parsed, tz.local);
  // Older demo snapshots stored Cairo wall-clock fields without a UTC offset.
  return cairoCalendarDate(parsed.year, parsed.month, parsed.day, parsed.hour, parsed.minute, parsed.second, parsed.millisecond, parsed.microsecond);
}

String formatMoney(int? amount, String language) {
  if (amount == null) return language == 'ar' ? 'غير متاح' : 'Not available';
  final value = NumberFormat.decimalPattern('en').format(amount);
  return language == 'ar' ? '$value ج.م' : '$value EGP';
}

String formatDate(DateTime? date, String language) {
  if (date == null) return language == 'ar' ? 'غير متاح' : 'Not available';
  final locale = language == 'ar' ? 'ar' : 'en';
  final value = DateFormat('dd MMM yyyy', locale).format(date);
  return _latinDigits(value);
}

String formatTime(DateTime? date) {
  if (date == null) return '—';
  return DateFormat('HH:mm', 'en').format(date);
}

String formatRelative(DateTime date, String language) {
  final now = cairoNow();
  final today = DateTime.utc(now.year, now.month, now.day);
  final target = DateTime.utc(date.year, date.month, date.day);
  final calendarDays = today.difference(target).inDays;
  if (calendarDays <= 0) return language == 'ar' ? 'اليوم' : 'Today';
  if (calendarDays == 1) return language == 'ar' ? 'أمس' : 'Yesterday';
  return language == 'ar' ? 'منذ $calendarDays أيام' : '$calendarDays days ago';
}

String _latinDigits(String input) {
  const digits = {'٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4', '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9'};
  var value = input;
  for (final entry in digits.entries) {
    value = value.replaceAll(entry.key, entry.value);
  }
  return value;
}
