import {
  Ban,
  CalendarClock,
  CheckCircle2,
  CircleDashed,
  Hourglass,
  KeyRound,
  ShieldCheck,
  TriangleAlert,
  Wrench,
  XCircle,
  Home,
} from 'lucide-react';
import { useI18n } from '../i18n';

const STATUS_META = {
  pending: { icon: CircleDashed, tone: 'pending' },
  awaiting_approval: { icon: Hourglass, tone: 'awaiting' },
  approved: { icon: ShieldCheck, tone: 'approved' },
  scheduled: { icon: CalendarClock, tone: 'scheduled' },
  in_progress: { icon: Wrench, tone: 'progress' },
  completed: { icon: CheckCircle2, tone: 'completed' },
  cancelled: { icon: Ban, tone: 'cancelled' },
};

/** Request status: always icon + label + colour, never colour alone. */
export function StatusChip({ status, className = '' }) {
  const { t } = useI18n();
  const meta = STATUS_META[status] || STATUS_META.pending;
  const Icon = meta.icon;
  return (
    <span className={`chip chip--${meta.tone} ${className}`} data-status={status}>
      <Icon size={14} aria-hidden="true" />
      <span>{t(`status.${status}`)}</span>
    </span>
  );
}

const PROPERTY_META = {
  occupied: { icon: KeyRound, tone: 'approved' },
  vacant: { icon: Home, tone: 'pending' },
  maintenance: { icon: Wrench, tone: 'progress' },
};

export function PropertyStatusChip({ status }) {
  const { t } = useI18n();
  const meta = PROPERTY_META[status] || PROPERTY_META.vacant;
  const Icon = meta.icon;
  return (
    <span className={`chip chip--${meta.tone}`} data-property-status={status}>
      <Icon size={14} aria-hidden="true" />
      <span>{t(`propertyStatus.${status}`)}</span>
    </span>
  );
}

const RESULT_META = {
  ok: { icon: CheckCircle2, tone: 'result-ok' },
  followup: { icon: TriangleAlert, tone: 'result-followup' },
  repair: { icon: XCircle, tone: 'result-repair' },
};

export function InspectionResultBadge({ result }) {
  const { t } = useI18n();
  const meta = RESULT_META[result] || RESULT_META.ok;
  const Icon = meta.icon;
  return (
    <span className={`result-badge result-badge--${meta.tone}`} data-result={result}>
      <Icon size={14} aria-hidden="true" />
      <span>{t(`inspectionResult.${result}`)}</span>
    </span>
  );
}

export const InspectionResultLegend = InspectionResultBadge;
export default StatusChip;
