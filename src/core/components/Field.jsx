import { forwardRef, useId } from 'react';
import { AlertCircle } from 'lucide-react';
import { useI18n } from '../i18n';

function FieldShell({ id, label, error, helper, required, children, row }) {
  const { t } = useI18n();
  return (
    <div className={`field ${row ? 'field--row' : ''}`} data-component="form-field">
      <label className="field__label" htmlFor={id}>
        {label}
        {required ? <span className="field__required" aria-hidden="true"> *</span> : null}
        {required ? <span className="sr-only">{t('common.required')}</span> : null}
      </label>
      {children}
      {error ? (
        <p className="field__error" id={`${id}-error`} role="alert">
          <AlertCircle size={14} aria-hidden="true" />
          {error}
        </p>
      ) : helper ? (
        <p className="field__helper" id={`${id}-helper`}>
          {helper}
        </p>
      ) : null}
    </div>
  );
}

const TextField = forwardRef(function TextField(
  { label, error, helper, required, forceLtr = false, autoComplete, type = 'text', inputMode, className = '', ...rest },
  ref,
) {
  const generatedId = useId();
  const id = rest.id || `fld-${generatedId}`;
  return (
    <FieldShell id={id} label={label} error={error} helper={helper} required={required}>
      <input
        {...rest}
        ref={ref}
        id={id}
        type={type}
        inputMode={inputMode}
        autoComplete={autoComplete}
        dir={forceLtr ? 'ltr' : 'auto'}
        aria-invalid={error ? 'true' : undefined}
        aria-describedby={error ? `${id}-error` : helper ? `${id}-helper` : undefined}
        className={`input ${error ? 'input--error' : ''} ${forceLtr ? 'input--ltr' : ''} ${className}`}
      />
    </FieldShell>
  );
});

const TextAreaField = forwardRef(function TextAreaField(
  { label, error, helper, required, rows = 5, maxLength = 600, className = '', ...rest },
  ref,
) {
  const generatedId = useId();
  const id = rest.id || `fld-${generatedId}`;
  return (
    <FieldShell id={id} label={label} error={error} helper={helper} required={required}>
      <textarea
        {...rest}
        ref={ref}
        id={id}
        rows={rows}
        maxLength={maxLength}
        dir="auto"
        aria-invalid={error ? 'true' : undefined}
        aria-describedby={error ? `${id}-error` : helper ? `${id}-helper` : undefined}
        className={`input input--textarea ${error ? 'input--error' : ''} ${className}`}
      />
    </FieldShell>
  );
});

const SelectField = forwardRef(function SelectField(
  { label, error, helper, required, options, placeholder, className = '', ...rest },
  ref,
) {
  const generatedId = useId();
  const id = rest.id || `fld-${generatedId}`;
  return (
    <FieldShell id={id} label={label} error={error} helper={helper} required={required}>
      <select
        {...rest}
        ref={ref}
        id={id}
        dir="auto"
        aria-invalid={error ? 'true' : undefined}
        aria-describedby={error ? `${id}-error` : helper ? `${id}-helper` : undefined}
        className={`input input--select ${error ? 'input--error' : ''} ${className}`}
      >
        {placeholder ? (
          <option value="">{placeholder}</option>
        ) : null}
        {options.map((option) => (
          <option key={option.value} value={option.value} disabled={option.disabled}>
            {option.label}
          </option>
        ))}
      </select>
    </FieldShell>
  );
});

export { TextField, TextAreaField, SelectField };
export default FieldShell;
