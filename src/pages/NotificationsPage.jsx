import { Link } from 'react-router-dom';
import { BellRing, Check } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatRelative } from '../core/format';
import Button from '../core/components/Button';
import { EmptyState, RowSkeleton } from '../core/components/StateBlock';

export default function NotificationsPage() {
  const { t, pick, lang } = useI18n();
  const { status, notifications, markNotificationRead, markAllNotificationsRead } = useStore();

  const loading = status === 'loading';
  const unread = notifications.filter((item) => !item.read).length;

  return (
    <div className="screen" data-component="notifications-screen">
      <div className="section-head">
        <h3>{t('notifications.title')}</h3>
        {unread ? (
          <Button variant="link" size="sm" onClick={markAllNotificationsRead}>
            {t('notifications.markAllRead')}
          </Button>
        ) : null}
      </div>

      {loading ? (
        <RowSkeleton rows={4} />
      ) : notifications.length ? (
        <ul className="row-list">
          {notifications.map((item) => (
            <li key={item.id} className={item.read ? 'is-read' : ''}>
              <div className="row row--static">
                <span className={`row__dot ${item.read ? '' : 'is-unread'}`} aria-hidden="true" />
                <span className="row__main">
                  <span className="row__title">{pick(item.title)}</span>
                  <span className="row__meta">{pick(item.body)}</span>
                  <span className="row__meta row__meta--muted">
                    {formatRelative(item.createdAt, lang)} ·{' '}
                    {item.read ? t('notifications.read') : t('notifications.unread')}
                  </span>
                  <span className="row__actions">
                    {item.href ? (
                      <Link className="btn btn--link btn--sm" to={item.href}>
                        {t('common.viewAll')}
                      </Link>
                    ) : null}
                    {item.read ? null : (
                      <Button
                        variant="link"
                        size="sm"
                        icon={Check}
                        onClick={() => markNotificationRead(item.id)}
                      >
                        {t('notifications.markRead')}
                      </Button>
                    )}
                  </span>
                </span>
              </div>
            </li>
          ))}
        </ul>
      ) : (
        <EmptyState icon={BellRing} title={t('notifications.emptyTitle')} body={t('notifications.emptyBody')} />
      )}
    </div>
  );
}
