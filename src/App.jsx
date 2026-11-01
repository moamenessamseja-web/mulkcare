import { BrowserRouter, Navigate, Route, Routes, useLocation } from 'react-router-dom';
import { useI18n } from './core/i18n';
import { useStore } from './app/store';
import AppShell from './app/AppShell';
import Logo from './core/components/Logo';
import { ErrorState } from './core/components/StateBlock';
import AuthPage from './pages/AuthPage';
import HomePage from './pages/HomePage';
import PropertyDetailsPage from './pages/PropertyDetailsPage';
import InspectionReportPage from './pages/InspectionReportPage';
import ServicesPage from './pages/ServicesPage';
import LocalInfoPage from './pages/LocalInfoPage';
import AssistantPage from './pages/AssistantPage';
import SubscriptionsPage from './pages/SubscriptionsPage';
import ProfilePage from './pages/ProfilePage';
import NotificationsPage from './pages/NotificationsPage';
import NotFoundPage from './pages/NotFoundPage';

function BootScreen() {
  const { t } = useI18n();
  return (
    <div className="boot" role="status" aria-live="polite">
      <Logo size={52} />
      <span className="boot__spinner" aria-hidden="true" />
      <p className="boot__label">{t('common.loading')}</p>
    </div>
  );
}

function LoadFailure() {
  const { error, reload } = useStore();
  return (
    <div className="boot boot--error">
      <ErrorState error={error} onRetry={reload} />
    </div>
  );
}

/** Gate for every signed-in screen. Unauthenticated users go to /auth. */
function RequireAuth({ children }) {
  const { status, isAuthenticated } = useStore();
  const location = useLocation();

  if (status === 'loading') return <BootScreen />;
  if (status === 'error') return <LoadFailure />;
  if (!isAuthenticated) return <Navigate to="/auth" replace state={{ from: location.pathname }} />;
  return children;
}

function AuthRoute() {
  const { status, isAuthenticated } = useStore();
  if (status === 'loading') return <BootScreen />;
  if (isAuthenticated) return <Navigate to="/" replace />;
  return <AuthPage />;
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/auth" element={<AuthRoute />} />
        <Route
          element={
            <RequireAuth>
              <AppShell />
            </RequireAuth>
          }
        >
          <Route path="/" element={<HomePage />} />
          <Route path="/property" element={<HomePage />} />
          <Route path="/property/:propertyId" element={<PropertyDetailsPage />} />
          <Route path="/inspection/:reportId" element={<InspectionReportPage />} />
          <Route path="/services" element={<ServicesPage />} />
          <Route path="/local" element={<LocalInfoPage />} />
          <Route path="/assistant" element={<AssistantPage />} />
          <Route path="/subscriptions" element={<SubscriptionsPage />} />
          <Route path="/profile" element={<ProfilePage />} />
          <Route path="/notifications" element={<NotificationsPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
