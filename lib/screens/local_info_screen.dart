import 'package:flutter/material.dart';

import '../core/widgets.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class LocalInfoScreen extends StatefulWidget {
  const LocalInfoScreen({super.key});

  @override
  State<LocalInfoScreen> createState() => _LocalInfoScreenState();
}

class _LocalInfoScreenState extends State<LocalInfoScreen> {
  static const List<String> _categories = [
    'pharmacy',
    'clinic',
    'supermarket',
    'essentials',
    'transport',
    'places',
  ];

  static const Map<String, IconData> _categoryIcons = {
    'pharmacy': Icons.medication_outlined,
    'clinic': Icons.medical_services_outlined,
    'supermarket': Icons.shopping_cart_outlined,
    'essentials': Icons.handyman_outlined,
    'transport': Icons.directions_bus_outlined,
    'places': Icons.map_outlined,
  };

  String _query = '';
  String _activeCategory = 'pharmacy';

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleCategories = _categories.where((category) {
      if (normalizedQuery.isEmpty) return true;
      final label = state.tr('local.categories.$category');
      final note = state.tr('local.categoryNotes.$category');
      return '$label $note'.toLowerCase().contains(normalizedQuery);
    }).toList();
    final hasProperties = state.properties.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.screen,
        AppSpace.lg,
        AppSpace.screen,
        AppSpace.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.tr('local.title'), style: Theme.of(context).textTheme.headlineMedium),
          if (hasProperties) ...[
            const SizedBox(height: AppSpace.xs),
            Text(
              state.tr('local.categoryNotes.essentials'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpace.md),
          TextField(
            textDirection: Directionality.of(context),
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: state.tr('local.searchPh'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: state.tr('local.clearSearch'),
                      onPressed: () => setState(() => _query = ''),
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          InlineNotice(
            title: state.tr('local.noSourceTitle'),
            body: state.tr('local.noSourceBody'),
            tone: NoticeTone.warning,
          ),
          const SizedBox(height: AppSpace.lg),
          SectionHeading(
            state.tr('local.categoriesTitle'),
            trailing: Text(
              '${visibleCategories.length} ${state.tr('local.countLabel')}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
          if (visibleCategories.isEmpty)
            EmptyState(
              title: state.tr('local.emptyTitle'),
              body: state.tr('local.emptyBody'),
              icon: Icons.search_off_outlined,
              action: OutlinedButton.icon(
                onPressed: () => setState(() => _query = ''),
                icon: const Icon(Icons.close),
                label: Text(state.tr('local.clearSearch')),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 720 ? 3 : 2;
                const spacing = AppSpace.sm;
                final tileWidth =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final category in visibleCategories)
                      SizedBox(
                        width: tileWidth,
                        child: _CategoryTile(
                          label: state.tr('local.categories.$category'),
                          icon: _categoryIcons[category]!,
                          selected: _activeCategory == category,
                          onTap: () => setState(() => _activeCategory = category),
                        ),
                      ),
                  ],
                );
              },
            ),
          if (visibleCategories.isNotEmpty) ...[
            const SizedBox(height: AppSpace.lg),
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    state.tr('local.categories.$_activeCategory'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Text(
                    state.tr('local.categoryNotes.$_activeCategory'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (state.user != null) ...[
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      state.tr('local.howToBody'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: AppSpace.md),
                  FilledButton.icon(
                    onPressed: () {
                      state.requestLocalRecommendation(
                        state.tr('local.categories.$_activeCategory'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.tr('local.requestSuccess')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_outlined),
                    label: Text(state.tr('local.requestRecommendation')),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpace.lg),
          SectionHeading(state.tr('local.mapTitle')),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.all(AppSpace.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 32,
                  color: AppColors.onSurfaceMuted,
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  state.tr('local.mapPlaceholder'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.primary : AppColors.onSurfaceMuted;
    return Material(
      color: selected ? AppColors.primaryTint : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 92),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.sm,
              vertical: AppSpace.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 22, color: foreground),
                const SizedBox(height: AppSpace.xs),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: foreground,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
