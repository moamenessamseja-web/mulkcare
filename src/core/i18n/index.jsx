import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import ar from './ar';
import en from './en';

const DICTS = { ar, en };
const STORAGE_KEY = 'mulkcare.lang.v1';

const I18nContext = createContext(null);

function resolvePath(dict, path) {
  return path
    .split('.')
    .reduce((acc, part) => (acc && typeof acc === 'object' ? acc[part] : undefined), dict);
}

/**
 * Language provider. Arabic (RTL) is the default build language; English (LTR)
 * is a full alternate. Sets `lang` and `dir` on the document root so logical CSS
 * mirrors the whole app with no layout edits.
 */
export function LanguageProvider({ children }) {
  const [lang, setLangState] = useState(() => {
    try {
      const saved = window.localStorage.getItem(STORAGE_KEY);
      if (saved === 'ar' || saved === 'en') return saved;
    } catch {
      /* storage unavailable — fall through to the default */
    }
    return 'ar';
  });

  useEffect(() => {
    document.documentElement.lang = lang;
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
    try {
      window.localStorage.setItem(STORAGE_KEY, lang);
    } catch {
      /* storage unavailable — language simply is not remembered */
    }
  }, [lang]);

  const setLang = useCallback((next) => setLangState(next === 'en' ? 'en' : 'ar'), []);
  const toggleLang = useCallback(() => setLangState((current) => (current === 'ar' ? 'en' : 'ar')), []);

  const value = useMemo(() => {
    const dict = DICTS[lang] || ar;

    /** Translate a dotted dictionary path. */
    const t = (path) => {
      const found = resolvePath(dict, path);
      if (typeof found === 'string') return found;
      if (import.meta.env.DEV) {
        // eslint-disable-next-line no-console
        console.warn(`[i18n] missing key: ${path} (${lang})`);
      }
      return path;
    };

    /** Pick the active language out of a bilingual `{ ar, en }` content value. */
    const pick = (value) => {
      if (value === null || value === undefined) return '';
      if (typeof value === 'string') return value;
      return value[lang] ?? value.ar ?? value.en ?? '';
    };

    return {
      lang,
      dir: lang === 'ar' ? 'rtl' : 'ltr',
      isRTL: lang === 'ar',
      setLang,
      toggleLang,
      t,
      pick,
    };
  }, [lang, setLang, toggleLang]);

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n() {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error('useI18n must be used inside <LanguageProvider>');
  return ctx;
}

export default I18nContext;
