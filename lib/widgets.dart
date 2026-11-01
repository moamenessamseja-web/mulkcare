import 'package:flutter/material.dart';

import 'models.dart';
import 'strings.dart';
import 'theme.dart';

/// Flat card: surface + 1px hairline, radius.lg, no shadow at rest.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.md),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class Chip28 extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;
  const Chip28({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: AppText.caption.copyWith(color: foreground)),
    );
  }
}

class RequestStatusChip extends StatelessWidget {
  final RequestStatus status;
  const RequestStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case RequestStatus.pending:
        return Chip28(
            text: Ar.status(status),
            background: AppColors.surfaceMuted,
            foreground: AppColors.onSurfaceMuted);
      case RequestStatus.inProgress:
        return Chip28(
            text: Ar.status(status),
            background: AppColors.accentTint,
            foreground: AppColors.accentStrong);
      case RequestStatus.done:
        return Chip28(
            text: Ar.status(status),
            background: AppColors.successTint,
            foreground: AppColors.success);
    }
  }
}

class OccupancyChip extends StatelessWidget {
  final OccupancyStatus status;
  const OccupancyChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final rented = status == OccupancyStatus.rented;
    return Chip28(
      text: Ar.occupancy(status),
      background: rented ? AppColors.primaryTint : AppColors.secondaryTint,
      foreground: rented ? AppColors.primary : AppColors.secondaryStrong,
    );
  }
}

class PaidChip extends StatelessWidget {
  final bool paid;
  const PaidChip({super.key, required this.paid});

  @override
  Widget build(BuildContext context) {
    return Chip28(
      text: paid ? Ar.paid : Ar.unpaid,
      background: paid ? AppColors.successTint : AppColors.warningTint,
      foreground: paid ? AppColors.success : AppColors.warning,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.sm),
        child: Text(text, style: AppText.h2),
      );
}

class EmptyNote extends StatelessWidget {
  final String text;
  const EmptyNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Text(text, style: AppText.body, textAlign: TextAlign.center),
      );
}

/// Unit photo from assets; falls back to a muted block if the asset is missing.
class UnitImage extends StatelessWidget {
  final String asset;
  final double height;
  final double radius;
  const UnitImage({
    super.key,
    required this.asset,
    required this.height,
    this.radius = AppRadius.sm,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) =>
              Container(color: AppColors.surfaceMuted),
        ),
      ),
    );
  }
}
