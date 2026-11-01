import { useState } from 'react';
import { Check, Info, X } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatCurrency, formatDate } from '../core/format';
import Button from '../core/components/Button';
import { InlineNotice } from '../core/components/StateBlock';
import { useToast } from '../core/components/Toast';

export default function SubscriptionsPage() {
  const { t, pick, lang } = useI18n();
  const toast = useToast();
  const { plans, subscriptions, properties, requestPlan } = useStore();
  const [pendingPlan, setPendingPlan] = useState(null);

  const currentSubscriptions = subscriptions.filter((item) => item.status === 'active');

  const handleRequest = async (planId) => {
    const propertyId = properties[0]?.id;
    if (!propertyId) return;
    setPendingPlan(planId);
    try {
      await requestPlan({ planId, propertyId });
      toast.show(t('subscriptions.requestSuccess'), 'success');
    } catch (error) {
      toast.show(t(error?.i18nKey || 'common.errorBody'), 'error');
    } finally {
      setPendingPlan(null);
    }
  };

  return (
    <div className="screen" data-component="subscriptions-screen">
      <figure className="band-media">
        <img src="https://sc04.alicdn.com/kf/S949981e93ddf4a8590045a3aea02ed14B.jpg" alt="" aria-hidden="true" width="1536" height="1024" />
        <figcaption>
          <h2>{t('subscriptions.title')}</h2>
          <p>{t('subscriptions.subtitle')}</p>
        </figcaption>
      </figure>

      {currentSubscriptions.length ? (
        <section className="block" data-component="current-subscription">
          <div className="card card--accent">
            <div className="card__row">
              <span className="card__label">{t('subscriptions.currentPlan')}</span>
              <span className="chip chip--approved">{t('subscriptions.statusActive')}</span>
            </div>
            {currentSubscriptions.map((subscription) => {
              const plan = plans.find((item) => item.id === subscription.planId);
              const property = properties.find((item) => item.id === subscription.propertyId);
              return (
                <div className="card__row" key={subscription.id}>
                  <span className="card__label">{property ? pick(property.name) : '—'}</span>
                  <span className="card__value">
                    {t(plan?.nameKey || '')}
                    {subscription.renewalDate
                      ? ` · ${t('subscriptions.renewsOn')} ${formatDate(subscription.renewalDate, lang)}`
                      : ''}
                  </span>
                </div>
              );
            })}
          </div>
        </section>
      ) : null}

      <section className="block" data-component="plan-cards">
        {plans.map((plan) => {
          const isCurrent = currentSubscriptions.some((item) => item.planId === plan.id);
          return (
            <article className={`plan ${isCurrent ? 'is-current' : ''}`} key={plan.id}>
              <header className="plan__head">
                <h3 className="plan__name">{t(plan.nameKey)}</h3>
                {isCurrent ? <span className="chip chip--approved">{t('subscriptions.current')}</span> : null}
              </header>

              <p className="plan__price">
                <strong>{formatCurrency(plan.monthlyPrice, lang)}</strong>
                <span> / {t('common.perMonth')}</span>
              </p>
              <p className="price-note">{t('subscriptions.priceNote')}</p>

              <dl className="plan__facts">
                <div>
                  <dt>{t('subscriptions.inspectionFrequency')}</dt>
                  <dd>{t(`subscriptions.plans.${plan.id === 'plan_premium' ? 'premium' : 'basic'}.frequency`)}</dd>
                </div>
                <div>
                  <dt>{t('subscriptions.serviceLimits')}</dt>
                  <dd>{t(`subscriptions.plans.${plan.id === 'plan_premium' ? 'premium' : 'basic'}.limits`)}</dd>
                </div>
                <div>
                  <dt>{t('subscriptions.excludedTitle')}</dt>
                  <dd>{t(`subscriptions.plans.${plan.id === 'plan_premium' ? 'premium' : 'basic'}.excluded`)}</dd>
                </div>
              </dl>

              <ul className="plan__features">
                {plan.featureKeys.map((key) => (
                  <li key={key}>
                    <Check size={16} aria-hidden="true" />
                    {t(key)}
                  </li>
                ))}
                <li className="is-excluded">
                  <X size={16} aria-hidden="true" />
                  {t('subscriptions.plans.premium.excluded')}
                </li>
              </ul>

              <Button
                block
                variant={isCurrent ? 'secondary' : 'primary'}
                disabled={isCurrent}
                loading={pendingPlan === plan.id}
                loadingLabel={t('common.submitting')}
                onClick={() => handleRequest(plan.id)}
              >
                {isCurrent ? t('subscriptions.current') : t('subscriptions.selectPlan')}
              </Button>
            </article>
          );
        })}
      </section>

      <InlineNotice variant="warn" title={t('subscriptions.extraCharges')}>
        {t('subscriptions.noPayment')}
      </InlineNotice>

      <p className="muted-note">
        <Info size={14} aria-hidden="true" /> {t('subscriptions.priceNote')}
      </p>
    </div>
  );
}
