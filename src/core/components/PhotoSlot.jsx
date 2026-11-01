import { useId, useRef, useState } from 'react';
import { Camera, X } from 'lucide-react';
import { useI18n } from '../i18n';

/**
 * Photo attach slot.
 *
 * In this build the file picker is real and the preview is real, but nothing is
 * uploaded: cloud storage is not configured. The screen states that plainly, and
 * the submitted request does not carry a local object URL (which would break on
 * the next page load) — so no broken image can ever reach the UI.
 */
export default function PhotoSlot({ index, total, onRemove }) {
  const { t } = useI18n();
  const inputRef = useRef(null);
  const generatedId = useId();
  const [preview, setPreview] = useState(null);

  const handleChange = (event) => {
    const file = event.target.files?.[0];
    if (!file) return;
    const url = URL.createObjectURL(file);
    setPreview({ url, name: file.name });
  };

  const clear = () => {
    if (preview?.url) URL.revokeObjectURL(preview.url);
    setPreview(null);
    if (inputRef.current) inputRef.current.value = '';
    onRemove?.();
  };

  return (
    <div className="photo-slot" data-component="photo-slot">
      <input
        ref={inputRef}
        id={`photo-${generatedId}`}
        type="file"
        accept="image/*"
        className="sr-only"
        onChange={handleChange}
      />
      {preview ? (
        <>
          <img src={preview.url} alt={`${t('services.photoSlotLabel')} ${index}`} />
          <button type="button" className="photo-slot__remove" onClick={clear} aria-label={t('services.removePhoto')}>
            <X size={14} aria-hidden="true" />
          </button>
        </>
      ) : (
        <label className="photo-slot__pick" htmlFor={`photo-${generatedId}`}>
          <Camera size={20} aria-hidden="true" />
          <span className="photo-slot__label">{t('services.addPhoto')}</span>
          <span className="sr-only">{`${t('services.photoSlotLabel')} ${index} / ${total}`}</span>
        </label>
      )}
    </div>
  );
}
