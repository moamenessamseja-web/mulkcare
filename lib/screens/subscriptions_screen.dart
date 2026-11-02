import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  String? _pendingPlanId;

  void _requestPlan(AppState state, PlanModel plan) {
    if (_pendingPlanId != null) return;
    setState(() => _pendingPlanId = plan.id);
    state.requestSubscription(plan.id);
    if (!mounted) return;
    setState(() => _pendingPlanId = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.tr('subscriptions.requestSuccess'))),
    );
  }

  Widget _fact(BuildContext context, String label, String value, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpace.xs),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted))),
          const SizedBox(width: AppSpace.xs),
          Expanded(flex: 2, child: Text(value, textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _planCard(BuildContext context, AppState state, PlanModel plan, Set<String> activePlanIds) {
    final current = activePlanIds.contains(plan.id);
    final kind = plan.id == 'plan_premium' ? 'premium' : 'basic';
    final title = state.tr(plan.nameKey);
    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
          child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
            LocalAssetImage(path: 'assets/images/marina_dusk.jpg', height: 118, width: double.infinity),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpace.md),
              decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xD9002438)])),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (current) ...[
              Align(alignment: AlignmentDirectional.centerStart, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xxs),
                decoration: BoxDecoration(color: AppColors.successTint, borderRadius: BorderRadius.circular(AppRadius.full)),
                child: Text(state.tr('subscriptions.current'), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
              )),
              const SizedBox(height: AppSpace.sm),
            ],
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(formatMoney(plan.monthlyPrice, state.language), textDirection: TextDirection.ltr, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              const SizedBox(width: AppSpace.xs),
              Padding(padding: const EdgeInsets.only(bottom: 3), child: Text('/ ${state.tr('common.perMonth')}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted))),
            ]),
            const SizedBox(height: AppSpace.xs),
            Text(state.tr('subscriptions.priceNote'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
            const SizedBox(height: AppSpace.md),
            _fact(context, state.tr('subscriptions.inspectionFrequency'), state.tr('subscriptions.plans.$kind.frequency'), Icons.fact_check_outlined),
            _fact(context, state.tr('subscriptions.serviceLimits'), state.tr('subscriptions.plans.$kind.limits'), Icons.handyman_outlined),
            const SizedBox(height: AppSpace.sm),
            Text(state.tr('subscriptions.includedTitle'), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpace.xs),
            for (final key in plan.featureKeys)
              Padding(padding: const EdgeInsets.symmetric(vertical: AppSpace.xxs), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                const SizedBox(width: AppSpace.xs),
                Expanded(child: Text(state.tr(key), style: Theme.of(context).textTheme.bodyMedium)),
              ])),
            const SizedBox(height: AppSpace.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpace.sm),
              decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(state.tr('subscriptions.excludedTitle'), style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpace.xxs),
                Text(state.tr('subscriptions.plans.$kind.excluded'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
              ]),
            ),
            const SizedBox(height: AppSpace.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: current || _pendingPlanId != null ? null : () => _requestPlan(state, plan),
                icon: _pendingPlanId == plan.id ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_outlined),
                label: Text(current ? state.tr('subscriptions.current') : state.tr('subscriptions.selectPlan')),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final active = state.subscriptions.where((item) => item.status == 'active').toList();
    final activePlanIds = active.map((item) => item.planId).toSet();
    return ListView(padding: const EdgeInsets.fromLTRB(AppSpace.screen, AppSpace.md, AppSpace.screen, AppSpace.xl), children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
          LocalAssetImage(path: 'assets/images/marina_dusk.jpg', height: 150, width: double.infinity),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpace.md),
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xDB002438)])),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(state.tr('subscriptions.title'), style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpace.xxs),
              Text(state.tr('subscriptions.subtitle'), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            ]),
          ),
        ]),
      ),
      if (active.isNotEmpty) ...[
        const SizedBox(height: AppSpace.lg),
        SectionHeading(state.tr('subscriptions.currentPlan')),
        for (final subscription in active)
          Padding(padding: const EdgeInsets.only(bottom: AppSpace.sm), child: SurfaceCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.verified_outlined, color: AppColors.success), const SizedBox(width: AppSpace.xs), Expanded(child: Text(state.tr('subscriptions.statusActive'), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.success)))]),
              const SizedBox(height: AppSpace.sm),
              Text(state.text(state.propertyById(subscription.propertyId)?.name ?? const LocalizedText('العقار', 'Property')), style: Theme.of(context).textTheme.titleSmall),
              Text(state.tr(state.planById(subscription.planId)?.nameKey ?? 'subscriptions.title'), style: Theme.of(context).textTheme.bodyMedium),
              if (subscription.renewalDate != null) ...[
                const SizedBox(height: AppSpace.xs),
                Text('${state.tr('subscriptions.renewsOn')} ${formatDate(subscription.renewalDate, state.language)}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
              ],
            ]),
          )),
      ],
      const SizedBox(height: AppSpace.lg),
      SectionHeading(state.tr('subscriptions.comparisonTitle')),
      for (final plan in state.plans) ...[
        _planCard(context, state, plan, activePlanIds),
        const SizedBox(height: AppSpace.md),
      ],
      InlineNotice(title: state.tr('subscriptions.extraCharges'), body: state.tr('subscriptions.noPayment'), tone: NoticeTone.warning, icon: Icons.info_outline),
      const SizedBox(height: AppSpace.md),
      Text(state.tr('subscriptions.priceNote'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
    ]);
  }
}
