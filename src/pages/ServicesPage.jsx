import { useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { ChevronDown, Send, Wrench } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { formatCurrency, formatDate, formatDateTime, formatTime, todayInputValue } from '../core/format';
import Button from '../core/components/Button';
import ConfirmDialog from '../core/components/Dialog';
import PhotoSlot from '../core/components/PhotoSlot';
import { SelectField, TextAreaField, TextField } from '../core/components/Field';
import { StatusChip } from '../core/components/StatusChip';
import { EmptyState, InlineNotice, RowSkeleton } from '../core/components/StateBlock';
import { useToast } from '../core/components/Toast';

const CATEGORIES = ['general', 'plumbing', 'electrical', 'hvac', 'cleaning', 'pest', 'other'];
const MAX_PHOTOS = 4;

const EMPTY_FORM = { propertyId: '', category: '', description: '', preferredDate: '', preferredTime: '10:00' };

export default function ServicesPage() {
  const { t, pick, lang } = useI18n();
  const toast = useToast();
  const [searchParams] = useSearchParams();
  const {
    status,
    properties,
    serviceRequests,
    createServiceRequest,
    transitionRequest,
  } = useStore();

  const [form, setForm] = useState(EMPTY_FORM);
  const [errors, setErrors] = useState({});
  const [formError, setFormError] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [photoSlots, setPhotoSlots] = useState([0]);
  const [openId, setOpenId] = useState(searchParams.get('request'));
  const [confirm, setConfirm] = useState(null);
  const [actionPending, setActionPending] = useState(false);

  const loading = status === 'loading';

  // Deep links from the dashboard and property screen pre-fill the form.
  useEffect(() => {
    const propertyId = searchParams.get('property');
    const category = searchParams.get('category');
    if (propertyId || category) {
      setForm((current) => ({
        ...current,
        propertyId: propertyId || current.propertyId,
        category: category && CATEGORIES.includes(category) ? category : current.category,
      }));
    }
  }, [searchParams]);

  const propertyOptions = useMemo(
    () => properties.map((property) => ({ value: property.id, label: pick(property.name) })),
    [properties, pick],
  );

  const categoryOptions = useMemo(
    () => CATEGORIES.map((key) => ({ value: key, label: t(`services.categories.${key}`) })),
    [t],
  );

  const sortedRequests = useMemo(
    () => [...serviceRequests].sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt)),
    [serviceRequests],
  );

  const setField = (field) => (event) => {
    const value = event.target.value;
    setForm((current) => ({ ...current, [field]: value }));
    if (errors[field]) setErrors((current) => ({ ...current, [field]: null }));
  };

  const validate = () => {
    const next = {
      propertyId: form.propertyId ? null : 'services.errProperty',
      category: form.category ? null : 'services.errCategory',
      description: form.description.trim().length >= 10 ? null : 'services.errDescription',
      preferredDate: form.preferredDate && form.preferredDate >= todayInputValue() ? null : 'services.errDate',
    };
    setErrors(next);
    return Object.keys(next).filter((key) => next[key]);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const invalid = validate();
    if (invalid.length) {
      setFormError('services.errSubmit');
      const firstField = document.getElementById(`fld-${invalid[0]}`);
      firstField?.focus();
      return;
    }
    setFormError(null);
    setSubmitting(true);
    try {
      const preferredDate = form.preferredDate
        ? new Date(`${form.preferredDate}T${form.preferredTime || '10:00'}:00`).toISOString()
        : null;
      const created = await createServiceRequest({
        propertyId: form.propertyId,
        category: form.category,
        description: form.description,
        preferredDate,
        images: [],
      });
      setForm(EMPTY_FORM);
      setPhotoSlots([0]);
      setOpenId(created.id);
      toast.show(t('services.successSubmit'), 'success');
    } catch (error) {
      setFormError(error?.i18nKey || 'services.errSubmit');
    } finally {
      setSubmitting(false);
    }
  };

  const runTransition = async (requestId, nextStatus, messageKey, note) => {
    setActionPending(true);
    try {
      await transitionRequest(requestId, nextStatus, note);
      toast.show(t(messageKey), 'success');
      setConfirm(null);
    } catch (error) {
      toast.show(t(error?.i18nKey || 'services.actionUnavailable'), 'error');
    } finally {
      setActionPending(false);
    }
  };

  const dialogConfig = {
    approve: {
      title: t('services.approveConfirmTitle'),
      body: t('services.approveConfirmBody'),
      confirmLabel: t('services.approve'),
      run: (id) =>
        runTransition(id, 'approved', 'services.approveSuccess', {
          ar: 'تمت موافقتك على عرض السعر من داخل التطبيق.',
          en: 'You approved the quotation from the app.',
        }),
    },
    reject: {
      title: t('services.rejectConfirmTitle'),
      body: t('services.rejectConfirmBody'),
      confirmLabel: t('services.reject'),
      destructive: true,
      run: (id) =>
        runTransition(id, 'cancelled', 'services.rejectSuccess', {
          ar: 'تم رفض العرض بناءً على قرارك.',
          en: 'The quotation was declined by your decision.',
        }),
    },
    cancel: {
      title: t('services.cancelConfirmTitle'),
      body: t('services.cancelConfirmBody'),
      confirmLabel: t('services.cancelRequest'),
      destructive: true,
      run: (id) =>
        runTransition(id, 'cancelled', 'services.cancelSuccess', {
          ar: 'تم إلغاء الطلب بناءً على طلبك.',
          en: 'The request was cancelled at your request.',
        }),
    },
  };

  return (
    <div className="screen" data-component="services-screen">
      <section className="block" data-component="service-categories">
        <div className="section-head">
          <h3>{t('services.categoriesTitle')}</h3>
        </div>
        <ul className="category-grid">
          {CATEGORIES.map((key) => (
            <li key={key}>
              <button
                type="button"
                className={`category-tile ${form.category === key ? 'is-active' : ''}`}
                onClick={() => {
                  setForm((current) => ({ ...current, category: key }));
                  setErrors((current) => ({ ...current, category: null }));
                }}
                aria-pressed={form.category === key}
              >
                <span className="category-tile__icon" aria-hidden="true">
                  <Wrench size={18} />
                </span>
                <span className="category-tile__label">{t(`services.categories.${key}`)}</span>
              </button>
            </li>
          ))}
        </ul>
      </section>

      <section className="block" data-component="service-request-form">
        <div className="section-head">
          <h3>{t('services.formTitle')}</h3>
        </div>

        {formError ? (
          <div className="banner banner--error" role="alert">
            <div className="banner__content">
              <p className="banner__body">{t(formError)}</p>
            </div>
          </div>
        ) : null}

        <form className="form card" onSubmit={handleSubmit} noValidate>
          <SelectField
            id="fld-propertyId"
            label={t('services.property')}
            placeholder={t('services.propertyPh')}
            value={form.propertyId}
            onChange={setField('propertyId')}
            onBlur={validate}
            options={propertyOptions}
            error={errors.propertyId ? t(errors.propertyId) : null}
            required
          />

          <SelectField
            id="fld-category"
            label={t('services.category')}
            placeholder={t('services.categoryPh')}
            value={form.category}
            onChange={setField('category')}
            onBlur={validate}
            options={categoryOptions}
            error={errors.category ? t(errors.category) : null}
            required
          />

          <TextAreaField
            id="fld-description"
            label={t('services.description')}
            placeholder={t('services.descriptionPh')}
            value={form.description}
            onChange={setField('description')}
            onBlur={validate}
            error={errors.description ? t(errors.description) : null}
            required
          />

          <div className="field">
            <span className="field__label">{t('services.photos')}</span>
            <div className="photo-slots">
              {photoSlots.map((slot, index) => (
                <PhotoSlot
                  key={slot}
                  index={index + 1}
                  total={MAX_PHOTOS}
                  onRemove={() => setPhotoSlots((current) => current.filter((value) => value !== slot))}
                />
              ))}
              {photoSlots.length < MAX_PHOTOS ? (
                <button
                  type="button"
                  className="photo-slot photo-slot--add"
                  onClick={() => setPhotoSlots((current) => [...current, Date.now()])}
                >
                  <span className="photo-slot__label">{t('services.addPhoto')}</span>
                </button>
              ) : null}
            </div>
            <p className="field__helper">{t('services.photosHint')}</p>
          </div>

          <div className="field-row">
            <TextField
              id="fld-preferredDate"
              type="date"
              label={t('services.preferredDate')}
              value={form.preferredDate}
              onChange={setField('preferredDate')}
              onBlur={validate}
              error={errors.preferredDate ? t(errors.preferredDate) : null}
              forceLtr
              min={todayInputValue()}
              required
            />
            <TextField
              id="fld-preferredTime"
              type="time"
              label={t('services.preferredTime')}
              value={form.preferredTime}
              onChange={setField('preferredTime')}
              forceLtr
            />
          </div>

          <InlineNotice variant="info">{t('services.uploadNotice')}</InlineNotice>

          <Button type="submit" block loading={submitting} loadingLabel={t('common.submitting')} icon={Send}>
            {t('services.submitRequest')}
          </Button>
        </form>
      </section>

      <section className="block" data-component="request-tracking">
        <div className="section-head">
          <h3>{t('services.trackingTitle')}</h3>
          <span className="section-head__meta">
            {sortedRequests.length} {t('services.countLabel')}
          </span>
        </div>

        {loading ? (
          <RowSkeleton rows={4} />
        ) : sortedRequests.length ? (
          <ul className="request-list">
            {sortedRequests.map((request) => {
              const property = properties.find((item) => item.id === request.propertyId);
              const isOpen = openId === request.id;
              const canApprove = request.status === 'awaiting_approval';
              const canCancel = ['pending', 'awaiting_approval', 'approved', 'scheduled'].includes(request.status);

              return (
                <li key={request.id} className={`request ${isOpen ? 'is-open' : ''}`}>
                  <button
                    type="button"
                    className="request__head"
                    onClick={() => setOpenId(isOpen ? null : request.id)}
                    aria-expanded={isOpen}
                  >
                    <span className="request__main">
                      <span className="request__title">{t(`services.categories.${request.category}`)}</span>
                      <span className="request__meta">
                        <bdi dir="ltr">{request.reference}</bdi> · {property ? pick(property.name) : '—'}
                      </span>
                    </span>
                    <span className="request__side">
                      <StatusChip status={request.status} />
                      <ChevronDown size={16} aria-hidden="true" className="request__chevron" />
                    </span>
                  </button>

                  {isOpen ? (
                    <div className="request__body">
                      <p className="prose">{pick(request.description)}</p>

                      <dl className="detail-grid">
                        <div>
                          <dt>{t('services.submittedAt')}</dt>
                          <dd>{formatDateTime(request.createdAt, lang)}</dd>
                        </div>
                        <div>
                          <dt>{t('services.appointment')}</dt>
                          <dd>
                            {request.preferredDate
                              ? `${formatDate(request.preferredDate, lang)} · ${formatTime(request.preferredDate)}`
                              : t('services.noAppointment')}
                          </dd>
                        </div>
                        <div>
                          <dt>{t('services.estimate')}</dt>
                          <dd>
                            {request.estimatedCost
                              ? formatCurrency(request.estimatedCost, lang)
                              : t('services.noEstimate')}
                          </dd>
                        </div>
                        {request.finalCost ? (
                          <div>
                            <dt>{t('services.finalCost')}</dt>
                            <dd>{formatCurrency(request.finalCost, lang)}</dd>
                          </div>
                        ) : null}
                      </dl>

                      {request.images?.length ? (
                        <div className="request__photos">
                          {request.images.map((src) => (
                            <img key={src} src={src} alt={t('services.photos')} loading="lazy" />
                          ))}
                        </div>
                      ) : null}

                      <div className="updates">
                        <h4 className="updates__title">{t('services.technicianUpdates')}</h4>
                        {request.updates?.length ? (
                          <ol className="timeline">
                            {request.updates.map((update) => (
                              <li className="timeline__item" key={`${request.id}-${update.at}`}>
                                <span className="timeline__dot" aria-hidden="true" />
                                <div className="timeline__body">
                                  <span className="timeline__title">{pick(update.text)}</span>
                                  <span className="timeline__meta">{formatDateTime(update.at, lang)}</span>
                                </div>
                              </li>
                            ))}
                          </ol>
                        ) : (
                          <p className="muted-note">{t('services.noUpdates')}</p>
                        )}
                      </div>

                      {canApprove || canCancel ? (
                        <div className="request__actions">
                          {canApprove ? (
                            <>
                              <Button onClick={() => setConfirm({ type: 'approve', id: request.id })}>
                                {t('services.approve')}
                              </Button>
                              <Button
                                variant="secondary"
                                onClick={() => setConfirm({ type: 'reject', id: request.id })}
                              >
                                {t('services.reject')}
                              </Button>
                            </>
                          ) : null}
                          {canCancel ? (
                            <Button
                              variant="destructive"
                              onClick={() => setConfirm({ type: 'cancel', id: request.id })}
                            >
                              {t('services.cancelRequest')}
                            </Button>
                          ) : null}
                        </div>
                      ) : (
                        <p className="muted-note">{t('services.actionUnavailable')}</p>
                      )}
                    </div>
                  ) : null}
                </li>
              );
            })}
          </ul>
        ) : (
          <EmptyState title={t('services.emptyTitle')} body={t('services.emptyBody')} />
        )}
      </section>

      <ConfirmDialog
        open={Boolean(confirm)}
        title={confirm ? dialogConfig[confirm.type].title : ''}
        body={confirm ? dialogConfig[confirm.type].body : ''}
        confirmLabel={confirm ? dialogConfig[confirm.type].confirmLabel : ''}
        destructive={Boolean(confirm && dialogConfig[confirm.type].destructive)}
        pending={actionPending}
        onCancel={() => setConfirm(null)}
        onConfirm={() => confirm && dialogConfig[confirm.type].run(confirm.id)}
      />
    </div>
  );
}
