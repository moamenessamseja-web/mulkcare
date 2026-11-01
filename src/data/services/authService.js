/**
 * Authentication service.
 *
 * DEMO MODE (default): there is no authentication server. Sign-in accepts the
 * documented demo account only, and registration creates a local session.
 * Passwords are never written to storage, never logged and never transmitted —
 * they exist only inside the function call that validates them.
 *
 * PRODUCTION MODE: when `VITE_AUTH_MODE=remote` and `VITE_API_BASE_URL` are
 * configured, the same interface should call the backend's auth endpoints and
 * return the session shape below. See README.md → "Connecting a real backend".
 */
import { AppError, ErrorCodes } from '../../core/errors';
import { env } from '../../core/env';
import { demoCredentials, demoUser } from '../mockData';

const authMode = env.VITE_AUTH_MODE === 'remote' ? 'remote' : 'demo';

export const isDemoAuth = authMode === 'demo';

const EXPECTED_SESSION = {
  userId: 'string',
  issuedAt: 'ISO date string',
  mode: 'demo | remote',
};

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

function looksLikeEmail(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim());
}

function looksLikeEgyptianPhone(value) {
  return /^01\d{9}$/.test(value.replace(/[\s-]/g, ''));
}

/** Field-level validation shared by sign-in and registration forms. */
export function validateIdentifier(value) {
  const trimmed = (value || '').trim();
  if (!trimmed) return 'auth.errRequired';
  if (trimmed.includes('@')) {
    return looksLikeEmail(trimmed) ? null : 'auth.errEmailFormat';
  }
  return looksLikeEgyptianPhone(trimmed) ? null : 'auth.errPhone';
}

export function validatePassword(value) {
  if (!value) return 'auth.errRequired';
  return value.length >= demoCredentials.minPasswordLength ? null : 'auth.errPasswordLength';
}

export function validateFullName(value) {
  const trimmed = (value || '').trim();
  if (!trimmed) return 'auth.errRequired';
  return trimmed.length >= 2 ? null : 'auth.errNameShort';
}

export function validateConfirmPassword(password, confirmation) {
  if (!confirmation) return 'auth.errRequired';
  return password === confirmation ? null : 'auth.errPasswordMatch';
}

export const authService = {
  mode: authMode,
  expectedSession: EXPECTED_SESSION,

  /**
   * @param {{ identifier: string, password: string }} input
   * @returns {Promise<{ userId: string, issuedAt: string, mode: string }>}
   */
  async signIn({ identifier, password }) {
    const identifierError = validateIdentifier(identifier);
    if (identifierError) {
      throw new AppError(ErrorCodes.VALIDATION, identifierError, { field: 'identifier' });
    }
    const passwordError = validatePassword(password);
    if (passwordError) {
      throw new AppError(ErrorCodes.VALIDATION, passwordError, { field: 'password' });
    }

    if (authMode === 'remote') {
      // No backend is configured in this build, so we never fake a session.
      throw new AppError(ErrorCodes.NOT_CONFIGURED, 'auth.errAuthUnavailable');
    }

    await wait(520);

    const accepted = identifier.trim().toLowerCase() === demoCredentials.email;
    if (!accepted) {
      throw new AppError(ErrorCodes.UNAUTHORIZED, 'auth.errCredentials');
    }

    // The password itself is deliberately not part of the returned session.
    return { userId: demoUser.id, issuedAt: new Date().toISOString(), mode: 'demo' };
  },

  /**
   * @param {{ fullName: string, email: string, phone: string, password: string, confirmPassword: string }} input
   */
  async register(input) {
    const errors = {
      fullName: validateFullName(input.fullName),
      email: looksLikeEmail(input.email || '') ? null : 'auth.errEmailFormat',
      phone: looksLikeEgyptianPhone(input.phone || '') ? null : 'auth.errPhone',
      password: validatePassword(input.password),
      confirmPassword: validateConfirmPassword(input.password, input.confirmPassword),
    };
    const firstError = Object.entries(errors).find(([, value]) => value);
    if (firstError) {
      throw new AppError(ErrorCodes.VALIDATION, firstError[1], { field: firstError[0] });
    }

    if (authMode === 'remote') {
      throw new AppError(ErrorCodes.NOT_CONFIGURED, 'auth.errAuthUnavailable');
    }

    await wait(620);
    return {
      userId: demoUser.id,
      issuedAt: new Date().toISOString(),
      mode: 'demo',
      profile: {
        fullName: { ar: input.fullName, en: input.fullName },
        email: input.email,
        phone: input.phone,
      },
    };
  },

  async signOut() {
    await wait(160);
    return true;
  },
};

export default authService;
