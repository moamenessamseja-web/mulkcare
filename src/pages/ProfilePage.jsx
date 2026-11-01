import { useEffect, useMemo, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import {
  Bell,
  ChevronDown,
  FileText,
  Fuel,
  House,
  Languages,
  LifeBuoy,
  LogOut,
  ShieldCheck,
  Sparkles,
  Wrench,
} from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatCurrency, formatDate } from '../core/format';
import Button from '../core/components/Button';
import ConfirmDialog from '../core/components/Dialog';
import { TextField } from '../core/components/Field';
import { EmptyState, InlineNotice } from '../core/components/StateBlock';
import { useToast } from '../core/components/Toast';

const NOTIFICATION_KEYS = ['visits', 'maintenance', 'invoices', 'marketing'];

export default function ProfilePage() {
  const { t, pick, lang, setLang, toggleLang } = useI18n();
  const toast = useToast();
  const navigate = useNavigate();
  const { user, properties, serviceRequests, invoices, updateProfile, signOut } = useStore();

  const initial = useMemo(
    () => ({
      fullName: pick(user?.fullName),
      email: user?.email || '',
      phone: user?.phone || '',
    }),
    [user, pick],
  );

  const [values, setValues] = useState(initial);
  const [errors, setErrors] = useState({});
  const [saving, setSaving] = useState(false);
  const [openGroup, setOpenGroup] = useState(null);
  const [logoutOpen, setLogoutOpen] = useState(false);
  const [prefs, setPrefs] = useState({ visits: true, maintenance: true, invoices: true, marketing: false });

  useEffect(() => {
    setValues(initial);
  }, [initial]);

  const dirty = values.fullName !== initial.fullName || values.email !== initial.email || values.phone !== initial.phone;

  const setField = (field) => (event) => {
    setValues((current) => ({ ...current, [field]: event.target.value }));
    if (errors[field]) setErrors((current) => ({ ...current, [field]: null }));
  };

  const handleSave = async (event) => {
    event.preventDefault();
    setErrors({});
    setSaving(true);
    try {
      await updateProfile(values);
      toast.show(t('profile.saveSuccess'), 'success');
    } catch (error) {
      if (error?.field) {
        setErrors({ [error.field]: error.i18nKey });
      }
      toast.show(t(error?.i18nKey || 'profile.saveError'), 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleSignOut = async () => {
    await signOut();
    setLogoutOpen(false);
    toast.show(t('profile.logoutSuccess'), 'info');
    navigate('/auth', { replace: true });
  };

  const initials = (pick(user?.fullName) || '؟').trim().charAt(0);

  const groups = [
    {
      id: 'properties',
      icon: House,
      label: t('profile.groupProperties'),
      count: properties.length,
      content: (
        <ul className="row-list row-list--nested">
          {properties.map((property) => (
            <li key={property.id}>
              <Link className="row" to={`/property/${property.id}`}>
                <span className="row__main">
                  <span className="row__title">{pick(property.name)}</span>
                  <span className="row__meta">{pick(property.location)}</span>
                </span>
                <span className="row__value">{t(`propertyStatus.${property.status}`)}</span>
              </Link>
            </li>
          ))}
        </ul>
      ),
    },
    {
      id: 'requests',
      icon: Wrench,
      label: t('profile.groupRequests'),
      count: serviceRequests.length,
      content: serviceRequests.length ? (
        <ul className="row-list row-list--nested">
          {serviceRequests.slice(0, 5).map((request) => (
            <li key={request.id}>
              <Link className="row" to={`/services?request=${request.id}`}>
                <span className="row__main">
                  <span className="row__title">{t(`services.categories.${request.category}`)}</span>
                  <span className="row__meta">
                    <bdi dir="ltr">{request.reference}</bdi> · {formatDate(request.createdAt, lang)}
                  </span>
                </span>
                <span className="row__value">{t(`status.${request.status}`)}</span>
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <EmptyState title={t('profile.noRequests')} />
      ),
    },
    {
      id: 'invoices',
      icon: FileText,
      label: t('profile.groupInvoices'),
      count: invoices.length,
      content: invoices.length ? (
        <ul className="row-list row-list--nested">
          {invoices.map((invoice) => (
            <li key={invoice.id}>
              <div className="row row--static">
                <span className="row__main">
                  <span className="row__title">{pick(invoice.description)}</span>
                  <span className="row__meta">{formatDate(invoice.createdAt, lang)}</span>
                </span>
                <span className="row__value">
                  {formatCurrency(invoice.amount, lang)} ·{' '}
                  {invoice.status === 'paid' ? t('profile.paid') : t('profile.unpaid')}
                </span>
              </div>
            </li>
          ))}
        </ul>
      ) : (
        <EmptyState title={t('profile.noInvoices')} />
      ),
    },
  ];

  return (
    <div className="screen" data-component="profile-screen">
      <figure className="band-media band-media--short">
        <img src="https://sc04.alicdn.com/kf/S949981e93ddf4a8590045a3aea02ed14B.jpg" alt="" aria-hidden="true" width="1536" height="1024" />
      </figure>

      <header className="profile-head">
        <span className="avatar" aria-hidden="true">
          {initials}
        </span>
        <div className="profile-head__text">
          <h2>{pick(user?.fullName) || '—'}</h2>
          <p className="muted-note" dir="ltr">
            {user?.email || '—'}
          </p>
          <p className="muted-note" dir="ltr">
            {user?.phone || '—'}
          </p>
        </div>
        <Button
          variant="secondary"
          size="sm"
          onClick={() => toast.show(t('profile.photoNotice'), 'info')}
        >
          {t('profile.changePhoto')}
        </Button>
      </header>

      {dirty ? (
        <InlineNotice
          variant="info"
          action={
            <Button variant="link" size="sm" onClick={() => setValues(initial)}>
              {t('profile.discard')}
            </Button>
          }
        >
          {t('profile.unsavedWarning')}
        </InlineNotice>
      ) : null}

      <section className="block" data-component="profile-edit">
        <div className="section-head">
          <h3>{t('profile.editTitle')}</h3>
        </div>
        <form className="form card" onSubmit={handleSave} noValidate>
          <TextField
            id="fld-fullName"
            label={t('profile.fullName')}
            value={values.fullName}
            onChange={setField('fullName')}
            error={errors.fullName ? t(errors.fullName) : null}
            autoComplete="name"
            required
          />
          <TextField
            id="fld-email"
            label={t('profile.email')}
            type="email"
            value={values.email}
            onChange={setField('email')}
            error={errors.email ? t(errors.email) : null}
            forceLtr
            autoComplete="email"
          />
          <TextField
            id="fld-phone"
            label={t('profile.phone')}
            value={values.phone}
            onChange={setField('phone')}
            error={errors.phone ? t(errors.phone) : null}
            forceLtr
            inputMode="tel"
            autoComplete="tel"
          />
          <Button type="submit" block loading={saving} loadingLabel={t('common.saving')} disabled={!dirty}>
            {t('profile.saveChanges')}
          </Button>
        </form>
      </section>

      <section className="block" data-component="profile-language">
        <div className="section-head">
          <h3>{t('profile.groupLanguage')}</h3>
        </div>
        <div className="card">
          <div className="card__row">
            <span className="card__label">
              <Languages size={16} aria-hidden="true" /> {t('profile.language')}
            </span>
            <div className="segmented" role="group" aria-label={t('profile.language')}>
              <button
                type="button"
                className={`segmented__item ${lang === 'ar' ? 'is-active' : ''}`}
                onClick={() => setLang('ar')}
                aria-pressed={lang === 'ar'}
              >
                العربية
              </button>
              <button
                type="button"
                className={`segmented__item ${lang === 'en' ? 'is-active' : ''}`}
                onClick={() => setLang('en')}
                aria-pressed={lang === 'en'}
              >
                English
              </button>
            </div>
          </div>
          <p className="muted-note">{t('meta.tagline')}</p>
        </div>
      </section>

      <section className="block" data-component="profile-notifications">
        <div className="section-head">
          <h3>{t('profile.groupNotifications')}</h3>
        </div>
        <div className="card">
          {NOTIFICATION_KEYS.map((key) => (
            <div className="card__row" key={key}>
              <span className="card__label">
                <Bell size={16} aria-hidden="true" /> {t(`profile.notifications.${key}`)}
              </span>
              <button
                type="button"
                role="switch"
                aria-checked={prefs[key]}
                className={`switch ${prefs[key] ? 'is-on' : ''}`}
                onClick={() => setPrefs((current) => ({ ...current, [key]: !current[key] }))}
                aria-label={t(`profile.notifications.${key}`)}
              >
                <span className="switch__knob" aria-hidden="true" />
              </button>
            </div>
          ))}
          <p className="muted-note">{t('profile.notificationsNote')}</p>
        </div>
      </section>

      <section className="block" data-component="profile-groups">
        {groups.map((group) => {
          const Icon = group.icon;
          const isOpen = openGroup === group.id;
          return (
            <div className="accordion" key={group.id}>
              <button
                type="button"
                className="accordion__head"
                onClick={() => setOpenGroup(isOpen ? null : group.id)}
                aria-expanded={isOpen}
              >
                <span className="accordion__label">
                  <Icon size={18} aria-hidden="true" />
                  {group.label}
                </span>
                <span className="accordion__side">
                  <span className="accordion__count">{group.count}</span>
                  <ChevronDown size={16} aria-hidden="true" className={`accordion__chevron ${isOpen ? 'is-open' : ''}`} />
                </span>
              </button>
              {isOpen ? <div className="accordion__body">{group.content}</div> : null}
            </div>
          );
        })}

        <Link className="row row--link" to="/subscriptions">
          <span className="row__main">
            <span className="row__title">
              <Fuel size={18} aria-hidden="true" /> {t('profile.groupSubscriptions')}
            </span>
          </span>
          <ChevronDown size={16} aria-hidden="true" className="row__chevron" />
        </Link>
      </section>

      <section className="block" data-component="profile-help">
        <div className="section-head">
          <h3>{t('profile.groupHelp')}</h3>
        </div>
        <div className="card">
          <p className="card__title">
            <LifeBuoy size={18} aria-hidden="true" /> {t('profile.helpTitle')}
          </p>
          <p className="prose">{t('profile.helpBody')}</p>
          <Link className="btn btn--secondary btn--sm" to="/assistant">
            <Sparkles size={18} aria-hidden="true" />
            {t('profile.openAssistant')}
          </Link>
        </div>

        <div className="card">
          <p className="card__title">
            <ShieldCheck size={18} aria-hidden="true" /> {t('profile.groupPrivacy')}
          </p>
          <p className="prose">{t('profile.privacyBody')}</p>
        </div>
      </section>

      <section className="block" data-component="profile-logout">
        <Button variant="destructive" block icon={LogOut} onClick={() => setLogoutOpen(true)}>
          {t('profile.logout')}
        </Button>
      </section>

      <ConfirmDialog
        open={logoutOpen}
        title={t('profile.logoutConfirmTitle')}
        body={t('profile.logoutConfirmBody')}
        confirmLabel={t('profile.logout')}
        destructive
        onCancel={() => setLogoutOpen(false)}
        onConfirm={handleSignOut}
      />
    </div>
  );
}
