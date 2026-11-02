import 'dart:async';

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  static const List<String> _suggestedQuestionKeys = [
    'assistant.q1',
    'assistant.q2',
    'assistant.q3',
    'assistant.q4',
  ];

  final TextEditingController _composerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_AssistantMessage> _messages = [];
  bool _busy = false;
  int _generation = 0;

  @override
  void dispose() {
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send(String value) async {
    final text = value.trim();
    if (text.isEmpty || _busy) return;

    final state = AppState.of(context);
    final messageId = 'm_${cairoNow().microsecondsSinceEpoch}';
    final generation = _generation;
    setState(() {
      _messages.add(_AssistantMessage(
        id: messageId,
        role: _MessageRole.user,
        text: text,
        createdAt: cairoNow(),
      ));
      _composerController.clear();
      _busy = true;
    });
    _scrollToBottom();

    try {
      // Match the source's brief typing state; the answer itself is local and deterministic.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted || generation != _generation) return;
      final reply = state.assistantReply(text);
      setState(() {
        _messages.add(_AssistantMessage(
          id: '${messageId}_reply',
          role: _MessageRole.assistant,
          text: reply,
          createdAt: cairoNow(),
        ));
        _busy = false;
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _messages.add(_AssistantMessage(
          id: '${messageId}_failed',
          role: _MessageRole.failed,
          text: state.tr('assistant.failed'),
          retryText: text,
          createdAt: cairoNow(),
        ));
        _busy = false;
      });
      _scrollToBottom();
    }
  }

  void _retry(_AssistantMessage message) {
    setState(() => _messages.removeWhere((item) => item.id == message.id));
    unawaited(_send(message.retryText ?? ''));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _confirmClear() async {
    final state = AppState.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(state.tr('assistant.clearConfirmTitle')),
        content: Text(state.tr('assistant.clearConfirmBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(state.tr('common.cancel')),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(state.tr('assistant.clearChat')),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      // Discard any pending local demo reply so a cleared conversation stays empty.
      _generation++;
      _busy = false;
      _messages.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.tr('assistant.cleared'))),
    );
  }

  void _showAttachmentNotice() {
    final state = AppState.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.tr('assistant.attachNotice'))),
    );
  }

  Widget _suggestionChips(AppState state, Iterable<String> keys) {
    return Wrap(
      spacing: AppSpace.xs,
      runSpacing: AppSpace.xs,
      children: keys.map((key) {
        return ActionChip(
          onPressed: _busy ? null : () => _send(state.tr(key)),
          avatar: const Icon(Icons.auto_awesome_outlined, size: 16),
          label: Text(state.tr(key), softWrap: true),
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary),
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.xxs),
        );
      }).toList(),
    );
  }

  Widget _messageBubble(AppState state, _AssistantMessage message) {
    if (message.role == _MessageRole.failed) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.88),
          child: Container(
            padding: const EdgeInsets.all(AppSpace.sm),
            decoration: BoxDecoration(
              color: AppColors.dangerTint,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.danger)),
                const SizedBox(height: AppSpace.xxs),
                TextButton.icon(
                  onPressed: _busy ? null : () => _retry(message),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(state.tr('assistant.retry')),
                  style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isUser = message.role == _MessageRole.user;
    final authorKey = isUser ? 'assistant.you' : 'assistant.assistantName';
    final author = state.text(LocalizedText(state.tr(authorKey), state.tr(authorKey)));
    final messageText = state.text(LocalizedText(message.text, message.text));
    final bubbleColor = isUser ? AppColors.primary : AppColors.surface;
    final foregroundColor = isUser ? AppColors.onBrand : AppColors.text;

    return Align(
      alignment: isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.88),
        child: Container(
          padding: const EdgeInsets.all(AppSpace.sm),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: isUser ? null : Border.all(color: AppColors.border),
            boxShadow: isUser ? null : raisedShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(author, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foregroundColor.withValues(alpha: 0.82), fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpace.xxs),
              Text(messageText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: foregroundColor)),
              const SizedBox(height: AppSpace.xxs),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  formatTime(message.createdAt),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foregroundColor.withValues(alpha: 0.72)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _composer(AppState state) {
    final canSend = _composerController.text.trim().isNotEmpty && !_busy;
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            tooltip: state.tr('assistant.attach'),
            onPressed: _showAttachmentNotice,
            icon: const Icon(Icons.attach_file),
            color: AppColors.primary,
            constraints: const BoxConstraints(minWidth: AppSpace.touchMin, minHeight: AppSpace.touchMin),
          ),
          Expanded(
            child: TextField(
              controller: _composerController,
              minLines: 1,
              maxLines: 3,
              maxLength: 500,
              textDirection: state.isRtl ? TextDirection.rtl : TextDirection.ltr,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onChanged: (_) => setState(() {}),
              onSubmitted: _send,
              decoration: InputDecoration(
                hintText: state.tr('assistant.inputPh'),
                labelText: state.tr('assistant.inputLabel'),
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.sm),
              ),
            ),
          ),
          const SizedBox(width: AppSpace.xxs),
          FilledButton.icon(
            onPressed: canSend ? () => _send(_composerController.text) : null,
            icon: _busy
                ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onBrand))
                : const Icon(Icons.send, size: 18),
            label: Text(state.tr('assistant.send')),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, AppSpace.touchMin),
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);
    final headerActions = <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.xxs),
        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.full)),
        child: Text(state.tr('assistant.demoBadge'), style: theme.textTheme.labelSmall?.copyWith(color: AppColors.text)),
      ),
      if (_messages.isNotEmpty)
        IconButton(
          tooltip: state.tr('assistant.clearChat'),
          onPressed: _confirmClear,
          icon: const Icon(Icons.delete_outline),
          color: AppColors.primary,
          constraints: const BoxConstraints(minWidth: AppSpace.touchMin, minHeight: AppSpace.touchMin),
        ),
    ];

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(AppSpace.screen, AppSpace.md, AppSpace.screen, AppSpace.lg),
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(AppRadius.full)),
              child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.tr('assistant.assistantName'), style: theme.textTheme.titleMedium),
                  Text(state.tr('assistant.subtitle'), style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.xs),
            Wrap(spacing: AppSpace.xxs, crossAxisAlignment: WrapCrossAlignment.center, children: headerActions),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpace.md),
          decoration: BoxDecoration(color: AppColors.warningTint, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 20, color: AppColors.warning),
              const SizedBox(width: AppSpace.sm),
              Expanded(child: Text(state.tr('assistant.demoNotice'), style: theme.textTheme.bodySmall?.copyWith(color: AppColors.warning))),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        if (_messages.isEmpty)
          SurfaceCard(
            child: EmptyState(
              icon: Icons.auto_awesome,
              title: state.tr('assistant.emptyTitle'),
              body: state.tr('assistant.emptyBody'),
              action: _suggestionChips(state, _suggestedQuestionKeys),
            ),
          )
        else ...[
          for (final message in _messages) ...[
            _messageBubble(state, message),
            const SizedBox(height: AppSpace.sm),
          ],
          if (_busy)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary)),
                  const SizedBox(width: AppSpace.xs),
                  Text(state.tr('assistant.typing'), style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
                ],
              ),
            ),
          _suggestionChips(state, _suggestedQuestionKeys.take(2)),
        ],
        const SizedBox(height: AppSpace.md),
        _composer(state),
      ],
    );
  }
}

enum _MessageRole { user, assistant, failed }

class _AssistantMessage {
  const _AssistantMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
    this.retryText,
  });

  final String id;
  final _MessageRole role;
  final String text;
  final DateTime createdAt;
  final String? retryText;
}
