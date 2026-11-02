import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final items = state.notifications;
    final unread = state.unreadCount;
    if (items.isEmpty) {
      return ListView(padding: const EdgeInsets.all(AppSpace.screen), children: [
        const SizedBox(height: AppSpace.xl),
        EmptyState(icon: Icons.notifications_none_outlined, title: state.tr('notifications.emptyTitle'), body: state.tr('notifications.emptyBody')),
      ]);
    }
    return ListView(padding: const EdgeInsets.fromLTRB(AppSpace.screen, AppSpace.md, AppSpace.screen, AppSpace.xl), children: [
      SectionHeading(state.tr('notifications.title'), trailing: unread == 0 ? null : TextButton.icon(onPressed: state.markAllNotificationsRead, icon: const Icon(Icons.done_all, size: 18), label: Text(state.tr('notifications.markAllRead')))),
      Text('${items.length}', textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
      const SizedBox(height: AppSpace.sm),
      for (final item in items) ...[
        SurfaceCard(
          padding: const EdgeInsets.all(AppSpace.sm),
          onTap: () {
            if (!item.read) state.markNotificationRead(item.id);
            final href = item.href;
            if (href != null && href.isNotEmpty) Navigator.of(context).pushNamed(href);
          },
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsetsDirectional.only(top: AppSpace.xxs), child: Icon(item.read ? Icons.notifications_none : Icons.notifications_active, size: 22, color: item.read ? AppColors.onSurfaceMuted : AppColors.primary)),
            const SizedBox(width: AppSpace.sm),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Text(state.text(item.title), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: item.read ? FontWeight.w500 : FontWeight.w700))),
                if (!item.read) Container(width: 9, height: 9, margin: const EdgeInsetsDirectional.only(start: AppSpace.xs, top: 5), decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
              ]),
              const SizedBox(height: AppSpace.xxs),
              Text(state.text(item.body), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpace.xs),
              Row(children: [
                Expanded(child: Text('${formatRelative(item.createdAt, state.language)} · ${state.tr(item.read ? 'notifications.read' : 'notifications.unread')}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted))),
                if (!item.read) TextButton(onPressed: () => state.markNotificationRead(item.id), child: Text(state.tr('notifications.markRead'))),
                if (item.href != null) Icon(state.isRtl ? Icons.arrow_back : Icons.arrow_forward, size: 18, color: AppColors.primary),
              ]),
            ])),
          ]),
        ),
        const SizedBox(height: AppSpace.sm),
      ],
    ]);
  }
}
