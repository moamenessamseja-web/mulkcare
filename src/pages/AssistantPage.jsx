import { useEffect, useRef, useState } from 'react';
import { Info, Paperclip, RotateCcw, Send, Sparkles, Trash2 } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { aiService, isDemoAssistant } from '../data/services/aiService';
import Button from '../core/components/Button';
import ConfirmDialog from '../core/components/Dialog';
import { EmptyState } from '../core/components/StateBlock';
import { useToast } from '../core/components/Toast';
import { formatTime } from '../core/format';

/**
 * Chat state machine per message: 'sent' (user) -> 'typing' -> 'done' | 'failed'.
 * A failed message keeps its text and offers a real retry.
 */
export default function AssistantPage() {
  const { t, lang } = useI18n();
  const toast = useToast();
  const [messages, setMessages] = useState([]);
  const [draft, setDraft] = useState('');
  const [busy, setBusy] = useState(false);
  const [conversationId, setConversationId] = useState(null);
  const [clearOpen, setClearOpen] = useState(false);
  const threadRef = useRef(null);

  useEffect(() => {
    if (threadRef.current) {
      threadRef.current.scrollTop = threadRef.current.scrollHeight;
    }
  }, [messages, busy]);

  const ask = async (text, replaceId = null) => {
    const trimmed = text.trim();
    if (!trimmed || busy) return;

    const userMessage = {
      id: replaceId || `m_${Date.now()}`,
      role: 'user',
      text: trimmed,
      at: new Date().toISOString(),
    };

    setMessages((current) =>
      replaceId
        ? current.map((item) => (item.id === replaceId ? userMessage : item))
        : [...current, userMessage],
    );
    setDraft('');
    setBusy(true);

    try {
      const result = await aiService.sendMessage({ conversationId, message: trimmed });
      setConversationId(result.conversationId);
      setMessages((current) => [
        ...current.filter((item) => item.id !== `${userMessage.id}-reply`),
        {
          id: `${userMessage.id}-reply`,
          role: 'assistant',
          text: result.replyText || t(result.replyKey),
          at: new Date().toISOString(),
        },
      ]);
    } catch (error) {
      setMessages((current) => [
        ...current,
        {
          id: `${userMessage.id}-failed`,
          role: 'failed',
          text: t(error?.i18nKey || 'assistant.failed'),
          retryText: trimmed,
          at: new Date().toISOString(),
        },
      ]);
    } finally {
      setBusy(false);
    }
  };

  const clearChat = () => {
    setMessages([]);
    setConversationId(null);
    setClearOpen(false);
    toast.show(t('assistant.cleared'), 'info');
  };

  return (
    <div className="assistant" data-component="assistant-screen">
      <header className="assistant__head">
        <div className="assistant__identity">
          <span className="assistant__avatar" aria-hidden="true">
            <Sparkles size={18} />
          </span>
          <div>
            <h2 className="assistant__name">{t('assistant.assistantName')}</h2>
            <p className="assistant__sub">{t('assistant.subtitle')}</p>
          </div>
        </div>
        <div className="assistant__tools">
          {isDemoAssistant ? <span className="demo-chip">{t('assistant.demoBadge')}</span> : null}
          {messages.length ? (
            <button
              type="button"
              className="icon-btn"
              onClick={() => setClearOpen(true)}
              aria-label={t('assistant.clearChat')}
            >
              <Trash2 size={18} aria-hidden="true" />
            </button>
          ) : null}
        </div>
      </header>

      <div className="banner banner--warn assistant__notice" role="status">
        <span className="banner__icon" aria-hidden="true">
          <Info size={18} />
        </span>
        <div className="banner__content">
          <p className="banner__body">{t('assistant.demoNotice')}</p>
        </div>
      </div>

      <div className="assistant__thread" ref={threadRef} role="log" aria-live="polite" aria-label={t('assistant.historyTitle')}>
        {messages.length === 0 ? (
          <EmptyState
            icon={Sparkles}
            title={t('assistant.emptyTitle')}
            body={t('assistant.emptyBody')}
            action={
              <div className="chip-row">
                {aiService.suggestedQuestionKeys.map((key) => (
                  <button key={key} type="button" className="suggest-chip" onClick={() => ask(t(key))}>
                    {t(key)}
                  </button>
                ))}
              </div>
            }
          />
        ) : (
          <ul className="bubbles">
            {messages.map((message) => {
              if (message.role === 'failed') {
                return (
                  <li key={message.id} className="bubble-row bubble-row--failed">
                    <div className="bubble bubble--failed" role="alert">
                      <p>{message.text}</p>
                      <Button
                        variant="link"
                        size="sm"
                        icon={RotateCcw}
                        onClick={() => {
                          setMessages((current) => current.filter((item) => item.id !== message.id));
                          ask(message.retryText);
                        }}
                      >
                        {t('assistant.retry')}
                      </Button>
                    </div>
                  </li>
                );
              }
              return (
                <li
                  key={message.id}
                  className={`bubble-row ${message.role === 'user' ? 'bubble-row--user' : 'bubble-row--assistant'}`}
                >
                  <div className={`bubble bubble--${message.role}`}>
                    <span className="bubble__author">
                      {message.role === 'user' ? t('assistant.you') : t('assistant.assistantName')}
                    </span>
                    <p className="bubble__text">{message.text}</p>
                    <span className="bubble__time">{formatTime(message.at)}</span>
                  </div>
                </li>
              );
            })}
          </ul>
        )}

        {busy ? (
          <div className="typing" role="status">
            <span className="typing__dots" aria-hidden="true">
              <i />
              <i />
              <i />
            </span>
            <span className="typing__label">{t('assistant.typing')}</span>
          </div>
        ) : null}
      </div>

      {messages.length ? (
        <div className="chip-row chip-row--suggestions">
          {aiService.suggestedQuestionKeys.slice(0, 2).map((key) => (
            <button key={key} type="button" className="suggest-chip" onClick={() => ask(t(key))} disabled={busy}>
              {t(key)}
            </button>
          ))}
        </div>
      ) : null}

      <form
        className="composer"
        onSubmit={(event) => {
          event.preventDefault();
          ask(draft);
        }}
      >
        <button
          type="button"
          className="icon-btn composer__attach"
          aria-label={t('assistant.attach')}
          onClick={() => toast.show(t('assistant.attachNotice'), 'info')}
        >
          <Paperclip size={18} aria-hidden="true" />
        </button>
        <input
          className="input composer__input"
          value={draft}
          onChange={(event) => setDraft(event.target.value)}
          placeholder={t('assistant.inputPh')}
          aria-label={t('assistant.inputLabel')}
          dir="auto"
          maxLength={500}
        />
        <Button type="submit" icon={Send} loading={busy} disabled={!draft.trim()} className="composer__send">
          {t('assistant.send')}
        </Button>
      </form>

      <ConfirmDialog
        open={clearOpen}
        title={t('assistant.clearConfirmTitle')}
        body={t('assistant.clearConfirmBody')}
        confirmLabel={t('assistant.clearChat')}
        destructive
        onCancel={() => setClearOpen(false)}
        onConfirm={clearChat}
      />
      <span className="sr-only">{lang}</span>
    </div>
  );
}
