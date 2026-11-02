import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class InspectionReportScreen extends StatelessWidget {
  const InspectionReportScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final report = state.reportById(reportId);

    if (report == null) {
      return ListView(
        padding: const EdgeInsets.all(AppSpace.screen),
        children: [
          EmptyState(
            title: state.tr('inspection.notFoundTitle'),
            body: state.tr('inspection.notFoundBody'),
            icon: Icons.assignment_late_outlined,
            action: FilledButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false),
              child: Text(state.tr('inspection.notFoundCta')),
            ),
          ),
        ],
      );
    }

    final property = state.propertyById(report.propertyId);
    final allItems = report.checklist.expand((group) => group.items).toList();
    final counts = <String, int>{'ok': 0, 'followup': 0, 'repair': 0};
    for (final item in allItems) {
      counts[item.result] = (counts[item.result] ?? 0) + 1;
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _PageSection(
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property == null ? '—' : state.text(property.name),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpace.xxs),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSpace.xxs,
                            runSpacing: AppSpace.xxs,
                            children: [
                              Text(
                                '${state.tr('inspection.reportNo')}:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onSurfaceMuted,
                                    ),
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  report.reference,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    _ScoreBadge(score: report.score, label: state.text(report.overallLabel)),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                _ReportMeta(
                  date: formatDate(report.inspectionDate, state.language),
                  inspector: state.text(report.inspectorName),
                ),
                const SizedBox(height: AppSpace.md),
                Text(
                  state.text(report.summary),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpace.md),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.tr('inspection.shareUnavailable'))),
                    ),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(state.tr('inspection.share')),
                  ),
                ),
              ],
            ),
          ),
        ),
        _PageSection(
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeading(state.tr('inspection.legend')),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: AppSpace.sm,
                  children: [
                    _LegendEntry(result: 'ok', count: counts['ok'] ?? 0),
                    _LegendEntry(result: 'followup', count: counts['followup'] ?? 0),
                    _LegendEntry(result: 'repair', count: counts['repair'] ?? 0),
                  ],
                ),
              ],
            ),
          ),
        ),
        _PageSection(
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeading(
                  state.tr('inspection.resultsTitle'),
                  trailing: Text(
                    '${allItems.length} ${state.tr('inspection.itemResults')}',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceMuted,
                        ),
                  ),
                ),
                for (var groupIndex = 0;
                    groupIndex < report.checklist.length;
                    groupIndex++) ...[
                  if (groupIndex > 0) const Divider(height: AppSpace.lg),
                  _ChecklistGroup(group: report.checklist[groupIndex]),
                ],
                const SizedBox(height: AppSpace.sm),
                Text(
                  state.tr('inspection.findingsNote'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                ),
              ],
            ),
          ),
        ),
        _PageSection(
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeading(state.tr('inspection.notesTitle')),
                Text(state.text(report.notes), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
        if (report.issuePhotos.isNotEmpty)
          _PageSection(
            child: SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeading(state.tr('inspection.photosTitle')),
                  for (final photo in report.issuePhotos) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.sm),
                      child: Text(
                        state.text(photo.caption),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _IssuePhotoSlot(
                            path: photo.before,
                            label: state.tr('inspection.before'),
                          ),
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: photo.after == null || photo.after!.isEmpty
                              ? _PendingPhotoSlot(label: state.tr('inspection.after'))
                              : _IssuePhotoSlot(
                                  path: photo.after!,
                                  label: state.tr('inspection.after'),
                                ),
                        ),
                      ],
                    ),
                    if (photo != report.issuePhotos.last)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpace.md),
                        child: Divider(height: 1),
                      ),
                  ],
                ],
              ),
            ),
          ),
        if (report.images.isNotEmpty)
          _PageSection(
            child: SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeading(
                    state.tr('property.gallery'),
                    trailing: Text(
                      '${report.images.length} ${state.tr('inspection.photoCount')}',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceMuted,
                          ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth < 340 ? 2 : 3;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: report.images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: AppSpace.xs,
                          mainAxisSpacing: AppSpace.xs,
                          childAspectRatio: 1.15,
                        ),
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: LocalAssetImage(
                            path: report.images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        _PageSection(
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeading(state.tr('inspection.recommendationsTitle')),
                if (report.recommendations.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
                    child: Text(
                      state.tr('inspection.noRecommendations'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceMuted,
                          ),
                    ),
                  )
                else
                  for (var index = 0; index < report.recommendations.length; index++) ...[
                    _RecommendationRow(recommendation: report.recommendations[index]),
                    if (index < report.recommendations.length - 1)
                      const Divider(height: AppSpace.lg),
                  ],
                const SizedBox(height: AppSpace.md),
                Container(
                  padding: const EdgeInsets.all(AppSpace.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        state.tr('inspection.estimatedCost'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceMuted,
                            ),
                      ),
                      const SizedBox(height: AppSpace.xxs),
                      Text(
                        formatMoney(report.estimatedCostTotal, state.language),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpace.sm),
                if (report.estimatedCostTotal == null)
                  InlineNotice(
                    title: state.tr('inspection.estimatedCost'),
                    body: state.tr('inspection.costNotProvided'),
                    tone: NoticeTone.warning,
                  )
                else
                  Text(
                    state.tr('inspection.costProvided'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceMuted,
                        ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.md),
      ],
    );
  }
}

class _PageSection extends StatelessWidget {
  const _PageSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.screen,
          AppSpace.sm,
          AppSpace.screen,
          AppSpace.sm,
        ),
        child: child,
      );
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score, required this.label});

  final int score;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 76, maxWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: AppSpace.xs),
      decoration: BoxDecoration(
        color: AppColors.accentTint,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score',
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.accentStrong,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.accentStrong,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReportMeta extends StatelessWidget {
  const _ReportMeta({required this.date, required this.inspector});

  final String date;
  final String inspector;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      children: [
        _MetaRow(
          icon: Icons.calendar_month_outlined,
          label: state.tr('inspection.inspectionDate'),
          value: date,
        ),
        const SizedBox(height: AppSpace.xs),
        _MetaRow(
          icon: Icons.person_outline,
          label: state.tr('inspection.inspectedBy'),
          value: inspector,
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpace.xs),
          Expanded(
            child: Wrap(
              spacing: AppSpace.xs,
              runSpacing: 0,
              children: [
                Text(
                  '$label:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                ),
                Text(value, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      );
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.result, required this.count});

  final String result;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ResultBadge(result: result),
          const SizedBox(width: AppSpace.xs),
          Text('$count', style: Theme.of(context).textTheme.titleMedium),
        ],
      );
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final (foreground, background, icon) = switch (result) {
      'ok' => (AppColors.success, AppColors.successTint, Icons.check_circle_outline),
      'followup' => (AppColors.warning, AppColors.warningTint, Icons.schedule_outlined),
      'repair' => (AppColors.danger, AppColors.dangerTint, Icons.build_outlined),
      _ => (AppColors.onSurfaceMuted, AppColors.surfaceMuted, Icons.help_outline),
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs, vertical: AppSpace.xxs),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: foreground),
          const SizedBox(width: AppSpace.xxs),
          Text(
            state.tr('inspectionResult.$result'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistGroup extends StatelessWidget {
  const _ChecklistGroup({required this.group});

  final ChecklistGroupModel group;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.xs),
          child: Text(
            state.tr('inspection.categories.${group.category}'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        for (var index = 0; index < group.items.length; index++) ...[
          if (index > 0) const Divider(height: AppSpace.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpace.xs, top: AppSpace.xxs),
                  child: Text(
                    state.text(group.items[index].label),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: _ResultBadge(result: group.items[index].result),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _IssuePhotoSlot extends StatelessWidget {
  const _IssuePhotoSlot({required this.path, required this.label});

  final String path;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: LocalAssetImage(path: path, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppSpace.xxs),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class _PendingPhotoSlot extends StatelessWidget {
  const _PendingPhotoSlot({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_outlined, color: AppColors.onSurfaceMuted),
                    const SizedBox(height: AppSpace.xxs),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.xxs),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class _RecommendationRow extends StatelessWidget {
  const _RecommendationRow({required this.recommendation});

  final RecommendationModel recommendation;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.text(recommendation.label), style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpace.xxs),
          Wrap(
            spacing: AppSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.payments_outlined, size: 17, color: AppColors.onSurfaceMuted),
              Text(
                recommendation.estimatedCost == null
                    ? state.tr('inspection.costNotProvided')
                    : formatMoney(recommendation.estimatedCost, state.language),
                textDirection: recommendation.estimatedCost == null
                    ? null
                    : TextDirection.ltr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
