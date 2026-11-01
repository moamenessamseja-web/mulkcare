/**
 * Data access layer — the single seam between the UI and its data source.
 *
 * ARCHITECTURE
 * ------------
 * The UI never imports sample data directly. It calls `repository` methods,
 * which always return promises, so swapping the source is a one-line change.
 *
 *   UI  ->  repository (this file)  ->  adapter  ->  source
 *
 * Available adapters:
 *   • `demoAdapter`   (default) — in-memory sample data seeded from
 *                     `src/data/mockData.js`. Clearly labelled as sample data
 *                     everywhere it is shown. No network, no provider.
 *   • `remoteAdapter` — the production adapter. Requires `VITE_API_BASE_URL`
 *                     (a REST backend) to be configured; until then every call
 *                     fails fast with `NOT_CONFIGURED` instead of silently
 *                     pretending to work.
 *
 * Select the adapter with `VITE_DATA_SOURCE` (`demo` | `remote`).
 * See README.md → "Connecting a real backend" for the expected contract,
 * including how to move from REST to Supabase (Auth, Postgres, Storage, RLS).
 */
import {
  demoUser,
  invoices as seedInvoices,
  inspectionReports as seedReports,
  notifications as seedNotifications,
  plans as seedPlans,
  properties as seedProperties,
  serviceRequests as seedRequests,
  subscriptions as seedSubscriptions,
  upcomingVisits as seedVisits,
} from '../mockData';
import { AppError, ErrorCodes } from '../../core/errors';
import { env } from '../../core/env';

const LATENCY_MS = 220;
const wait = (ms = LATENCY_MS) => new Promise((resolve) => setTimeout(resolve, ms));
const clone = (value) => JSON.parse(JSON.stringify(value));

/* ------------------------------------------------------------------ *
 * demoAdapter — sample data only
 * ------------------------------------------------------------------ */

export function createDemoAdapter() {
  return {
    kind: 'demo',

    async fetchBundle() {
      await wait(320);
      return clone({
        user: demoUser,
        properties: seedProperties,
        serviceRequests: seedRequests,
        inspectionReports: seedReports,
        subscriptions: seedSubscriptions,
        invoices: seedInvoices,
        notifications: seedNotifications,
        upcomingVisits: seedVisits,
        plans: seedPlans,
      });
    },

    async saveBundle(bundle) {
      await wait(140);
      return clone(bundle);
    },
  };
}

/* ------------------------------------------------------------------ *
 * remoteAdapter — production REST contract (not configured yet)
 * ------------------------------------------------------------------ */

/** Endpoints the backend must expose for the UI to work unchanged. */
export const REMOTE_CONTRACT = {
  bundle: 'GET /api/v1/me/bundle',
  updateProfile: 'PATCH /api/v1/me',
  createServiceRequest: 'POST /api/v1/properties/:propertyId/service-requests',
  updateServiceRequest: 'PATCH /api/v1/service-requests/:id',
  requestPlan: 'POST /api/v1/subscriptions',
  markNotification: 'PATCH /api/v1/notifications/:id',
  markAllNotifications: 'PATCH /api/v1/notifications/read-all',
};

export function createRemoteAdapter({ baseUrl }) {
  const request = async (path, init) => {
    if (!baseUrl) {
      throw new AppError(ErrorCodes.NOT_CONFIGURED, 'common.errorBody');
    }
    let response;
    try {
      response = await fetch(`${baseUrl}${path}`, {
        headers: { 'Content-Type': 'application/json' },
        ...init,
      });
    } catch (cause) {
      throw new AppError(ErrorCodes.NETWORK, 'common.errorBody', { cause });
    }
    if (response.status === 401) throw new AppError(ErrorCodes.UNAUTHORIZED, 'common.errorBody');
    if (response.status === 403) throw new AppError(ErrorCodes.FORBIDDEN, 'services.actionPermission');
    if (response.status === 404) throw new AppError(ErrorCodes.NOT_FOUND, 'common.errorTitle');
    if (!response.ok) throw new AppError(ErrorCodes.UNKNOWN, 'common.errorBody');
    return response.json();
  };

  return {
    kind: 'remote',
    fetchBundle: () => request(REMOTE_CONTRACT.bundle),
    saveBundle: () => Promise.reject(new AppError(ErrorCodes.NOT_CONFIGURED)),
  };
}

/* ------------------------------------------------------------------ *
 * Adapter selection
 * ------------------------------------------------------------------ */

const dataSource = env.VITE_DATA_SOURCE === 'remote' ? 'remote' : 'demo';
const apiBaseUrl = env.VITE_API_BASE_URL || '';

export const isDemoDataSource = dataSource === 'demo';

const adapter = dataSource === 'remote' ? createRemoteAdapter({ baseUrl: apiBaseUrl }) : createDemoAdapter();

/**
 * The repository the app talks to. Mutations are applied optimistically to the
 * local bundle and then persisted through the adapter; if the adapter fails the
 * caller receives the error and the UI keeps the previous state.
 */
export const repository = {
  kind: adapter.kind,

  load() {
    return adapter.fetchBundle();
  },

  persist(bundle) {
    return adapter.saveBundle(bundle);
  },

  // --- domain-shaped helpers used by the store --------------------------

  createServiceRequest(bundle, input) {
    const property = bundle.properties.find((item) => item.id === input.propertyId);
    if (!property) {
      return Promise.reject(
        new AppError(ErrorCodes.VALIDATION, 'services.errProperty', { field: 'propertyId' }),
      );
    }
    if (!input.category) {
      return Promise.reject(
        new AppError(ErrorCodes.VALIDATION, 'services.errCategory', { field: 'category' }),
      );
    }
    if (!input.description || input.description.trim().length < 10) {
      return Promise.reject(
        new AppError(ErrorCodes.VALIDATION, 'services.errDescription', { field: 'description' }),
      );
    }

    const nextNumber = 10433 + bundle.serviceRequests.filter((r) => r.reference.startsWith('MC-1')).length;
    const request = {
      id: `req_${nextNumber}`,
      reference: `MC-${nextNumber}`,
      propertyId: input.propertyId,
      ownerId: bundle.user.id,
      category: input.category,
      description: { ar: input.description, en: input.description },
      images: input.images || [],
      status: 'pending',
      preferredDate: input.preferredDate || null,
      estimatedCost: null,
      finalCost: null,
      createdAt: new Date().toISOString(),
      updates: [],
    };
    return Promise.resolve(request);
  },

  /**
   * Legal status transitions. Any transition not listed here is rejected, which
   * is what keeps the UI from offering an impossible action.
   */
  transitions: {
    pending: ['awaiting_approval', 'scheduled', 'cancelled'],
    awaiting_approval: ['approved', 'cancelled'],
    approved: ['scheduled', 'cancelled'],
    scheduled: ['in_progress', 'cancelled'],
    in_progress: ['completed'],
    completed: [],
    cancelled: [],
  },

  canTransition(from, to) {
    return (repository.transitions[from] || []).includes(to);
  },
};

export default repository;
