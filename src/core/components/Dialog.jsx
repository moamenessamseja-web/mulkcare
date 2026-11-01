import { useEffect, useRef } from 'react';
import { useI18n } from '../i18n';
import Button from './Button';

/**
 * Confirmation dialog for destructive or irreversible actions.
 * Focus moves in on open, Escape closes, and the backdrop is a labelled button.
 */
export default function ConfirmDialog({
  open,
  title,
  body,
  confirmLabel,
  cancelLabel,
  destructive = false,
  pending = false,
  onConfirm,
  onCancel,
}) {
  const { t } = useI18n();
  const panelRef = useRef(null);
  const confirmRef = useRef(null);

  useEffect(() => {
    if (!open) return undefined;
    const previouslyFocused = document.activeElement;
    confirmRef.current?.focus();

    const onKeyDown = (event) => {
      if (event.key === 'Escape') {
        event.stopPropagation();
        onCancel?.();
      }
      if (event.key === 'Tab' && panelRef.current) {
        const focusable = panelRef.current.querySelectorAll('button, [href], input, select, textarea');
        if (!focusable.length) return;
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (event.shiftKey && document.activeElement === first) {
          event.preventDefault();
          last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
          event.preventDefault();
          first.focus();
        }
      }
    };

    document.addEventListener('keydown', onKeyDown, true);
    return () => {
      document.removeEventListener('keydown', onKeyDown, true);
      if (previouslyFocused instanceof HTMLElement) previouslyFocused.focus();
    };
  }, [open, onCancel]);

  if (!open) return null;

  return (
    <div className="dialog-layer" data-component="confirm-dialog">
      <button type="button" className="dialog-layer__scrim" aria-label={t('common.close')} onClick={onCancel} />
      <div className="dialog" role="alertdialog" aria-modal="true" aria-labelledby="dialog-title" ref={panelRef}>
        <h2 className="dialog__title" id="dialog-title">
          {title}
        </h2>
        {body ? <p className="dialog__body">{body}</p> : null}
        <div className="dialog__actions">
          <Button variant="secondary" onClick={onCancel} disabled={pending}>
            {cancelLabel || t('common.cancel')}
          </Button>
          <Button
            ref={confirmRef}
            variant={destructive ? 'destructive' : 'primary'}
            onClick={onConfirm}
            loading={pending}
            loadingLabel={t('common.pendingSave')}
          >
            {confirmLabel || t('common.confirm')}
          </Button>
        </div>
      </div>
    </div>
  );
}
