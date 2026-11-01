/**
 * Locale-aware formatting helpers.
 * Numerals are Latin (0-9) in both locales per the design system, so every
 * formatter pins the `en-US` digit set and only the surrounding words change.
 */

const AR_MONTHS = [
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

const EN_MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const numberFormatter = new Intl.NumberFormat('en-US', { maximumFractionDigits: 0 });

export function formatNumber(value) {
  if (value === null || value === undefined || Number.isNaN(Number(value))) return '';
  return numberFormatter.format(Number(value));
}

/** `1,250 ج.م` in Arabic, `1,250 EGP` in English. */
export function formatCurrency(value, lang = 'ar') {
  const amount = formatNumber(value);
  if (!amount) return '';
  return lang === 'ar' ? `${amount} ج.م` : `${amount} EGP`;
}

function toDate(value) {
  if (!value) return null;
  const date = value instanceof Date ? value : new Date(value);
  return Number.isNaN(date.getTime()) ? null : date;
}

/** `9 أكتوبر 2026` / `9 October 2026`. */
export function formatDate(value, lang = 'ar') {
  const date = toDate(value);
  if (!date) return '';
  const months = lang === 'ar' ? AR_MONTHS : EN_MONTHS;
  return `${date.getDate()} ${months[date.getMonth()]} ${date.getFullYear()}`;
}

/** `9 أكتوبر` / `9 October` — used where the year is obvious. */
export function formatDayMonth(value, lang = 'ar') {
  const date = toDate(value);
  if (!date) return '';
  const months = lang === 'ar' ? AR_MONTHS : EN_MONTHS;
  return `${date.getDate()} ${months[date.getMonth()]}`;
}

/** `20:30` — 24-hour clock in both locales. */
export function formatTime(value) {
  const date = toDate(value);
  if (!date) return '';
  const hh = String(date.getHours()).padStart(2, '0');
  const mm = String(date.getMinutes()).padStart(2, '0');
  return `${hh}:${mm}`;
}

export function formatDateTime(value, lang = 'ar') {
  const date = toDate(value);
  if (!date) return '';
  return `${formatDate(date, lang)} · ${formatTime(date)}`;
}

export function formatDateInput(value) {
  const date = toDate(value);
  if (!date) return '';
  const mm = String(date.getMonth() + 1).padStart(2, '0');
  const dd = String(date.getDate()).padStart(2, '0');
  return `${date.getFullYear()}-${mm}-${dd}`;
}

/** Coarse relative time: `قبل 3 أيام` / `3 days ago`. */
export function formatRelative(value, lang = 'ar') {
  const date = toDate(value);
  if (!date) return '';
  const diffMs = Date.now() - date.getTime();
  const minutes = Math.floor(diffMs / 60000);
  if (minutes < 1) return lang === 'ar' ? 'الآن' : 'just now';
  if (minutes < 60) {
    return lang === 'ar' ? `قبل ${minutes} دقيقة` : `${minutes} min ago`;
  }
  const hours = Math.floor(minutes / 60);
  if (hours < 24) {
    return lang === 'ar' ? `قبل ${hours} ساعة` : `${hours} h ago`;
  }
  const days = Math.floor(hours / 24);
  if (days < 30) {
    return lang === 'ar' ? `قبل ${days} يوم` : `${days} d ago`;
  }
  const months = Math.floor(days / 30);
  return lang === 'ar' ? `قبل ${months} شهر` : `${months} mo ago`;
}

/** ISO string helper for seed data generated relative to "now". */
export function shiftDays(days, hour = 9) {
  const date = new Date();
  date.setHours(hour, 0, 0, 0);
  date.setDate(date.getDate() + days);
  return date.toISOString();
}

export function todayInputValue() {
  return formatDateInput(new Date());
}
