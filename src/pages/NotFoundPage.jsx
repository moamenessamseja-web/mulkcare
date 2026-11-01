import { Link } from 'react-router-dom';
import { Compass } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { EmptyState } from '../core/components/StateBlock';

export default function NotFoundPage() {
  const { t } = useI18n();
  return (
    <div className="screen screen--centered" data-component="not-found">
      <EmptyState
        icon={Compass}
        title={t('notFound.title')}
        body={t('notFound.body')}
        action={
          <Link className="btn btn--primary btn--md" to="/">
            {t('notFound.cta')}
          </Link>
        }
      />
    </div>
  );
}
