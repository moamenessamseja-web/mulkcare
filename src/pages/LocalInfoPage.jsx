import { useMemo, useState } from 'react';
import {
  Bus,
  Map as MapIcon,
  Pill,
  Search,
  ShoppingCart,
  Send,
  Stethoscope,
  Wrench,
  X,
} from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import Button from '../core/components/Button';
import { EmptyState, InlineNotice } from '../core/components/StateBlock';
import { useToast } from '../core/components/Toast';

const CATEGORY_ICONS = {
  pharmacy: Pill,
  clinic: Stethoscope,
  supermarket: ShoppingCart,
  essentials: Wrench,
  transport: Bus,
  places: MapIcon,
};

const CATEGORIES = Object.keys(CATEGORY_ICONS);

export default function LocalInfoPage() {
  const { t } = useI18n();
  const toast = useToast();
  const { properties, user, notifyLocalRecommendationRequest } = useStore();

  const [query, setQuery] = useState('');
  const [active, setActive] = useState(CATEGORIES[0]);
  const [pending, setPending] = useState(false);

  const visible = useMemo(() => {
    const normalised = query.trim();
    if (!normalised) return CATEGORIES;
    return CATEGORIES.filter((key) => {
      const label = t(`local.categories.${key}`);
      const note = t(`local.categoryNotes.${key}`);
      return `${label} ${note}`.toLowerCase().includes(normalised.toLowerCase());
    });
  }, [query, t]);

  const handleRequest = async () => {
    setPending(true);
    try {
      // The request is recorded as a notification so the team has a real,
      // persisted trace of it — it is never presented as a booking.
      await notifyLocalRecommendationRequest({ category: t(`local.categories.${active}`) });
      toast.show(t('local.requestSuccess'), 'success');
    } catch (error) {
      toast.show(t(error?.i18nKey || 'common.errorBody'), 'error');
    } finally {
      setPending(false);
    }
  };

  const ownerProperty = properties[0];

  return (
    <div className="screen" data-component="local-screen">
      <header className="screen-head">
        <h2>{t('local.title')}</h2>
        {ownerProperty ? <p className="muted-note">{t('local.categoryNotes.essentials')}</p> : null}
      </header>

      <div className="search-field">
        <Search size={18} aria-hidden="true" className="search-field__icon" />
        <input
          className="input input--search"
          type="search"
          dir="auto"
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder={t('local.searchPh')}
          aria-label={t('local.searchLabel')}
        />
        {query ? (
          <button
            type="button"
            className="search-field__clear"
            onClick={() => setQuery('')}
            aria-label={t('local.clearSearch')}
          >
            <X size={16} aria-hidden="true" />
          </button>
        ) : null}
      </div>

      <InlineNotice variant="warn" title={t('local.noSourceTitle')}>
        {t('local.noSourceBody')}
      </InlineNotice>

      <section className="block" data-component="local-categories">
        <div className="section-head">
          <h3>{t('local.categoriesTitle')}</h3>
          <span className="section-head__meta">
            {visible.length} {t('local.countLabel')}
          </span>
        </div>

        {visible.length ? (
          <ul className="category-grid">
            {visible.map((key) => {
              const Icon = CATEGORY_ICONS[key];
              return (
                <li key={key}>
                  <button
                    type="button"
                    className={`category-tile ${active === key ? 'is-active' : ''}`}
                    onClick={() => setActive(key)}
                    aria-pressed={active === key}
                  >
                    <span className="category-tile__icon" aria-hidden="true">
                      <Icon size={18} />
                    </span>
                    <span className="category-tile__label">{t(`local.categories.${key}`)}</span>
                  </button>
                </li>
              );
            })}
          </ul>
        ) : (
          <EmptyState
            title={t('local.emptyTitle')}
            body={t('local.emptyBody')}
            action={
              <Button variant="secondary" onClick={() => setQuery('')}>
                {t('local.clearSearch')}
              </Button>
            }
          />
        )}
      </section>

      {visible.length ? (
        <section className="block" data-component="local-category-detail">
          <div className="card">
            <h4 className="card__title">{t(`local.categories.${active}`)}</h4>
            <p className="prose">{t(`local.categoryNotes.${active}`)}</p>
            <p className="muted-note">{user ? t('local.howToBody') : ''}</p>
            <Button loading={pending} loadingLabel={t('common.submitting')} icon={Send} onClick={handleRequest}>
              {t('local.requestRecommendation')}
            </Button>
          </div>
        </section>
      ) : null}

      <section className="block" data-component="local-map">
        <div className="section-head">
          <h3>{t('local.mapTitle')}</h3>
        </div>
        {/* Deliberately not a fake map: a neutral panel with an honest caption. */}
        <div className="map-placeholder" role="img" aria-label={t('local.mapPlaceholder')}>
          <MapIcon size={28} aria-hidden="true" />
          <p>{t('local.mapPlaceholder')}</p>
        </div>
      </section>
    </div>
  );
}
