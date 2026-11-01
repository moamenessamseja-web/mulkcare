/**
 * Static i18n audit.
 *
 * 1. Every literal key passed to `t('…')` anywhere in src/ must exist in BOTH
 *    dictionaries, so a half-translated build fails before it ships.
 * 2. The `ar` and `en` dictionaries must have identical key sets.
 * 3. Dynamic key families (built with template literals) are enumerated
 *    explicitly and checked too.
 *
 * Run with:  node --import ./scripts/register-hook.mjs scripts/check-i18n.mjs
 */
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';
import ar from '../src/core/i18n/ar.js';
import en from '../src/core/i18n/en.js';

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) walk(full, out);
    else if (/\.(jsx?|mjs)$/.test(entry)) out.push(full);
  }
  return out;
}

function flatten(object, prefix = '', out = new Set()) {
  for (const [key, value] of Object.entries(object)) {
    const path = prefix ? `${prefix}.${key}` : key;
    if (value && typeof value === 'object') flatten(value, path, out);
    else out.add(path);
  }
  return out;
}

const arKeys = flatten(ar);
const enKeys = flatten(en);

/* --- 2. dictionary parity ------------------------------------------------ */
const onlyAr = [...arKeys].filter((key) => !enKeys.has(key));
const onlyEn = [...enKeys].filter((key) => !arKeys.has(key));

/* --- 1 + 3. referenced keys --------------------------------------------- */
// Guard against matches inside e.g. `searchParams.get('request')`.
const LITERAL = /(?<![\w.])t\(\s*'([a-zA-Z][\w.]*)'\s*\)/g;
const referenced = new Map();

for (const file of walk('src')) {
  const text = readFileSync(file, 'utf8');
  for (const match of text.matchAll(LITERAL)) {
    if (!referenced.has(match[1])) referenced.set(match[1], file);
  }
}

/** Families built at runtime with template literals / plain string constants. */
const DYNAMIC = {
  'status.*': ['pending', 'awaiting_approval', 'approved', 'scheduled', 'in_progress', 'completed', 'cancelled'],
  'propertyStatus.*': ['occupied', 'vacant', 'maintenance'],
  'inspectionResult.*': ['ok', 'followup', 'repair'],
  'services.categories.*': ['general', 'plumbing', 'electrical', 'hvac', 'cleaning', 'pest', 'other'],
  'local.categories.*': ['pharmacy', 'clinic', 'supermarket', 'essentials', 'transport', 'places'],
  'local.categoryNotes.*': ['pharmacy', 'clinic', 'supermarket', 'essentials', 'transport', 'places'],
  'profile.notifications.*': ['visits', 'maintenance', 'invoices', 'marketing'],
  'inspection.categories.*': ['doorsWindows', 'plumbing', 'electrical', 'hvac', 'leaks', 'cleanliness'],
  'subscriptions.plans.*': ['basic.name', 'basic.frequency', 'basic.limits', 'basic.excluded', 'premium.name', 'premium.frequency', 'premium.limits', 'premium.excluded'],
  'assistant.*demo_': ['ac', 'cleaning', 'report', 'prep', 'invoice', 'plan', 'default'],
};

for (const [family, members] of Object.entries(DYNAMIC)) {
  const prefix = family.replace('*', '');
  for (const member of members) {
    const key = prefix + member;
    if (!referenced.has(key)) referenced.set(key, `dynamic family ${family}`);
  }
}

const missingAr = [];
const missingEn = [];
for (const [key, origin] of referenced) {
  if (!arKeys.has(key)) missingAr.push(`${key}  (${origin})`);
  if (!enKeys.has(key)) missingEn.push(`${key}  (${origin})`);
}

console.log(`dictionary keys: ar=${arKeys.size} en=${enKeys.size}`);
console.log(`referenced literal keys: ${referenced.size}`);
console.log(`keys only in ar: ${onlyAr.length ? onlyAr.join(', ') : 'none'}`);
console.log(`keys only in en: ${onlyEn.length ? onlyEn.join(', ') : 'none'}`);
console.log(`missing from ar: ${missingAr.length ? `\n  - ${missingAr.join('\n  - ')}` : 'none'}`);
console.log(`missing from en: ${missingEn.length ? `\n  - ${missingEn.join('\n  - ')}` : 'none'}`);

if (onlyAr.length || onlyEn.length || missingAr.length || missingEn.length) {
  console.error('\ni18n audit FAILED');
  process.exit(1);
}
console.log('\ni18n audit passed.');
