import { useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import {
  Brush,
  CalendarDays,
  ClipboardList,
  House,
  MapPin,
  Ruler,
  BedDouble,
  Wrench,
} from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatCurrency, formatDate, formatTime } from '../core/format';
import Button from '../core/components/Button';
import { PropertyStatusChip, StatusChip } from '../core/components/StatusChip';
import { EmptyState } from '../core/components/StateBlock';

export default function PropertyDetailsPage() {
  const { propertyId } = useParams();
  const { t, pick, lang } = useI18n();
  const navigate = useNavigate();
  const { properties, serviceRequests, inspectionReports, subscriptions, invoices, plans, upcomingVisits } = useStore();

  const property = properties.find((item) => item.id === propertyId);
  const [activeImage, setActiveImage] = useState(0);

  if (!property) {
    return (
      <div className="screen screen--centered">
        <EmptyState
          title={t('property.notFoundTitle')}
          body={t('property.notFoundBody')}
          action={<Button onClick={() => navigate('/')}>{t('property.notFoundCta')}</Button>}
        />
      </div>
    );
  }

  const subscription = subscriptions.find((item) => item.propertyId === property.id);
  const plan = subscription ? plans.find((item) => item.id === subscription.planId) : null;

  const propertyRequests = serviceRequests
    .filter((item) => item.propertyId === property.id)
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const history = propertyRequests.filter((item) => item.status === 'completed');
  const propertyInvoices = invoices.filter((item) => item.propertyId === property.id);
  const maxInvoice = Math.max(...propertyInvoices.map((item) => item.amount), 1);

  const reports = inspectionReports
    .filter((item) => item.propertyId === property.id)
    .sort((a, b) => new Date(b.inspectionDate) - new Date(a.inspectionDate));
  const lastReport = reports[0];

  const nextVisit = [...upcomingVisits]
    .filter((item) => item.propertyId === property.id)
    .sort((a, b) => new Date(a.date) - new Date(b.date))[0];

  const gallery = property.images?.length ? property.images : ['/assets/images/placeholder.svg'];
  const facts = [
    { key: 'property.type', value: pick(property.propertyType), icon: House },
    { key: 'property.bedrooms', value: String(property.bedrooms), icon: BedDouble },
    { key: 'property.area', value: property.areaSqm ? `${property.areaSqm} m²` : null, icon: Ruler },
  ].filter((fact) => fact.value);

  return (
    <div className="screen screen--flush" data-component="property-details">
      <figure className="hero-media">
        <img src={gallery[activeImage]} alt={t('property.coverAlt')} width="1536" height="1024" />
        <figcaption className="hero-media__overlay">
          <h2 className="hero-media__title">{pick(property.name)}</h2>
          <p className="hero-media__location">
            <MapPin size={14} aria-hidden="true" />
            {pick(property.location)}
          </p>
          <PropertyStatusChip status={property.status} />
        </figcaption>
      </figure>

      {gallery.length > 1 ? (
        <section className="block" data-component="property-gallery">
          <div className="section-head">
            <h3>{t('property.gallery')}</h3>
            <span className="section-head__meta">
              {gallery.length} {t('property.galleryCount')}
            </span>
          </div>
          <div className="thumb-strip">
            {gallery.map((src, index) => (
              <button
                key={src}
                type="button"
                className={`thumb ${index === activeImage ? 'is-active' : ''}`}
                onClick={() => setActiveImage(index)}
                aria-label={`${t('property.galleryOpen')} ${index + 1}`}
                aria-pressed={index === activeImage}
              >
                <img src={src} alt="" loading="lazy" width="96" height="72" />
              </button>
            ))}
          </div>
        </section>
      ) : null}

      <section className="block" data-component="property-facts">
        <div className="section-head">
          <h3>{t('property.specsTitle')}</h3>
        </div>
        <dl className="fact-grid">
          {facts.map((fact) => {
            const Icon = fact.icon;
            return (
              <div className="fact" key={fact.key}>
                <dt>
                  <Icon size={16} aria-hidden="true" />
                  {t(fact.key)}
                </dt>
                <dd>{fact.value}</dd>
              </div>
            );
          })}
          <div className="fact">
            <dt>
              <House size={16} aria-hidden="true" />
              {t('property.status')}
            </dt>
            <dd>{t(`propertyStatus.${property.status}`)}</dd>
          </div>
        </dl>
        <p className="muted-note">{t('property.factsUnavailable')}</p>
      </section>

      <section className="block" data-component="property-subscription">
        <div className="section-head">
          <h3>{t('property.subscriptionTitle')}</h3>
        </div>
        {subscription ? (
          <div className="card">
            <div className="card__row">
              <span className="card__label">{t('property.plan')}</span>
              <span className="card__value">{t(plan?.nameKey || '')}</span>
            </div>
            <div className="card__row">
              <span className="card__label">{t('subscriptions.statusActive')}</span>
              <span className="chip chip--approved">
                {subscription.status === 'active'
                  ? t('subscriptions.statusActive')
                  : t('subscriptions.statusPending')}
              </span>
            </div>
            {subscription.renewalDate ? (
              <div className="card__row">
                <span className="card__label">{t('property.renewal')}</span>
                <span className="card__value">{formatDate(subscription.renewalDate, lang)}</span>
              </div>
            ) : null}
            <Link className="btn btn--secondary btn--sm" to="/subscriptions">
              {t('subscriptions.title')}
            </Link>
          </div>
        ) : (
          <EmptyState
            title={t('property.noSubscription')}
            action={
              <Link className="btn btn--primary btn--sm" to="/subscriptions">
                {t('subscriptions.title')}
              </Link>
            }
          />
        )}
      </section>

      <section className="block" data-component="property-visits">
        <div className="card">
          <div className="card__row">
            <span className="card__label">{t('property.lastInspection')}</span>
            <span className="card__value">
              {lastReport ? formatDate(lastReport.inspectionDate, lang) : t('common.notAvailable')}
            </span>
          </div>
          <div className="card__row">
            <span className="card__label">{t('property.nextVisit')}</span>
            <span className="card__value">
              {nextVisit
                ? `${formatDate(nextVisit.date, lang)} · ${formatTime(nextVisit.date)}`
                : t('property.noneScheduled')}
            </span>
          </div>
        </div>
      </section>

      <section className="block" data-component="property-history">
        <div className="section-head">
          <h3>{t('property.maintenanceHistory')}</h3>
        </div>
        {history.length ? (
          <ul className="row-list">
            {history.map((item) => (
              <li key={item.id}>
                <div className="row row--static">
                  <span className="row__main">
                    <span className="row__title">{t(`services.categories.${item.category}`)}</span>
                    <span className="row__meta">
                      <bdi dir="ltr">{item.reference}</bdi> · {formatDate(item.createdAt, lang)}
                    </span>
                  </span>
                  <span className="row__value">
                    {formatCurrency(item.finalCost ?? item.estimatedCost, lang) || t('common.notAvailable')}
                  </span>
                </div>
              </li>
            ))}
          </ul>
        ) : (
          <EmptyState title={t('property.noHistory')} />
        )}
      </section>

      <section className="block" data-component="property-requests">
        <div className="section-head">
          <h3>{t('property.recentRequests')}</h3>
          <Link className="section-head__link" to="/services">
            {t('common.viewAll')}
          </Link>
        </div>
        {propertyRequests.length ? (
          <ul className="row-list">
            {propertyRequests.slice(0, 4).map((item) => (
              <li key={item.id}>
                <Link to={`/services?request=${item.id}`} className="row">
                  <span className="row__main">
                    <span className="row__title">{t(`services.categories.${item.category}`)}</span>
                    <span className="row__meta">
                      <bdi dir="ltr">{item.reference}</bdi> · {formatDate(item.createdAt, lang)}
                    </span>
                  </span>
                  <StatusChip status={item.status} />
                </Link>
              </li>
            ))}
          </ul>
        ) : (
          <EmptyState title={t('home.noRequestsTitle')} body={t('home.noRequestsBody')} />
        )}
      </section>

      <section className="block" data-component="property-expenses">
        <div className="section-head">
          <h3>{t('property.expensesTitle')}</h3>
        </div>
        {propertyInvoices.length ? (
          <ul className="bar-list" aria-label={t('property.expensesTitle')}>
            {propertyInvoices.map((invoice) => (
              <li key={invoice.id} className="bar-list__item">
                <span className="bar-list__head">
                  <span className="bar-list__label">{pick(invoice.description)}</span>
                  <span className="bar-list__value">{formatCurrency(invoice.amount, lang)}</span>
                </span>
                <span className="bar-list__track" aria-hidden="true">
                  <span
                    className="bar-list__fill"
                    style={{ inlineSize: `${Math.round((invoice.amount / maxInvoice) * 100)}%` }}
                  />
                </span>
                <span className="bar-list__meta">
                  {formatDate(invoice.createdAt, lang)} ·{' '}
                  {invoice.status === 'paid' ? t('profile.paid') : t('profile.unpaid')}
                </span>
              </li>
            ))}
          </ul>
        ) : (
          <EmptyState title={t('property.noHistory')} />
        )}
      </section>

      <div className="action-row" data-component="property-actions">
        <Link className="btn btn--secondary btn--sm" to={`/services?property=${property.id}&category=general`}>
          <Wrench size={18} aria-hidden="true" />
          {t('property.requestMaintenance')}
        </Link>
        <Link className="btn btn--secondary btn--sm" to={`/services?property=${property.id}&category=cleaning`}>
          <Brush size={18} aria-hidden="true" />
          {t('property.requestCleaning')}
        </Link>
        <Link className="btn btn--secondary btn--sm" to={`/services?property=${property.id}&category=general`}>
          <CalendarDays size={18} aria-hidden="true" />
          {t('property.requestInspection')}
        </Link>
        <Link className="btn btn--primary btn--sm" to={lastReport ? `/inspection/${lastReport.id}` : '/services'}>
          <ClipboardList size={18} aria-hidden="true" />
          {t('property.viewReports')}
        </Link>
      </div>
    </div>
  );
}
