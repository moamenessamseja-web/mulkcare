import { Construction, FileSearch, Inbox, RefreshCw, TriangleAlert } from 'lucide-react';
import { useI18n } from '../i18n';
import Button from './Button';

/** Empty collection / first-use / no-match state. Always has an explanation. */
export function EmptyState({ icon: Icon = Inbox, title, body, action }) {
  return (
    <div className="state-block" data-component="empty-state">
      <span className="state-block__icon" aria-hidden="true">
        <Icon size={26} />
      </span>
      <h3 className="state-block__title">{title}</h3>
      {body ? <p className="state-block__body">{body}</p> : null}
      {action ? <div className="state-block__action">{action}</div> : null}
    </div>
  );
}

export function NoMatchState({ title, body, action }) {
  return <EmptyState icon={FileSearch} title={title} body={body} action={action} />;
}

/** Error state with an actionable retry. Never renders while data is valid. */
export function ErrorState({ error, onRetry, retrying = false }) {
  const { t } = useI18n();
  return (
    <div className="banner banner--error" data-component="error-state" role="alert">
      <span className="banner__icon" aria-hidden="true">
        <TriangleAlert size={20} />
      </span>
      <div className="banner__content">
        <p className="banner__title">{t('common.errorTitle')}</p>
        <p className="banner__body">{error?.i18nKey ? t(error.i18nKey) : t('common.errorBody')}</p>
        <p className="banner__meta">
          {t('common.errorId')}: <bdi dir="ltr">{error?.errorId || '—'}</bdi>
        </p>
      </div>
      {onRetry ? (
        <Button variant="secondary" size="sm" icon={RefreshCw} onClick={onRetry} loading={retrying} loadingLabel={t('common.loading')}>
          {t('common.retry')}
        </Button>
      ) : null}
    </div>
  );
}

export function InlineNotice({ variant = 'info', title, children, action }) {
  const Icon = variant === 'warn' ? TriangleAlert : Construction;
  return (
    <div className={`banner banner--${variant}`} data-component="inline-notice">
      <span className="banner__icon" aria-hidden="true">
        <Icon size={18} />
      </span>
      <div className="banner__content">
        {title ? <p className="banner__title">{title}</p> : null}
        {children ? <p className="banner__body">{children}</p> : null}
      </div>
      {action}
    </div>
  );
}
