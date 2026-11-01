import { Link, useNavigate } from 'react-router-dom';
import {
  ArrowUpRight,
  Brush,
  CalendarDays,
  ClipboardList,
  MapPin,
  TriangleAlert,
  Wrench,
} from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatCurrency, formatDate, formatDateTime, formatTime } from '../core/format';
import Button from '../core/components/Button';
import PropertyCard from '../core/components/PropertyCard';
import { StatusChip } from '../core/components/StatusChip';
import { EmptyState, PropertyCardSkeleton, RowSkeleton } from '../core/components/StateBlock';

function greetingKey() {
  return new Date().getHours() < 12 ? 'home.greetingMorning' : 'home.greetingEvening';
}

export default function HomePage() {
  const { t, pick, lang } = useI18n();
  const navigate = useNavigate();
  const {
    status,
    user,
    properties,
    serviceRequests,
    inspectionReports,
    upcomingVisits,
    invoices,
  } = useStore();

  const loading = status === 'loading';

  const propertyById = (id) => properties.find((item) => item.id === id);
  const openStatuses = ['pending', 'awaiting_approval', 'approved', 'scheduled', 'in_progress'];
  const openRequests = serviceRequests.filter((item) => openStatuses.includes(item.status));
  const awaitingApproval = serviceRequests.filter((item) => item.status === 'awaiting_approval');

  const now = new Date();
  const monthSpend = invoices
    .filter((invoice) => {
      const created = new Date(invoice.createdAt);
      return created.getMonth() === now.getMonth() && created.getFullYear() === now.getFullYear();
    })
    .reduce((sum, invoice) => sum + invoice.amount, 0);

  const recentRequests = [...serviceRequests]
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
    .slice(0, 3);

  const nextVisits = [...upcomingVisits].sort((a, b) => new Date(a.date) - new Date(b.date)).slice(0, 3);
  const latestReports = [...inspectionReports]
    .sort((a, b) => new Date(b.inspectionDate) - new Date(a.inspectionDate))
    .slice(0, 2);

  const quickActions = [
    { key: 'home.qaMaintenance', icon: Wrench, to: '/services?category=general' },
    { key: 'home.qaCleaning', icon: Brush, to: '/services?category=cleaning' },
    { key: 'home.qaInspection', icon: CalendarDays, to: '/services?category=general' },
    { key: 'home.qaReports', icon: ClipboardList, to: latestReports[0] ? `/inspection/${latestReports[0].id}` : '/property' },
  ];

  return (
    <div className="screen" data-component="home-screen">
      <header className="home-head">
        <p className="home-head__greeting">{t(greetingKey())}</p>
        <h2 className="home-head__name">{pick(user?.fullName) || '—'}</h2>
        <p className="home-head__sub">{t('home.subtitle')}</p>
      </header>

      {awaitingApproval.length ? (
        <Link to="/services" className="attention-card" data-component="attention-card">
          <span className="attention-card__icon" aria-hidden="true">
            <TriangleAlert size={20} />
          </span>
          <span className="attention-card__text">
            <strong>{t('home.attentionTitle')}</strong>
            <span>
              {t('home.attentionApproval')} — <bdi dir="ltr">{awaitingApproval[0].reference}</bdi>
            </span>
          </span>
          <ArrowUpRight size={18} aria-hidden="true" />
        </Link>
      ) : null}

      <section className="kpi-row" data-component="kpi-row">
        <article className="kpi">
          <span className="kpi__label">{t('home.propertiesMonitored')}</span>
          <span className="kpi__value">{properties.length}</span>
        </article>
        <article className="kpi">
          <span className="kpi__label">{t('home.openRequests')}</span>
          <span className="kpi__value">{openRequests.length}</span>
        </article>
        <article className="kpi">
          <span className="kpi__label">{t('home.monthSpend')}</span>
          <span className="kpi__value kpi__value--money">{formatCurrency(monthSpend, lang) || formatCurrency(0, lang)}</span>
        </article>
      </section>

      <section className="block" data-component="properties-strip">
        <div className="section-head">
          <h3>{t('home.propertiesTitle')}</h3>
          <span className="section-head__meta">
            {properties.length} {t('home.propertiesCount')}
          </span>
        </div>

        {loading ? (
          <div className="strip">
            <PropertyCardSkeleton />
            <PropertyCardSkeleton />
          </div>
        ) : properties.length ? (
          <div className="strip">
            {properties.map((property) => (
              <PropertyCard key={property.id} property={property} />
            ))}
          </div>
        ) : (
          <EmptyState
            title={t('home.noPropertiesTitle')}
            body={t('home.noPropertiesBody')}
            action={<Button onClick={() => navigate('/services')}>{t('home.noPropertiesCta')}</Button>}
          />
        )}
      </section>

      <section className="block" data-component="quick-actions">
        <div className="section-head">
          <h3>{t('home.quickActionsTitle')}</h3>
        </div>
        <div className="qa-grid">
          {quickActions.map((action) => {
            const Icon = action.icon;
            return (
              <Link key={action.key} to={action.to} className="qa-tile">
                <span className="qa-tile__icon" aria-hidden="true">
                  <Icon size={22} />
                </span>
                <span className="qa-tile__label">{t(action.key)}</span>
              </Link>
            );
          })}
        </div>
      </section>

      <section className="block" data-component="recent-requests">
        <div className="section-head">
          <h3>{t('home.recentRequestsTitle')}</h3>
          <Link className="section-head__link" to="/services">
            {t('common.viewAll')}
          </Link>
        </div>

        {loading ? (
          <RowSkeleton rows={3} />
        ) : recentRequests.length ? (
          <ul className="row-list">
            {recentRequests.map((request) => (
              <li key={request.id}>
                <Link to={`/services?request=${request.id}`} className="row">
                  <span className="row__main">
                    <span className="row__title">{t(`services.categories.${request.category}`)}</span>
                    <span className="row__meta">
                      <bdi dir="ltr">{request.reference}</bdi> · {formatDateTime(request.createdAt, lang)}
                    </span>
                  </span>
                  <StatusChip status={request.status} />
                </Link>
              </li>
            ))}
          </ul>
        ) : (
          <EmptyState
            title={t('home.noRequestsTitle')}
            body={t('home.noRequestsBody')}
            action={<Button onClick={() => navigate('/services')}>{t('home.noRequestsCta')}</Button>}
          />
        )}
      </section>

      <section className="block" data-component="upcoming-visits">
        <div className="section-head">
          <h3>{t('home.upcomingVisitsTitle')}</h3>
        </div>

        {loading ? (
          <RowSkeleton rows={2} />
        ) : nextVisits.length ? (
          <ol className="timeline">
            {nextVisits.map((visit) => {
              const property = propertyById(visit.propertyId);
              return (
                <li key={visit.id} className="timeline__item">
                  <span className="timeline__dot" aria-hidden="true" />
                  <Link to={property ? `/property/${property.id}` : '/'} className="timeline__body">
                    <span className="timeline__title">{pick(visit.type)}</span>
                    <span className="timeline__meta">
                      <MapPin size={13} aria-hidden="true" />
                      {property ? pick(property.name) : '—'} · {formatDate(visit.date, lang)} ·{' '}
                      <bdi dir="ltr">{formatTime(visit.date)}</bdi>
                    </span>
                    <span className="timeline__note">{pick(visit.note)}</span>
                  </Link>
                </li>
              );
            })}
          </ol>
        ) : (
          <EmptyState title={t('home.noVisitsTitle')} body={t('home.noVisitsBody')} />
        )}
      </section>

      <section className="block" data-component="latest-inspections">
        <div className="section-head">
          <h3>{t('home.latestInspectionsTitle')}</h3>
        </div>

        {loading ? (
          <RowSkeleton rows={2} />
        ) : latestReports.length ? (
          <ul className="card-list">
            {latestReports.map((report) => {
              const property = propertyById(report.propertyId);
              return (
                <li key={report.id}>
                  <Link to={`/inspection/${report.id}`} className="report-card">
                    <span className="report-card__head">
                      <span className="report-card__title">{property ? pick(property.name) : '—'}</span>
                      <span className="report-card__score" aria-hidden="true">
                        {report.overall.score}
                      </span>
                    </span>
                    <span className="report-card__meta">
                      <bdi dir="ltr">{report.reference}</bdi> · {formatDate(report.inspectionDate, lang)} ·{' '}
                      {t('inspection.overallCondition')}: {pick(report.overall.label)}
                    </span>
                    <span className="report-card__summary">{pick(report.summary)}</span>
                  </Link>
                </li>
              );
            })}
          </ul>
        ) : (
          <EmptyState
            title={t('home.noInspectionsTitle')}
            body={t('home.noInspectionsBody')}
            action={<Button onClick={() => navigate('/services')}>{t('home.noInspectionsCta')}</Button>}
          />
        )}
      </section>
    </div>
  );
}
