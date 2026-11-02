import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../state/app_state.dart';

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(AppSpace.md), this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg), side: const BorderSide(color: AppColors.border)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.sm),
        child: Row(
          children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.xxs),
      color: AppColors.warningTint,
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
          const SizedBox(width: AppSpace.xs),
          Expanded(child: Text(state.tr('common.demoBanner'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.warning))),
        ],
      ),
    );
  }
}

class InlineNotice extends StatelessWidget {
  const InlineNotice({super.key, required this.title, required this.body, this.icon = Icons.info_outline, this.tone = NoticeTone.info});
  final String title;
  final String body;
  final IconData icon;
  final NoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      NoticeTone.info => (AppColors.primaryTint, AppColors.primary),
      NoticeTone.warning => (AppColors.warningTint, AppColors.warning),
      NoticeTone.success => (AppColors.successTint, AppColors.success),
      NoticeTone.danger => (AppColors.dangerTint, AppColors.danger),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: foreground),
        const SizedBox(width: AppSpace.sm),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: foreground)),
          const SizedBox(height: AppSpace.xxs),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ])),
      ]),
    );
  }
}

enum NoticeTone { info, warning, success, danger }

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.body, this.icon = Icons.inbox_outlined, this.action});
  final String title;
  final String body;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 44, color: AppColors.onSurfaceMuted),
            const SizedBox(height: AppSpace.md),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpace.xs),
            Text(body, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceMuted)),
            if (action != null) ...[const SizedBox(height: AppSpace.md), action!],
          ]),
        ),
      );
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.translationPrefix = 'status'});
  final String status;
  final String translationPrefix;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final (foreground, background, icon) = switch (status) {
      'awaiting_approval' => (AppColors.warning, AppColors.warningTint, Icons.hourglass_top),
      'approved' => (AppColors.secondaryStrong, AppColors.secondaryTint, Icons.check_circle_outline),
      'scheduled' => (AppColors.primary, AppColors.primaryTint, Icons.calendar_month_outlined),
      'in_progress' => (AppColors.accentStrong, AppColors.accentTint, Icons.build_outlined),
      'completed' => (AppColors.success, AppColors.successTint, Icons.check_circle_outline),
      'cancelled' => (AppColors.danger, AppColors.dangerTint, Icons.cancel_outlined),
      'occupied' => (AppColors.secondaryStrong, AppColors.secondaryTint, Icons.home_outlined),
      'vacant' => (AppColors.primary, AppColors.primaryTint, Icons.home_work_outlined),
      'maintenance' => (AppColors.warning, AppColors.warningTint, Icons.handyman_outlined),
      _ => (AppColors.onSurfaceMuted, AppColors.surfaceMuted, Icons.schedule_outlined),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xxs),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.full)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: foreground),
        const SizedBox(width: AppSpace.xxs),
        Text(state.tr('$translationPrefix.$status'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: foreground, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class LocalAssetImage extends StatelessWidget {
  const LocalAssetImage({super.key, required this.path, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius});
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(path, width: width, height: height, fit: fit, errorBuilder: (_, __, ___) => Container(
      width: width,
      height: height,
      color: AppColors.surfaceMuted,
      alignment: Alignment.center,
      child: const Icon(Icons.home_outlined, color: AppColors.onSurfaceMuted),
    ));
    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText({super.key, required this.amount, this.style});
  final int? amount;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final number = amount == null ? state.tr('common.notAvailable') : '${amount!.toString()} ${state.tr('common.currency')}';
    return Text(number, textDirection: TextDirection.ltr, style: style ?? Theme.of(context).textTheme.titleMedium);
  }
}
