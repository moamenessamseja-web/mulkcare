import { forwardRef } from 'react';

/**
 * The single button primitive.
 *
 * `loading` keeps the button's width and swaps the label for a spinner, so the
 * layout never jumps. `disabled` styling is real (`aria-disabled` + no handler)
 * rather than a cosmetic class.
 */
const Button = forwardRef(function Button(
  {
    children,
    variant = 'primary',
    size = 'md',
    block = false,
    loading = false,
    loadingLabel,
    icon: Icon = null,
    iconEnd: IconEnd = null,
    type = 'button',
    className = '',
    disabled = false,
    ...rest
  },
  ref,
) {
  const isDisabled = disabled || loading;
  const classes = [
    'btn',
    `btn--${variant}`,
    `btn--${size}`,
    block ? 'btn--block' : '',
    loading ? 'is-loading' : '',
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <button
      type={type}
      ref={ref}
      className={classes}
      disabled={isDisabled}
      aria-busy={loading || undefined}
      {...rest}
    >
      {loading ? <span className="btn__spinner" aria-hidden="true" /> : null}
      <span className="btn__label">
        {loading && loadingLabel ? loadingLabel : children}
        {Icon && !loading ? <Icon size={18} aria-hidden="true" className="btn__icon" /> : null}
        {IconEnd && !loading ? <IconEnd size={18} aria-hidden="true" className="btn__icon btn__icon--end" /> : null}
      </span>
    </button>
  );
});

export default Button;
