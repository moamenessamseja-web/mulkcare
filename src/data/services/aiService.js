/**
 * AI assistant service abstraction.
 *
 * DEMO MODE (default): no AI provider is connected. Replies are deterministic,
 * pre-written explanations taken from the dictionary — they describe how the
 * app works and never invent a booking, price, appointment or confirmation.
 * The UI shows a permanent demo badge while this mode is active.
 *
 * PRODUCTION MODE: set `VITE_AI_MODE=remote` and point `VITE_API_BASE_URL` at
 * the backend endpoint below. The provider API key must live ONLY on that
 * backend — never in this client bundle, which is fully readable by the user.
 *
 * Provider contract:
 *   POST {VITE_API_BASE_URL}/api/v1/assistant/messages
 *   body: { conversationId, message }
 *   returns: { reply: string, conversationId: string }
 */
import { AppError, ErrorCodes } from '../../core/errors';
import { env } from '../../core/env';

const aiMode = env.VITE_AI_MODE === 'remote' ? 'remote' : 'demo';
const apiBaseUrl = env.VITE_API_BASE_URL || '';

export const isDemoAssistant = aiMode === 'demo';

export const AI_ENDPOINT = '/api/v1/assistant/messages';

/** Keyword routing for the demo responder → dictionary key of the answer. */
const DEMO_ANSWERS = [
  { match: ['تكييف', 'مكيف', 'ac', 'air', 'condition', 'تبريد'], key: 'assistant.demo_ac' },
  { match: ['تنظيف', 'نظافة', 'clean'], key: 'assistant.demo_cleaning' },
  { match: ['فحص', 'تقرير', 'inspection', 'report'], key: 'assistant.demo_report' },
  { match: ['تجهيز', 'قبل', 'prepare', 'arrival', 'وصول'], key: 'assistant.demo_prep' },
  { match: ['فاتورة', 'مصاريف', 'حساب', 'invoice', 'expense'], key: 'assistant.demo_invoice' },
  { match: ['باقة', 'اشتراك', 'plan', 'subscription'], key: 'assistant.demo_plan' },
];

/**
 * @param {string} message
 * @returns {{ answerKey: string, matched: boolean }}
 */
function routeDemoMessage(message) {
  const normalised = (message || '').toLowerCase();
  const hit = DEMO_ANSWERS.find((entry) => entry.match.some((token) => normalised.includes(token)));
  return hit ? { answerKey: hit.key, matched: true } : { answerKey: 'assistant.demo_default', matched: false };
}

export const aiService = {
  mode: aiMode,

  /**
   * Send one message. Never resolves with a fabricated external action.
   * @param {{ conversationId: string|null, message: string }} input
   * @returns {Promise<{ conversationId: string, replyKey: string, demo: boolean }>}
   */
  async sendMessage({ conversationId, message }) {
    if (!message || !message.trim()) {
      throw new AppError(ErrorCodes.VALIDATION, 'assistant.inputPh');
    }

    if (aiMode === 'remote') {
      if (!apiBaseUrl) {
        throw new AppError(ErrorCodes.NOT_CONFIGURED, 'assistant.demoNotice');
      }
      let response;
      try {
        response = await fetch(`${apiBaseUrl}${AI_ENDPOINT}`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ conversationId, message }),
        });
      } catch (cause) {
        throw new AppError(ErrorCodes.NETWORK, 'assistant.failed', { cause });
      }
      if (!response.ok) {
        throw new AppError(ErrorCodes.NETWORK, 'assistant.failed');
      }
      const payload = await response.json();
      return {
        conversationId: payload.conversationId || conversationId || 'conv_remote',
        replyText: payload.reply,
        demo: false,
      };
    }

    // Demo responder: deterministic, honest, no invented facts.
    await new Promise((resolve) => setTimeout(resolve, 700));
    const { answerKey, matched } = routeDemoMessage(message);
    return {
      conversationId: conversationId || `conv_${Date.now().toString(36)}`,
      replyKey: answerKey,
      matched,
      demo: true,
    };
  },

  /** Suggested questions shown above an empty thread. */
  suggestedQuestionKeys: ['assistant.q1', 'assistant.q2', 'assistant.q3', 'assistant.q4'],
};

export default aiService;
