/**
 * Smoke tests for the business logic that is worth protecting:
 * money/date formatting, form validation, request state transitions and the
 * repository's input validation.
 *
 * Run with:  node scripts/smoke.mjs
 * Exits non-zero on the first failure.
 */
import assert from 'node:assert/strict';
import repository from '../src/data/repositories/index.js';
import authService, {
  validateConfirmPassword,
  validateFullName,
  validateIdentifier,
  validatePassword,
} from '../src/data/services/authService.js';
import { formatCurrency, formatDate, formatNumber, formatTime } from '../src/core/format.js';
import { seedState } from '../src/data/mockData.js';

const results = [];
const tests = [];

/** Queue a check. The runner at the bottom awaits each one in order. */
function test(name, fn) {
  tests.push([name, fn]);
}

/* --- formatting --------------------------------------------------------- */
test('currency uses Latin digits and the Arabic pound suffix', () => {
  assert.equal(formatCurrency(1250, 'ar'), '1,250 ج.م');
  assert.equal(formatCurrency(1250, 'en'), '1,250 EGP');
});
test('currency returns empty for a missing value instead of 0', () => {
  assert.equal(formatCurrency(null, 'ar'), '');
  assert.equal(formatCurrency(undefined, 'en'), '');
});
test('numbers are grouped and never produce NaN text', () => {
  assert.equal(formatNumber(1999), '1,999');
  assert.equal(formatNumber('abc'), '');
});
test('dates render month names per locale', () => {
  const iso = '2026-10-09T09:00:00.000Z';
  assert.match(formatDate(iso, 'en'), /9 October 2026/);
  assert.match(formatDate(iso, 'ar'), /9 أكتوبر 2026/);
});
test('time is 24-hour and zero padded', () => {
  const iso = new Date(2026, 9, 9, 8, 5).toISOString();
  assert.equal(formatTime(iso), '08:05');
});

/* --- auth validation ---------------------------------------------------- */
test('identifier accepts an email and an Egyptian mobile number', () => {
  assert.equal(validateIdentifier('owner@mulkcare.demo'), null);
  assert.equal(validateIdentifier('01012345678'), null);
});
test('identifier rejects empty, malformed email and wrong-length phone', () => {
  assert.equal(validateIdentifier(''), 'auth.errRequired');
  assert.equal(validateIdentifier('nope@'), 'auth.errEmailFormat');
  assert.equal(validateIdentifier('0101234'), 'auth.errPhone');
});
test('password length floor is enforced', () => {
  assert.equal(validatePassword('12345'), 'auth.errPasswordLength');
  assert.equal(validatePassword('123456'), null);
});
test('confirm-password mismatch is reported', () => {
  assert.equal(validateConfirmPassword('abcdef', 'abcdeg'), 'auth.errPasswordMatch');
  assert.equal(validateConfirmPassword('abcdef', 'abcdef'), null);
});
test('full name rejects a single character', () => {
  assert.equal(validateFullName('ا'), 'auth.errNameShort');
  assert.equal(validateFullName('أحمد'), null);
});

/* --- sign-in behaviour -------------------------------------------------- */
test('the demo account signs in without the password entering the session', async () => {
  const session = await authService.signIn({ identifier: 'owner@mulkcare.demo', password: 'secret123' });
  assert.equal(session.mode, 'demo');
  assert.equal(session.userId, seedState.user.id);
  assert.equal(JSON.stringify(session).includes('secret123'), false);
});
test('a wrong demo account is rejected', async () => {
  await assert.rejects(
    () => authService.signIn({ identifier: 'someone@else.example', password: 'secret123' }),
    (error) => error.code === 'UNAUTHORIZED',
  );
});

/* --- state machine ------------------------------------------------------ */
test('legal transitions are allowed', () => {
  assert.equal(repository.canTransition('pending', 'awaiting_approval'), true);
  assert.equal(repository.canTransition('awaiting_approval', 'approved'), true);
  assert.equal(repository.canTransition('in_progress', 'completed'), true);
  assert.equal(repository.canTransition('scheduled', 'cancelled'), true);
});
test('illegal transitions are refused', () => {
  assert.equal(repository.canTransition('completed', 'in_progress'), false);
  assert.equal(repository.canTransition('cancelled', 'approved'), false);
  assert.equal(repository.canTransition('pending', 'completed'), false);
});
test('every seeded request sits in a state that exists in the transition map', () => {
  for (const request of seedState.serviceRequests) {
    assert.ok(repository.transitions[request.status], `unknown status ${request.status}`);
  }
});

/* --- request creation validation ---------------------------------------- */
test('a request needs a known property, a category and a real description', async () => {
  const bundle = seedState;
  await assert.rejects(
    () => repository.createServiceRequest(bundle, { propertyId: 'nope', category: 'hvac', description: 'x'.repeat(20) }),
    (error) => error.code === 'VALIDATION' && error.field === 'propertyId',
  );
  await assert.rejects(
    () => repository.createServiceRequest(bundle, { propertyId: 'prp_01', category: '', description: 'x'.repeat(20) }),
    (error) => error.field === 'category',
  );
  await assert.rejects(
    () => repository.createServiceRequest(bundle, { propertyId: 'prp_01', category: 'hvac', description: 'short' }),
    (error) => error.field === 'description',
  );
});
test('a valid request is created as pending with no invented estimate', async () => {
  const created = await repository.createServiceRequest(seedState, {
    propertyId: 'prp_01',
    category: 'cleaning',
    description: 'تنظيف شامل قبل وصول الأسرة إلى الشاليه',
  });
  assert.equal(created.status, 'pending');
  assert.equal(created.estimatedCost, null);
  assert.equal(created.finalCost, null);
  assert.equal(created.ownerId, seedState.user.id);
  assert.match(created.reference, /^MC-\d+$/);
});

/* --- sample data integrity ---------------------------------------------- */
test('every image reference is either a local file that exists or a managed https URL', async () => {
  const { access } = await import('node:fs/promises');
  const paths = new Set();
  for (const property of seedState.properties) property.images.forEach((p) => paths.add(p));
  for (const request of seedState.serviceRequests) (request.images || []).forEach((p) => paths.add(p));
  for (const report of seedState.inspectionReports) {
    (report.images || []).forEach((p) => paths.add(p));
    (report.issuePhotos || []).forEach((photo) => {
      if (photo.before) paths.add(photo.before);
      if (photo.after) paths.add(photo.after);
    });
  }

  // 6 distinct photos are referenced by the seed data; the other 2 generated
  // images are referenced directly by the auth and subscription screens.
  assert.ok(paths.size >= 6, `expected at least 6 referenced images, found ${paths.size}`);
  for (const path of paths) {
    // Photographic assets are migrated to the platform CDN at publish time; the
    // publisher rewrites their runtime references to the CDN URL.
    if (path.startsWith('https://')) continue;
    assert.ok(path.startsWith('/'), `unexpected image reference scheme: ${path}`);
    await access(`public${path}`);
  }
});
test('every service request points at a real property and owner', () => {
  const propertyIds = new Set(seedState.properties.map((p) => p.id));
  for (const request of seedState.serviceRequests) {
    assert.ok(propertyIds.has(request.propertyId), `orphan request ${request.id}`);
    assert.equal(request.ownerId, seedState.user.id);
  }
});
test('every inspection report points at a real property', () => {
  const propertyIds = new Set(seedState.properties.map((p) => p.id));
  for (const report of seedState.inspectionReports) {
    assert.ok(propertyIds.has(report.propertyId), `orphan report ${report.id}`);
  }
});
test('plan prices are flagged as proposed test prices', () => {
  for (const plan of seedState.plans) {
    assert.equal(plan.isProposedTestPrice, true, `plan ${plan.id} must be flagged`);
  }
});

let passed = 0;
for (const [name, fn] of tests) {
  try {
    // Sequential on purpose: one failure report at a time.
    // eslint-disable-next-line no-await-in-loop
    await fn();
    passed += 1;
    results.push(`  ok   ${name}`);
  } catch (error) {
    results.push(`  FAIL ${name}\n       ${error.message}`);
    console.error(results.join('\n'));
    process.exit(1);
  }
}

console.log(results.join('\n'));
console.log(`\n${passed}/${tests.length} checks passed.`);
