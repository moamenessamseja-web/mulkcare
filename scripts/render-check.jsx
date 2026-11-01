/**
 * Render check — renders every route in both languages, server-side, with the
 * sample data pre-seeded so the populated branch of each screen is exercised.
 *
 * This catches the class of bug a production build cannot: undefined variables,
 * bad prop use, and crashes inside the render path of a screen.
 *
 * It is not a substitute for looking at the app. Layout, colour and interaction
 * still need a human (or a browser) to confirm.
 *
 * Run with:  npm run check:render
 */
import { renderToString } from 'react-dom/server';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import { LanguageProvider } from '../src/core/i18n';
import { StoreProvider } from '../src/app/store';
import { ToastProvider } from '../src/core/components/Toast';
import AppShell from '../src/app/AppShell';
import AuthPage from '../src/pages/AuthPage';
import HomePage from '../src/pages/HomePage';
import PropertyDetailsPage from '../src/pages/PropertyDetailsPage';
import InspectionReportPage from '../src/pages/InspectionReportPage';
import ServicesPage from '../src/pages/ServicesPage';
import LocalInfoPage from '../src/pages/LocalInfoPage';
import AssistantPage from '../src/pages/AssistantPage';
import SubscriptionsPage from '../src/pages/SubscriptionsPage';
import ProfilePage from '../src/pages/ProfilePage';
import NotificationsPage from '../src/pages/NotificationsPage';
import NotFoundPage from '../src/pages/NotFoundPage';
import { seedState } from '../src/data/mockData';

/* --- minimal browser surface the store and i18n touch -------------------- */
const store = new Map();
globalThis.window = globalThis.window || {};
globalThis.window.localStorage = {
  getItem: (key) => (store.has(key) ? store.get(key) : null),
  setItem: (key, value) => store.set(key, String(value)),
  removeItem: (key) => store.delete(key),
};
globalThis.document = globalThis.document || {
  documentElement: { lang: '', dir: '' },
  getElementById: () => null,
};

// Pre-seed so the store starts in the "ready" state with real sample content.
window.localStorage.setItem('mulkcare.bundle.v1', JSON.stringify(seedState));
window.localStorage.setItem(
  'mulkcare.session.v1',
  JSON.stringify({ userId: seedState.user.id, issuedAt: new Date().toISOString(), mode: 'demo' }),
);

const SIGNED_IN_ROUTES = [
  ['/', HomePage],
  ['/property/prp_01', PropertyDetailsPage],
  ['/property/prp_02', PropertyDetailsPage],
  ['/inspection/rep_2041', InspectionReportPage],
  ['/inspection/rep_2028', InspectionReportPage],
  ['/services', ServicesPage],
  ['/services?property=prp_01&category=hvac', ServicesPage],
  ['/local', LocalInfoPage],
  ['/assistant', AssistantPage],
  ['/subscriptions', SubscriptionsPage],
  ['/profile', ProfilePage],
  ['/notifications', NotificationsPage],
  ['/route-that-does-not-exist', NotFoundPage],
];

const EDGE_ROUTES = [
  ['/property/does-not-exist', PropertyDetailsPage],
  ['/inspection/does-not-exist', InspectionReportPage],
];

function render(element) {
  return renderToString(
    <LanguageProvider>
      <StoreProvider>
        <ToastProvider>{element}</ToastProvider>
      </StoreProvider>
    </LanguageProvider>,
  );
}

let passed = 0;
const failures = [];

function check(label, element, { expect } = {}) {
  try {
    const html = render(element);
    if (!html || html.length < 200) {
      failures.push(`${label}: rendered almost nothing (${html.length} chars)`);
      return;
    }
    if (html.includes('undefined') && !html.includes('undefined-slot')) {
      failures.push(`${label}: output contains the literal text "undefined"`);
      return;
    }
    if (expect && !html.includes(expect)) {
      failures.push(`${label}: expected to find "${expect}" in the output`);
      return;
    }
    passed += 1;
  } catch (error) {
    failures.push(`${label}: ${error.message}`);
  }
}

for (const lang of ['ar', 'en']) {
  window.localStorage.setItem('mulkcare.lang.v1', lang);

  for (const [path, Component] of SIGNED_IN_ROUTES) {
    check(`${lang} ${path}`, (
      <MemoryRouter initialEntries={[path]}>
        <Routes>
          <Route path="/" element={<AppShell />}>
            <Route index element={<Component />} />
            <Route path="property/:propertyId" element={<Component />} />
            <Route path="inspection/:reportId" element={<Component />} />
            <Route path="services" element={<Component />} />
            <Route path="local" element={<Component />} />
            <Route path="assistant" element={<Component />} />
            <Route path="subscriptions" element={<Component />} />
            <Route path="profile" element={<Component />} />
            <Route path="notifications" element={<Component />} />
            <Route path="*" element={<Component />} />
          </Route>
        </Routes>
      </MemoryRouter>
    ));
  }

  for (const [path, Component] of EDGE_ROUTES) {
    check(`${lang} edge ${path}`, (
      <MemoryRouter initialEntries={[path]}>
        <Routes>
          <Route path="*" element={<Component />} />
        </Routes>
      </MemoryRouter>
    ));
  }

  check(`${lang} /auth`, (
    <MemoryRouter initialEntries={['/auth']}>
      <Routes>
        <Route path="*" element={<AuthPage />} />
      </Routes>
    </MemoryRouter>
  ), { expect: lang === 'ar' ? 'تسجيل الدخول' : 'Sign in' });
}

if (failures.length) {
  console.error(failures.map((line) => `  FAIL ${line}`).join('\n'));
  console.error(`\nrender check FAILED — ${passed} passed, ${failures.length} failed`);
  process.exit(1);
}
console.log(`${passed}/${passed} routes rendered without error.`);
