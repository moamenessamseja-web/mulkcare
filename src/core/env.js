/**
 * Safe access to Vite's compile-time env.
 * Falls back to an empty object so the data/logic modules can also be imported
 * by plain Node (the smoke tests) without a Vite runtime.
 */
export const env =
  typeof import.meta !== 'undefined' && import.meta.env && typeof import.meta.env === 'object'
    ? import.meta.env
    : {};

export default env;
