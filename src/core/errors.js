/**
 * Typed application errors.
 *
 * Every failure carries a stable machine code so the UI can decide what to
 * show, plus an optional `i18nKey` for a human-readable localised message.
 * Nothing here ever claims success.
 */

export const ErrorCodes = {
  NOT_CONFIGURED: 'NOT_CONFIGURED',
  NETWORK: 'NETWORK',
  UNAUTHORIZED: 'UNAUTHORIZED',
  FORBIDDEN: 'FORBIDDEN',
  NOT_FOUND: 'NOT_FOUND',
  VALIDATION: 'VALIDATION',
  STORAGE_CORRUPT: 'STORAGE_CORRUPT',
  UNKNOWN: 'UNKNOWN',
};

export class AppError extends Error {
  /**
   * @param {string} code one of ErrorCodes
   * @param {string} [i18nKey] dictionary path for a localised message
   * @param {{ cause?: unknown, errorId?: string, field?: string }} [options]
   */
  constructor(code, i18nKey, options = {}) {
    super(code);
    this.name = 'AppError';
    this.code = code;
    this.i18nKey = i18nKey || null;
    this.cause = options.cause;
    this.field = options.field || null;
    this.errorId = options.errorId || makeErrorId();
  }
}

/** Short, copyable, non-identifying error reference for support. */
export function makeErrorId() {
  return `MC-${Date.now().toString(36).toUpperCase().slice(-6)}`;
}

export function toAppError(error) {
  if (error instanceof AppError) return error;
  return new AppError(ErrorCodes.UNKNOWN, 'common.errorBody', { cause: error });
}
