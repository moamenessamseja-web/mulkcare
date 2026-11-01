/**
 * Node ESM resolver hook: lets the plain-node smoke tests import the same
 * extensionless specifiers the Vite bundler accepts (`./errors`, `../mockData`).
 * Resolution only — nothing is transformed, so tests exercise the real source.
 */
import { existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const CANDIDATES = ['.js', '.mjs', '.jsx', '/index.js', '/index.jsx'];

export async function resolve(specifier, context, nextResolve) {
  if (specifier.startsWith('.') || specifier.startsWith('/')) {
    try {
      return await nextResolve(specifier, context);
    } catch (error) {
      const base = new URL(specifier, context.parentURL);
      for (const suffix of CANDIDATES) {
        const candidate = new URL(base.href + suffix);
        if (existsSync(fileURLToPath(candidate))) {
          return nextResolve(candidate.href, context);
        }
      }
      throw error;
    }
  }
  return nextResolve(specifier, context);
}
