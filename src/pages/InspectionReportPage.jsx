import { useNavigate, useParams } from 'react-router-dom';
import { CalendarDays, Share2, UserRound } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatCurrency, formatDate } from '../core/format';
import Button from '../core/components/Button';
import { InspectionResultBadge } from '../core/components/StatusChip';
import { EmptyState, InlineNotice } from '../core/components/StateBlock';
import { useToast } from '../core/components/Toast';

export default function InspectionReportPage() {
  const { reportId } = useParams();
  const { t, pick, lang } = useI18n();
  const toast = useToast();
  const navigate = useNavigate();
  const { inspectionReports, properties } = useStore();

  const report = inspectionReports.find((item) => item.id === reportId);

  if (!report) {
    return (
      <div className="screen screen--centered">
        <EmptyState
          title={t('inspection.notFoundTitle')}
          body={t('inspection.notFoundBody')}
          action={<Button onClick={() => navigate('/')}>{t('inspection.notFoundCta')}</Button>}
        />
      </div>
    );
  }

  const property = properties.find((item) => item.id === report.propertyId);
  const allItems = report.checklist.flatMap((group) => group.items);
  const counts = allItems.reduce(
    (acc, item) => ({ ...acc, [item.result]: (acc[item.result] || 0) + 1 }),
    { ok: 0, followup: 0, repair: 0 },
  );

  return (
    <div className="screen" data-component="inspection-report">
      <header className="report-head">
        <div className="report-head__top">
          <div>
            <h2 className="report-head__title">{property ? pick(property.name) : '—'}</h2>
            <p className="report-head__meta">
              {t('inspection.reportNo')}: <bdi dir="ltr">{report.reference}</bdi>
            </p>
          </div>
          <div className="score" aria-label={`${t('inspection.overallCondition')} ${report.overall.score}`}>
            <span className="score__value">{report.overall.score}</span>
            <span className="score__label">{pick(report.overall.label)}</span>
          </div>
        </div>

        <dl className="meta-list">
          <div>
            <dt>
              <CalendarDays size={15} aria-hidden="true" />
              {t('inspection.inspectionDate')}
            </dt>
            <dd>{formatDate(report.inspectionDate, lang)}</dd>
          </div>
          <div>
            <dt>
              <UserRound size={15} aria-hidden="true" />
              {t('inspection.inspectedBy')}
            </dt>
            <dd>{pick(report.inspectorName)}</dd>
          </div>
        </dl>

        <p className="report-head__summary">{pick(report.summary)}</p>

        <Button
          variant="secondary"
          size="sm"
          icon={Share2}
          onClick={() => toast.show(t('inspection.shareUnavailable'), 'info')}
        >
          {t('inspection.share')}
        </Button>
      </header>

      <section className="block" data-component="inspection-legend">
        <div className="section-head">
          <h3>{t('inspection.legend')}</h3>
        </div>
        <div className="legend">
          <InspectionResultBadge result="ok" />
          <span className="legend__count">{counts.ok}</span>
          <InspectionResultBadge result="followup" />
          <span className="legend__count">{counts.followup}</span>
          <InspectionResultBadge result="repair" />
          <span className="legend__count">{counts.repair}</span>
        </div>
      </section>

      <section className="block" data-component="inspection-results">
        <div className="section-head">
          <h3>{t('inspection.resultsTitle')}</h3>
          <span className="section-head__meta">
            {allItems.length} {t('inspection.itemResults')}
          </span>
        </div>

        <div className="checklist">
          {report.checklist.map((group) => (
            <article className="checklist__group" key={group.category}>
              <h4 className="checklist__title">{t(`inspection.categories.${group.category}`)}</h4>
              <ul className="checklist__items">
                {group.items.map((item) => (
                  <li key={item.id} className="checklist__item">
                    <span className="checklist__label">{pick(item.label)}</span>
                    <InspectionResultBadge result={item.result} />
                  </li>
                ))}
              </ul>
            </article>
          ))}
        </div>

        <p className="muted-note">{t('inspection.findingsNote')}</p>
      </section>

      <section className="block" data-component="inspection-notes">
        <div className="section-head">
          <h3>{t('inspection.notesTitle')}</h3>
        </div>
        <p className="prose">{pick(report.notes)}</p>
      </section>

      {report.issuePhotos?.length ? (
        <section className="block" data-component="inspection-issue-photos">
          <div className="section-head">
            <h3>{t('inspection.photosTitle')}</h3>
          </div>
          {report.issuePhotos.map((photo) => (
            <div className="issue-photo" key={photo.id}>
              <p className="issue-photo__caption">{pick(photo.caption)}</p>
              <div className="pair">
                <figure className="pair__slot">
                  <img src={photo.before} alt={`${pick(photo.caption)} — ${t('inspection.before')}`} loading="lazy" />
                  <figcaption>{t('inspection.before')}</figcaption>
                </figure>
                {photo.after ? (
                  <figure className="pair__slot">
                    <img src={photo.after} alt={`${pick(photo.caption)} — ${t('inspection.after')}`} loading="lazy" />
                    <figcaption>{t('inspection.after')}</figcaption>
                  </figure>
                ) : (
                  <figure className="pair__slot pair__slot--pending">
                    <span className="pair__placeholder">{t('inspection.after')}</span>
                    <figcaption>{t('inspection.after')}</figcaption>
                  </figure>
                )}
              </div>
            </div>
          ))}
        </section>
      ) : null}

      {report.images?.length ? (
        <section className="block" data-component="inspection-gallery">
          <div className="section-head">
            <h3>{t('property.gallery')}</h3>
            <span className="section-head__meta">
              {report.images.length} {t('inspection.photoCount')}
            </span>
          </div>
          <div className="photo-grid">
            {report.images.map((src) => (
              <img key={src} src={src} alt={t('property.coverAlt')} loading="lazy" />
            ))}
          </div>
        </section>
      ) : null}

      <section className="block" data-component="inspection-recommendations">
        <div className="section-head">
          <h3>{t('inspection.recommendationsTitle')}</h3>
        </div>

        {report.recommendations?.length ? (
          <ul className="rec-list">
            {report.recommendations.map((rec) => (
              <li key={rec.id} className="rec">
                <span className="rec__label">{pick(rec.label)}</span>
                <span className="rec__cost">
                  {rec.estimatedCost === null || rec.estimatedCost === undefined
                    ? t('inspection.costNotProvided')
                    : formatCurrency(rec.estimatedCost, lang)}
                </span>
              </li>
            ))}
          </ul>
        ) : (
          <EmptyState title={t('inspection.noRecommendations')} />
        )}

        <div className="cost-total">
          <span>{t('inspection.estimatedCost')}</span>
          <strong>
            {report.estimatedCostTotal === null || report.estimatedCostTotal === undefined
              ? t('common.notAvailable')
              : formatCurrency(report.estimatedCostTotal, lang)}
          </strong>
        </div>

        {report.estimatedCostTotal === null || report.estimatedCostTotal === undefined ? (
          <InlineNotice variant="warn">{t('inspection.costNotProvided')}</InlineNotice>
        ) : (
          <p className="muted-note">{t('inspection.costProvided')}</p>
        )}
      </section>
    </div>
  );
}
