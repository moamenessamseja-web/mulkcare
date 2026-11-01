import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState } from 'react';
import { CheckCircle2, Info, X, XCircle } from 'lucide-react';
import { useI18n } from '../i18n';

const ToastContext = createContext(null);

const ICONS = {
  success: CheckCircle2,
  error: XCircle,
  info: Info,
};

/** One fixed toast position for the whole app; announced but never focus-stealing. */
export function ToastProvider({ children }) {
  const { t } = useI18n();
  const [toast, setToast] = useState(null);
  const timer = useRef(null);

  const dismiss = useCallback(() => {
    if (timer.current) window.clearTimeout(timer.current);
    setToast(null);
  }, []);

  const show = useCallback(
    (message, variant = 'info') => {
      if (timer.current) window.clearTimeout(timer.current);
      setToast({ message, variant, id: Date.now() });
      timer.current = window.setTimeout(() => setToast(null), 6000);
    },
    [],
  );

  useEffect(() => () => {
    if (timer.current) window.clearTimeout(timer.current);
  }, []);

  const value = useMemo(() => ({ show, dismiss }), [show, dismiss]);
  const Icon = toast ? ICONS[toast.variant] || Info : Info;

  return (
    <ToastContext.Provider value={value}>
      {children}
      {toast ? (
        <div className="toast-region">
          <div className="toast" data-component="toast" role="status" aria-live="polite">
            <Icon size={18} aria-hidden="true" className="toast__icon" />
            <p className="toast__message">{toast.message}</p>
            <button type="button" className="toast__close" onClick={dismiss} aria-label={t('common.close')}>
              <X size={16} aria-hidden="true" />
            </button>
          </div>
        </div>
      ) : null}
    </ToastContext.Provider>
  );
}

export function useToast() {
  const ctx = useContext(ToastContext);
  if (!ctx) throw new Error('useToast must be used inside <ToastProvider>');
  return ctx;
}

export default ToastContext;
