import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom';
import { Bell, ChevronLeft, ChevronRight, Compass, Home, Sparkles, User, Wrench } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from './store';
import { DemoBanner } from '../core/components/StateBlock';

const NAV_ITEMS = [
  { to: '/', key: 'nav.home', icon: Home, end: true },
  { to: '/services', key: 'nav.services', icon: Wrench },
  { to: '/assistant', key: 'nav.assistant', icon: Sparkles },
  { to: '/local', key: 'nav.local', icon: Compass },
  { to: '/profile', key: 'nav.profile', icon: User },
];

/** Contextual app-bar title: exact match first, then longest prefix match. */
const TITLE_ROUTES = [
  { match: '/property/', key: 'property.title' },
  { match: '/inspection/', key: 'inspection.title' },
  { match: '/services', key: 'services.title' },
  { match: '/assistant', key: 'assistant.title' },
  { match: '/local', key: 'local.title' },
  { match: '/subscriptions', key: 'subscriptions.title' },
  { match: '/notifications', key: 'notifications.title' },
  { match: '/profile', key: 'profile.title' },
  { match: '/', key: 'nav.home' },
];

function titleKeyFor(pathname) {
  const exact = TITLE_ROUTES.find((route) => route.match === pathname);
  if (exact) return exact.key;
  const prefixed = TITLE_ROUTES.find((route) => route.match !== '/' && pathname.startsWith(route.match));
  return prefixed ? prefixed.key : 'nav.home';
}

const ROOT_PATHS = ['/', '/services', '/assistant', '/local', '/profile'];

export default function AppShell() {
  const { t, isRTL } = useI18n();
  const { unreadCount } = useStore();
  const location = useLocation();
  const navigate = useNavigate();

  const titleKey = titleKeyFor(location.pathname);
  const showBack = !ROOT_PATHS.includes(location.pathname);
  const BackIcon = isRTL ? ChevronRight : ChevronLeft;

  return (
    <div className="app-viewport">
      <div className="app-shell" data-component="app-shell">
        <header className="app-bar" data-component="app-bar">
          {showBack ? (
            <button
              type="button"
              className="icon-btn"
              onClick={() => navigate(-1)}
              aria-label={t('common.back')}
            >
              <BackIcon size={20} aria-hidden="true" />
            </button>
          ) : (
            <span className="app-bar__spacer" aria-hidden="true" />
          )}

          <h1 className="app-bar__title">{t(titleKey)}</h1>

          <NavLink to="/notifications" className="icon-btn app-bar__bell" aria-label={t('nav.notifications')}>
            <Bell size={20} aria-hidden="true" />
            {unreadCount > 0 ? (
              <span className="notification-dot" aria-hidden="true" />
            ) : null}
            {unreadCount > 0 ? (
              <span className="sr-only">{`${unreadCount} ${t('notifications.unread')}`}</span>
            ) : null}
          </NavLink>
        </header>

        <main className="app-content" id="main">
          <DemoBanner />
          <Outlet />
        </main>

        <nav className="bottom-nav" data-component="bottom-nav" aria-label={t('nav.home')}>
          {NAV_ITEMS.map((item) => {
            const Icon = item.icon;
            return (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.end}
                className={({ isActive }) => `bottom-nav__item ${isActive ? 'is-active' : ''}`}
              >
                <span className="bottom-nav__pill" aria-hidden="true">
                  <Icon size={22} />
                </span>
                <span className="bottom-nav__label">{t(item.key)}</span>
              </NavLink>
            );
          })}
        </nav>
      </div>
    </div>
  );
}
