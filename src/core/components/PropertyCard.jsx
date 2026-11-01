import { Link } from 'react-router-dom';
import { MapPin } from 'lucide-react';
import { useI18n } from '../i18n';
import { PropertyStatusChip } from './StatusChip';

/** Horizontal property card used by the dashboard strip and list views. */
export default function PropertyCard({ property, variant = 'strip' }) {
  const { pick } = useI18n();
  const cover = property.images?.[0] || '/assets/images/placeholder.svg';

  return (
    <Link
      to={`/property/${property.id}`}
      className={`property-card property-card--${variant}`}
      data-component="property-card"
    >
      <span className="property-card__media">
        <img src={cover} alt={pick(property.name)} loading="lazy" width="264" height="150" />
      </span>
      <span className="property-card__body">
        <span className="property-card__name">{pick(property.name)}</span>
        <span className="property-card__location">
          <MapPin size={14} aria-hidden="true" />
          {pick(property.location)}
        </span>
        <span className="property-card__footer">
          <PropertyStatusChip status={property.status} />
          <span className="property-card__type">{pick(property.propertyType)}</span>
        </span>
      </span>
    </Link>
  );
}
