import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final now = cairoNow();
    final userName = state.user == null ? '—' : state.text(state.user!.fullName);
    final openStatuses = {
      'pending',
      'awaiting_approval',
      'approved',
      'scheduled',
      'in_progress',
    };
    final openRequests = state.serviceRequests
        .where((request) => openStatuses.contains(request.status))
        .length;
    final awaitingApproval = state.serviceRequests
        .where((request) => request.status == 'awaiting_approval')
        .toList();
    final monthSpend = state.invoices.where((invoice) {
      return invoice.createdAt.month == now.month &&
          invoice.createdAt.year == now.year;
    }).fold<int>(0, (sum, invoice) => sum + invoice.amount);
    final recentRequests = [...state.serviceRequests]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final nextVisits = [...state.upcomingVisits]
      ..sort((a, b) => a.date.compareTo(b.date));
    final latestReports = [...state.inspectionReports]
      ..sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpace.screen,
        AppSpace.md,
        AppSpace.screen,
        AppSpace.xl,
      ),
      children: [
        _DashboardHeader(
          greeting: state.tr(now.hour < 12
              ? 'home.greetingMorning'
              : 'home.greetingEvening'),
          name: userName,
          subtitle: state.tr('home.subtitle'),
        ),
        if (awaitingApproval.isNotEmpty) ...[
          const SizedBox(height: AppSpace.md),
          _AttentionCard(reference: awaitingApproval.first.reference),
        ],
        const SizedBox(height: AppSpace.lg),
        _KpiRow(
          properties: state.properties.length,
          openRequests: openRequests,
          monthSpend: monthSpend,
        ),
        const SizedBox(height: AppSpace.lg),
        _PropertiesSection(properties: state.properties),
        const SizedBox(height: AppSpace.lg),
        _QuickActions(latestReport: latestReports.isEmpty ? null : latestReports.first),
        const SizedBox(height: AppSpace.lg),
        _RecentRequests(requests: recentRequests.take(3).toList()),
        const SizedBox(height: AppSpace.lg),
        _UpcomingVisits(visits: nextVisits.take(3).toList()),
        const SizedBox(height: AppSpace.lg),
        _LatestInspections(reports: latestReports.take(2).toList()),
      ],
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.greeting,
    required this.name,
    required this.subtitle,
  });

  final String greeting;
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpace.xxs),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.primaryStrong,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpace.xxs),
        Text(subtitle, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({required this.reference});
  final String reference;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Material(
      color: AppColors.warningTint,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => Navigator.of(context).pushNamed('/services'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.md),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 24),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.tr('home.attentionTitle'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSpace.xxs),
                    Text(
                      '${state.tr('home.attentionApproval')} — $reference',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.text,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.xs),
              Icon(
                state.isRtl ? Icons.arrow_back : Icons.arrow_forward,
                color: AppColors.warning,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({
    required this.properties,
    required this.openRequests,
    required this.monthSpend,
  });

  final int properties;
  final int openRequests;
  final int monthSpend;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return IntrinsicHeight(
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _KpiCard(
            label: state.tr('home.propertiesMonitored'),
            value: '$properties',
            icon: Icons.home_work_outlined,
          ),
        ),
        const SizedBox(width: AppSpace.xs),
        Expanded(
          child: _KpiCard(
            label: state.tr('home.openRequests'),
            value: '$openRequests',
            icon: Icons.handyman_outlined,
          ),
        ),
        const SizedBox(width: AppSpace.xs),
        Expanded(
          child: _KpiCard(
            label: state.tr('home.monthSpend'),
            value: formatMoney(monthSpend, state.language),
            icon: Icons.payments_outlined,
            money: true,
          ),
        ),
      ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    this.money = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool money;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SurfaceCard(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpace.sm,
        AppSpace.sm,
        AppSpace.sm,
        AppSpace.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 19),
          const SizedBox(height: AppSpace.xs),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSpace.xxs),
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              alignment: AlignmentDirectional.centerStart,
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                maxLines: 1,
                textDirection: money ? TextDirection.ltr : null,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: money ? AppColors.accentStrong : AppColors.text,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertiesSection extends StatelessWidget {
  const _PropertiesSection({required this.properties});
  final List<PropertyModel> properties;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(
          state.tr('home.propertiesTitle'),
          trailing: Text(
            '${properties.length} ${state.tr('home.propertiesCount')}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
          ),
        ),
        if (properties.isEmpty)
          EmptyState(
            title: state.tr('home.noPropertiesTitle'),
            body: state.tr('home.noPropertiesBody'),
            icon: Icons.home_work_outlined,
            action: OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/services'),
              child: Text(state.tr('home.noPropertiesCta')),
            ),
          )
        else
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.only(end: AppSpace.xs),
              itemCount: properties.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpace.sm),
              itemBuilder: (context, index) => _PropertyCard(
                property: properties[index],
              ),
            ),
          ),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.property});
  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final photo = property.images.isEmpty ? null : property.images.first;
    return SizedBox(
      width: 264,
      child: SurfaceCard(
        padding: const EdgeInsets.all(AppSpace.sm),
        onTap: () => Navigator.of(context).pushNamed('/property/${property.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: photo == null
                  ? Container(
                      height: 112,
                      color: AppColors.surfaceMuted,
                      child: const Icon(Icons.home_outlined,
                          color: AppColors.onSurfaceMuted, size: 34),
                    )
                  : LocalAssetImage(
                      path: photo,
                      height: 112,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              state.text(property.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpace.xxs),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 15, color: AppColors.onSurfaceMuted),
                const SizedBox(width: AppSpace.xxs),
                Expanded(
                  child: Text(
                    state.text(property.location),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: StatusChip(
                status: property.status,
                translationPrefix: 'propertyStatus',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.latestReport});
  final InspectionReportModel? latestReport;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final actions = <({String key, IconData icon, String route})>[
      (key: 'home.qaMaintenance', icon: Icons.handyman_outlined, route: '/services'),
      (key: 'home.qaCleaning', icon: Icons.cleaning_services_outlined, route: '/services'),
      (key: 'home.qaInspection', icon: Icons.calendar_month_outlined, route: '/services'),
      (
        key: 'home.qaReports',
        icon: Icons.assignment_outlined,
        route: latestReport == null ? '/property' : '/inspection/${latestReport!.id}',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(state.tr('home.quickActionsTitle')),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpace.sm,
            crossAxisSpacing: AppSpace.sm,
            mainAxisExtent: 104,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return SurfaceCard(
              padding: const EdgeInsets.all(AppSpace.md),
              onTap: () => Navigator.of(context).pushNamed(action.route),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(action.icon,
                        size: 21, color: AppColors.primary),
                  ),
                  Text(
                    state.tr(action.key),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RecentRequests extends StatelessWidget {
  const _RecentRequests({required this.requests});
  final List<ServiceRequestModel> requests;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(
          state.tr('home.recentRequestsTitle'),
          trailing: TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/services'),
            child: Text(state.tr('common.viewAll')),
          ),
        ),
        if (requests.isEmpty)
          EmptyState(
            title: state.tr('home.noRequestsTitle'),
            body: state.tr('home.noRequestsBody'),
            icon: Icons.receipt_long_outlined,
            action: FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/services'),
              child: Text(state.tr('home.noRequestsCta')),
            ),
          )
        else
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < requests.length; index++) ...[
                  _RequestRow(request: requests[index]),
                  if (index != requests.length - 1)
                    const Divider(height: 1, indent: AppSpace.md, endIndent: AppSpace.md),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _RequestRow extends StatelessWidget {
  const _RequestRow({required this.request});
  final ServiceRequestModel request;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Navigator.of(context).pushNamed('/services'),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpace.md,
          AppSpace.sm,
          AppSpace.md,
          AppSpace.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.tr('services.categories.${request.category}'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpace.xxs),
                  Text(
                    '${request.reference} · ${formatDate(request.createdAt, state.language)} · ${formatTime(request.createdAt)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.xs),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: StatusChip(status: request.status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingVisits extends StatelessWidget {
  const _UpcomingVisits({required this.visits});
  final List<VisitModel> visits;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(state.tr('home.upcomingVisitsTitle')),
        if (visits.isEmpty)
          EmptyState(
            title: state.tr('home.noVisitsTitle'),
            body: state.tr('home.noVisitsBody'),
            icon: Icons.event_busy_outlined,
          )
        else
          SurfaceCard(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpace.md,
              AppSpace.xs,
              AppSpace.md,
              AppSpace.xs,
            ),
            child: Column(
              children: [
                for (var index = 0; index < visits.length; index++) ...[
                  _VisitRow(visit: visits[index]),
                  if (index != visits.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _VisitRow extends StatelessWidget {
  const _VisitRow({required this.visit});
  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final property = state.propertyById(visit.propertyId);
    return InkWell(
      onTap: property == null
          ? null
          : () => Navigator.of(context).pushNamed('/property/${property.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month_outlined,
                  color: AppColors.primary, size: 19),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.text(visit.type),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpace.xxs),
                  Text(
                    '${property == null ? '—' : state.text(property.name)} · ${formatDate(visit.date, state.language)} · ${formatTime(visit.date)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpace.xxs),
                  Text(
                    state.text(visit.note),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceMuted,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestInspections extends StatelessWidget {
  const _LatestInspections({required this.reports});
  final List<InspectionReportModel> reports;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(state.tr('home.latestInspectionsTitle')),
        if (reports.isEmpty)
          EmptyState(
            title: state.tr('home.noInspectionsTitle'),
            body: state.tr('home.noInspectionsBody'),
            icon: Icons.assignment_outlined,
            action: FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/services'),
              child: Text(state.tr('home.noInspectionsCta')),
            ),
          )
        else
          Column(
            children: [
              for (final report in reports) ...[
                _InspectionCard(report: report),
                if (report != reports.last)
                  const SizedBox(height: AppSpace.sm),
              ],
            ],
          ),
      ],
    );
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({required this.report});
  final InspectionReportModel report;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final property = state.propertyById(report.propertyId);
    return SurfaceCard(
      onTap: () => Navigator.of(context).pushNamed('/inspection/${report.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  property == null ? '—' : state.text(property.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Container(
                constraints: const BoxConstraints(minWidth: 46, minHeight: 46),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentTint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  '${report.score}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.accentStrong,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            '${report.reference} · ${formatDate(report.inspectionDate, state.language)} · ${state.tr('inspection.overallCondition')}: ${state.text(report.overallLabel)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            state.text(report.summary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
