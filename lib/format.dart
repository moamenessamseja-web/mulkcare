const List<String> _months = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

/// Isolates Latin numerals/IDs inside an Arabic run (DESIGN.md: numerals are
/// Latin and always LTR-isolated).
String ltr(String s) => '\u2066$s\u2069';

/// 1250 -> "1,250" (Latin digits).
String groupThousands(int n) {
  final neg = n < 0;
  final digits = (neg ? -n : n).toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return neg ? '-${buf.toString()}' : buf.toString();
}

/// "1,250 ج.م" with the number LTR-isolated.
String formatMoney(int amount) => '${ltr(groupThousands(amount))} ج.م';

/// "12 أكتوبر 2026" with numerals LTR-isolated.
String formatDate(DateTime d) =>
    '${ltr('${d.day}')} ${_months[d.month - 1]} ${ltr('${d.year}')}';

/// "#MC-10432"
String formatRequestNumber(int n) => ltr('#MC-$n');
