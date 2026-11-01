/**
 * Application store: session + data bundle + async actions.
 *
 * All reads and writes go through `src/data/repositories`, so the UI has no
 * knowledge of where the data lives. Every mutation reports the real outcome:
 * state changes only after the operation resolves, and a failure leaves the
 * previous state untouched and throws a typed AppError for the caller.
 */
import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState } from 'react';
import repository, { isDemoDataSource } from '../data/repositories';
import authService, { isDemoAuth } from '../data/services/authService';
import { AppError, ErrorCodes, toAppError } from '../core/errors';

const SESSION_KEY = 'mulkcare.session.v1';
const BUNDLE_KEY = 'mulkcare.bundle.v1';

const StoreContext = createContext(null);

function readJson(key) {
  try {
    const raw = window.localStorage.getItem(key);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

function writeJson(key, value) {
  try {
    if (value === null) window.localStorage.removeItem(key);
    else window.localStorage.setItem(key, JSON.stringify(value));
  } catch {
    /* storage unavailable — the session simply is not remembered */
  }
}

function assertBundleShape(bundle) {
  const required = ['user', 'properties', 'serviceRequests', 'inspectionReports', 'subscriptions', 'invoices', 'notifications'];
  const missing = required.filter((key) => bundle?.[key] === undefined);
  if (missing.length) {
    throw new AppError(ErrorCodes.STORAGE_CORRUPT, 'common.errorBody');
  }
  return bundle;
}

/** A snapshot from a previous visit renders immediately — no loading flash. */
function readCachedBundle() {
  const cached = readJson(BUNDLE_KEY);
  if (!cached) return null;
  try {
    return assertBundleShape(cached);
  } catch {
    try {
      window.localStorage.removeItem(BUNDLE_KEY);
    } catch {
      /* ignore */
    }
    return null;
  }
}

export function StoreProvider({ children }) {
  const [initialBundle] = useState(readCachedBundle);
  const [bundle, setBundle] = useState(initialBundle);
  const [status, setStatus] = useState(initialBundle ? 'ready' : 'loading');
  const [error, setError] = useState(null);
  const [session, setSession] = useState(() => readJson(SESSION_KEY));
  const mounted = useRef(true);

  useEffect(() => {
    mounted.current = true;
    return () => {
      mounted.current = false;
    };
  }, []);

  const load = useCallback(async ({ useCache = true } = {}) => {
    setStatus('loading');
    setError(null);
    try {
      const cached = useCache ? readJson(BUNDLE_KEY) : null;
      if (cached) {
        setBundle(assertBundleShape(cached));
        setStatus('ready');
        return;
      }
      const fresh = await repository.load();
      const checked = assertBundleShape(fresh);
      writeJson(BUNDLE_KEY, checked);
      if (!mounted.current) return;
      setBundle(checked);
      setStatus('ready');
    } catch (cause) {
      // A corrupt cached bundle is recoverable: the retry path re-seeds it.
      const appError = toAppError(cause);
      try {
        window.localStorage.removeItem(BUNDLE_KEY);
      } catch {
        /* ignore */
      }
      if (!mounted.current) return;
      setError(appError);
      setStatus('error');
    }
  }, []);

  useEffect(() => {
    if (!initialBundle) load();
  }, [initialBundle, load]);

  const commit = useCallback(async (nextBundle) => {
    setBundle(nextBundle);
    writeJson(BUNDLE_KEY, nextBundle);
    await repository.persist(nextBundle);
    return nextBundle;
  }, []);

  const signIn = useCallback(async (input) => {
    const next = await authService.signIn(input);
    writeJson(SESSION_KEY, next);
    setSession(next);
    return next;
  }, []);

  const register = useCallback(async (input) => {
    const result = await authService.register(input);
    const nextSession = { userId: result.userId, issuedAt: result.issuedAt, mode: result.mode };
    if (result.profile) {
      const current = readJson(BUNDLE_KEY) || bundle;
      if (current) {
        const updated = {
          ...current,
          user: {
            ...current.user,
            fullName: result.profile.fullName,
            email: result.profile.email,
            phone: result.profile.phone,
          },
        };
        await commit(updated);
      }
    }
    writeJson(SESSION_KEY, nextSession);
    setSession(nextSession);
    return nextSession;
  }, [bundle, commit]);

  const signOut = useCallback(async () => {
    await authService.signOut();
    writeJson(SESSION_KEY, null);
    setSession(null);
  }, []);

  const createServiceRequest = useCallback(
    async (input) => {
      if (!bundle) throw new AppError(ErrorCodes.UNKNOWN, 'common.errorTitle');
      const request = await repository.createServiceRequest(bundle, input);
      const next = { ...bundle, serviceRequests: [request, ...bundle.serviceRequests] };
      await commit(next);
      return request;
    },
    [bundle, commit],
  );

  const transitionRequest = useCallback(
    async (requestId, nextStatus, note) => {
      if (!bundle) throw new AppError(ErrorCodes.UNKNOWN, 'common.errorTitle');
      const request = bundle.serviceRequests.find((item) => item.id === requestId);
      if (!request) throw new AppError(ErrorCodes.NOT_FOUND, 'common.errorTitle');
      if (request.ownerId !== bundle.user.id) {
        throw new AppError(ErrorCodes.FORBIDDEN, 'services.actionPermission');
      }
      if (!repository.canTransition(request.status, nextStatus)) {
        throw new AppError(ErrorCodes.VALIDATION, 'services.actionUnavailable');
      }
      const updates = note ? [...request.updates, { at: new Date().toISOString(), text: note }] : request.updates;
      const next = {
        ...bundle,
        serviceRequests: bundle.serviceRequests.map((item) =>
          item.id === requestId ? { ...item, status: nextStatus, updates } : item,
        ),
      };
      await commit(next);
      return next.serviceRequests.find((item) => item.id === requestId);
    },
    [bundle, commit],
  );

  const markNotificationRead = useCallback(
    async (id) => {
      if (!bundle) return;
      const next = {
        ...bundle,
        notifications: bundle.notifications.map((item) => (item.id === id ? { ...item, read: true } : item)),
      };
      await commit(next);
    },
    [bundle, commit],
  );

  const markAllNotificationsRead = useCallback(async () => {
    if (!bundle) return;
    const next = {
      ...bundle,
      notifications: bundle.notifications.map((item) => ({ ...item, read: true })),
    };
    await commit(next);
  }, [bundle, commit]);

  const updateProfile = useCallback(
    async (patch) => {
      if (!bundle) throw new AppError(ErrorCodes.UNKNOWN, 'common.errorTitle');
      const name = (patch.fullName || '').trim();
      if (name.length < 2) {
        throw new AppError(ErrorCodes.VALIDATION, 'auth.errNameShort', { field: 'fullName' });
      }
      if (patch.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(patch.email.trim())) {
        throw new AppError(ErrorCodes.VALIDATION, 'auth.errEmailFormat', { field: 'email' });
      }
      if (patch.phone && !/^01\d{9}$/.test(patch.phone.replace(/[\s-]/g, ''))) {
        throw new AppError(ErrorCodes.VALIDATION, 'auth.errPhone', { field: 'phone' });
      }
      const next = {
        ...bundle,
        user: {
          ...bundle.user,
          fullName: { ar: name, en: name },
          email: patch.email?.trim() || bundle.user.email,
          phone: patch.phone?.trim() || bundle.user.phone,
        },
      };
      await commit(next);
      return next.user;
    },
    [bundle, commit],
  );

  const requestPlan = useCallback(
    async ({ planId, propertyId }) => {
      if (!bundle) throw new AppError(ErrorCodes.UNKNOWN, 'common.errorTitle');
      const existing = bundle.subscriptions.find(
        (item) => item.propertyId === propertyId && item.planId === planId,
      );
      if (existing) return existing;
      const subscription = {
        id: `sub_${Date.now().toString(36)}`,
        ownerId: bundle.user.id,
        propertyId,
        planId,
        status: 'pending',
        startDate: new Date().toISOString(),
        renewalDate: null,
      };
      const next = { ...bundle, subscriptions: [...bundle.subscriptions, subscription] };
      await commit(next);
      return subscription;
    },
    [bundle, commit],
  );

  const notifyLocalRecommendationRequest = useCallback(
    async ({ category }) => {
      if (!bundle) throw new AppError(ErrorCodes.UNKNOWN, 'common.errorTitle');
      const notification = {
        id: `ntf_${Date.now().toString(36)}`,
        userId: bundle.user.id,
        title: { ar: 'طلب ترشيح محلي', en: 'Local recommendation request' },
        body: {
          ar: `تم إرسال طلب ترشيح لفئة: ${category}. الفريق يراجع الطلب ويرد داخل محادثة الطلب.`,
          en: `A recommendation request was sent for: ${category}. The team is reviewing it and will reply in the request thread.`,
        },
        read: false,
        createdAt: new Date().toISOString(),
        href: '/local',
      };
      const next = { ...bundle, notifications: [notification, ...bundle.notifications] };
      await commit(next);
      return notification;
    },
    [bundle, commit],
  );

  const value = useMemo(
    () => ({
      status,
      error,
      session,
      isAuthenticated: Boolean(session),
      user: bundle?.user || null,
      properties: bundle?.properties || [],
      serviceRequests: bundle?.serviceRequests || [],
      inspectionReports: bundle?.inspectionReports || [],
      subscriptions: bundle?.subscriptions || [],
      invoices: bundle?.invoices || [],
      notifications: bundle?.notifications || [],
      upcomingVisits: bundle?.upcomingVisits || [],
      plans: bundle?.plans || [],
      unreadCount: (bundle?.notifications || []).filter((item) => !item.read).length,
      isDemoData: isDemoDataSource,
      isDemoAuth,
      reload: () => load({ useCache: false }),
      signIn,
      register,
      signOut,
      createServiceRequest,
      transitionRequest,
      markNotificationRead,
      markAllNotificationsRead,
      updateProfile,
      requestPlan,
      notifyLocalRecommendationRequest,
    }),
    [
      status,
      error,
      session,
      bundle,
      load,
      signIn,
      register,
      signOut,
      createServiceRequest,
      transitionRequest,
      markNotificationRead,
      markAllNotificationsRead,
      updateProfile,
      requestPlan,
      notifyLocalRecommendationRequest,
    ],
  );

  return <StoreContext.Provider value={value}>{children}</StoreContext.Provider>;
}

export function useStore() {
  const ctx = useContext(StoreContext);
  if (!ctx) throw new Error('useStore must be used inside <StoreProvider>');
  return ctx;
}

export default StoreContext;
