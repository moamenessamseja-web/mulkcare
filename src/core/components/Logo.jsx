import { useI18n } from '../i18n';

/**
 * MulkCare brand mark — a house shield holding a palm over a wave.
 * Hand-authored SVG so it stays crisp at any size and needs no raster asset.
 */
export function LogoMark({ size = 40, tone = 'brand', title }) {
  const stroke = tone === 'brand' ? 'var(--color-primary)' : 'var(--color-on-brand)';
  const wave = tone === 'brand' ? 'var(--color-secondary)' : 'var(--color-secondary)';
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 48 48"
      role={title ? 'img' : 'presentation'}
      aria-label={title || undefined}
      aria-hidden={title ? undefined : 'true'}
      focusable="false"
    >
      <g fill="none" stroke={stroke} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M24 5.5 L39.5 15.8 V29.8 L24 42.5 L8.5 29.8 V15.8 Z" />
        <path d="M27.6 32 C27.2 28 28 24.5 29.2 21.4" />
        <path d="M29.2 21.4 C26 19.8 23.2 20.3 21.4 22.6" />
        <path d="M29.2 21.4 C32.4 19 35.2 19.6 36.6 22" />
        <path d="M29.2 21.4 C26.6 18.4 27 16 29 14.3" />
        <path d="M29.2 21.4 C31.8 18 34.4 17 36 18.2" />
      </g>
      <path
        d="M12.5 32 C15.3 29.5 18.1 34.1 21.5 31.7 C24.9 29.3 27.5 34.1 30.9 31.1 C32.7 29.5 34.4 29.9 35.8 30.9"
        fill="none"
        stroke={wave}
        strokeWidth="2.2"
        strokeLinecap="round"
      />
    </svg>
  );
}

/** Mark + wordmark + tagline lockup. */
export default function Logo({ size = 44, tone = 'brand', showTagline = true, title }) {
  const { t } = useI18n();
  return (
    <div className={`brand-lockup brand-lockup--${tone}`} data-component="brand-lockup">
      <LogoMark size={size} tone={tone} title={title} />
      <div className="brand-lockup__text">
        <span className="brand-lockup__name">{t('meta.appName')}</span>
        {showTagline ? <span className="brand-lockup__tagline">{t('meta.tagline')}</span> : null}
      </div>
    </div>
  );
}
