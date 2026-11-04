import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _activeImage = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final property = state.propertyById(widget.propertyId);

    if (property == null) {
      return ListView(
        padding: const EdgeInsets.all(AppSpace.screen),
        children: [
          EmptyState(
            title: state.tr('property.notFoundTitle'),
            body: state.tr('property.notFoundBody'),
            icon: Icons.home_work_outlined,
            action: FilledButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
              child: Text(state.tr('property.notFoundCta')),
            ),
          ),
        ],
      );
    }

    final requests = state.requestsFor(property.id);
    final history = requests.where((item) => item.status == 'completed').toList();
    final reports = state.reportsFor(property.id);
    final lastReport = reports.isEmpty ? null : reports.first;
    final invoices = state.invoicesFor(property.id);
    final visits = state.upcomingVisits.where((item) => item.propertyId == property.id).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final nextVisit = visits.isEmpty ? null : visits.first;
    final gallery = property.images.isNotEmpty
        ? property.images
        : const <String>['assets/images/property_chalet_interior.jpg'];
    final activeImage = _activeImage >= gallery.length ? 0 : _activeImage;
    final maxInvoice = invoices.fold<int>(
      1,
      (maxAmount, invoice) => invoice.amount > maxAmount ? invoice.amount : maxAmount,
    );

    final facts = <({String titleKey, String value, IconData icon})>[
      if (state.text(property.propertyType).trim().isNotEmpty)
        (titleKey: 'property.type', value: state.text(property.propertyType), icon: Icons.home_outlined),
      if (property.bedrooms > 0)
        (titleKey: 'property.bedrooms', value: '${property.bedrooms}', icon: Icons.bed_outlined),
      if (property.areaSqm > 0)
        (titleKey: 'property.area', value: '${property.areaSqm} m²', icon: Icons.square_foot_outlined),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _PropertyHero(
          property: property,
          imagePath: gallery[activeImage],
        ),
        if (gallery.length > 1)
          _PageSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeading(
                  state.tr('property.gallery'),
                  trailing: Text(
                    '${gallery.length} ${state.tr('property.galleryCount')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted),
                  ),
                ),
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: gallery.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpace.xs),
                    itemBuilder: (context, index) {
                      final selected = index == activeImage;
                      return Semantics(
                        button: true,
                        selected: selected,
                        label: '${state.tr('property.galleryOpen')} ${index + 1}',
                        child: Material(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: InkWell(
                            onTap: () => setState(() => _activeImage = index),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: Container(
                              width: 96,
                              height: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: selected ? AppColors.primary : AppColors.border,
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: LocalAssetImage(path: gallery[index], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        _PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(state.tr('property.specsTitle')),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - AppSpace.xs) / 2;
                  return Wrap(
                    spacing: AppSpace.xs,
                    runSpacing: AppSpace.xs,
                    children: [
                      for (final fact in facts)
                        SizedBox(
                          width: itemWidth,
                          child: _FactCard(
                            title: state.tr(fact.titleKey),
                            value: fact.value,
                            icon: fact.icon,
                          ),
                        ),
                      SizedBox(
                        width: itemWidth,
                        child: _FactCard(
                          title: state.tr('property.status'),
                          value: state.tr('propertyStatus.${property.status}'),
                          icon: Icons.home_work_outlined,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpace.sm),
              Text(
                state.tr('property.factsUnavailable'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted),
              ),
            ],
          ),
        ),
        _PageSection(
          child: SurfaceCard(
            child: Column(
              children: [
                _DetailRow(
                  label: state.tr('property.lastInspection'),
                  value: lastReport == null ? state.tr('common.notAvailable') : formatDate(lastReport.inspectionDate, state.language),
                  ltrValue: true,
                ),
                const Divider(height: AppSpace.lg),
                _DetailRow(
                  label: state.tr('property.nextVisit'),
                  value: nextVisit == null
                      ? state.tr('property.noneScheduled')
                      : '${formatDate(nextVisit.date, state.language)} · ${formatTime(nextVisit.date)}',
                  ltrValue: true,
                ),
              ],
            ),
          ),
        ),
        _PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(state.tr('property.maintenanceHistory')),
              if (history.isEmpty)
                EmptyState(title: state.tr('property.noHistory'), body: '', icon: Icons.handyman_outlined)
              else
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var index = 0; index < history.length; index++) ...[
                        _RequestListRow(request: history[index], showStatus: false),
                        if (index < history.length - 1) const Divider(height: 1, indent: AppSpace.md, endIndent: AppSpace.md),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
        _PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(
                state.tr('property.recentRequests'),
                trailing: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/services'),
                  child: Text(state.tr('common.viewAll')),
                ),
              ),
              if (requests.isEmpty)
                EmptyState(
                  title: state.tr('home.noRequestsTitle'),
                  body: state.tr('home.noRequestsBody'),
                  icon: Icons.inbox_outlined,
                )
              else
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var index = 0; index < math.min(4, requests.length); index++) ...[
                        _RequestListRow(request: requests[index]),
                        if (index < math.min(4, requests.length) - 1)
                          const Divider(height: 1, indent: AppSpace.md, endIndent: AppSpace.md),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
        _PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(state.tr('property.expensesTitle')),
              if (invoices.isEmpty)
                EmptyState(title: state.tr('property.noHistory'), body: '', icon: Icons.receipt_long_outlined)
              else
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0; index < invoices.length; index++) ...[
                        _InvoiceBar(invoice: invoices[index], maxAmount: maxInvoice),
                        if (index < invoices.length - 1) const SizedBox(height: AppSpace.md),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
        _PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeading(state.tr('property.actionsTitle')),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - AppSpace.xs) / 2;
                  final actions = <({String titleKey, IconData icon, String route})>[
                    (titleKey: 'property.requestMaintenance', icon: Icons.handyman_outlined, route: '/services'),
                    (titleKey: 'property.requestCleaning', icon: Icons.cleaning_services_outlined, route: '/services'),
                    (titleKey: 'property.requestInspection', icon: Icons.calendar_month_outlined, route: '/services'),
                    (titleKey: 'property.viewReports', icon: Icons.assignment_outlined, route: lastReport == null ? '/services' : '/inspection/${lastReport.id}'),
                  ];
                  return Wrap(
                    spacing: AppSpace.xs,
                    runSpacing: AppSpace.xs,
                    children: [
                      for (var index = 0; index < actions.length; index++)
                        SizedBox(
                          width: itemWidth,
                          child: index == actions.length - 1
                              ? FilledButton.icon(
                                  onPressed: () => Navigator.of(context).pushNamed(actions[index].route),
                                  icon: Icon(actions[index].icon, size: 19),
                                  label: Text(state.tr(actions[index].titleKey), maxLines: 2, overflow: TextOverflow.ellipsis),
                                )
                              : OutlinedButton.icon(
                                  onPressed: () => Navigator.of(context).pushNamed(actions[index].route),
                                  icon: Icon(actions[index].icon, size: 19),
                                  label: Text(state.tr(actions[index].titleKey), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.lg),
      ],
    );
  }
}

class _PropertyHero extends StatelessWidget {
  const _PropertyHero({required this.property, required this.imagePath});

  final PropertyModel property;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return SizedBox(
      height: 264,
      child: Stack(
        fit: StackFit.expand,
        children: [
          LocalAssetImage(path: imagePath, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xB8002033)],
                stops: [0.36, 1],
              ),
            ),
          ),
          PositionedDirectional(
            start: AppSpace.screen,
            end: AppSpace.screen,
            bottom: AppSpace.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.text(property.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: const [Shadow(color: Color(0x66000000), blurRadius: 8)],
                      ),
                ),
                const SizedBox(height: AppSpace.xxs),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: Colors.white),
                    const SizedBox(width: AppSpace.xxs),
                    Expanded(
                      child: Text(
                        state.text(property.location),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: AppSpace.xs),
                    StatusChip(status: property.status, translationPrefix: 'propertyStatus'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSection extends StatelessWidget {
  const _PageSection({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(AppSpace.screen, AppSpace.lg, AppSpace.screen, 0),
        child: child,
      );
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SurfaceCard(
        padding: const EdgeInsets.all(AppSpace.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpace.xs),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.ltrValue = false});
  final String label;
  final String value;
  final bool ltrValue;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted)),
          ),
          const SizedBox(width: AppSpace.sm),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textDirection: ltrValue ? TextDirection.ltr : null,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
}

class _RequestListRow extends StatelessWidget {
  const _RequestListRow({required this.request, this.showStatus = true});
  final ServiceRequestModel request;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return InkWell(
      onTap: showStatus ? () => Navigator.of(context).pushNamed('/services') : null,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(AppSpace.md, AppSpace.sm, AppSpace.md, AppSpace.sm),
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
                    '${request.reference} · ${formatDate(request.createdAt, state.language)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted),
                  ),
                ],
              ),
            ),
            if (showStatus) ...[
              const SizedBox(width: AppSpace.xs),
              StatusChip(status: request.status),
            ] else ...[
              const SizedBox(width: AppSpace.xs),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 110),
                child: Text(
                  formatMoney(request.finalCost ?? request.estimatedCost, state.language),
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.ltr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InvoiceBar extends StatelessWidget {
  const _InvoiceBar({required this.invoice, required this.maxAmount});
  final InvoiceModel invoice;
  final int maxAmount;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final paid = invoice.status == 'paid';
    final progress = maxAmount <= 0 ? 0.0 : (invoice.amount / maxAmount).clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                state.text(invoice.description),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Text(
              formatMoney(invoice.amount, state.language),
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.chartTrack,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
        ),
        const SizedBox(height: AppSpace.xxs),
        Text(
          '${formatDate(invoice.createdAt, state.language)} · ${state.tr(paid ? 'profile.paid' : 'profile.unpaid')}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceMuted),
        ),
      ],
    );
  }
}
