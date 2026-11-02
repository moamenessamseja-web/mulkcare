import 'package:flutter/material.dart';

import '../core/widgets.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpace.screen),
      children: [
        const SizedBox(height: AppSpace.xl),
        EmptyState(
          icon: Icons.explore_off_outlined,
          title: state.tr('notFound.title'),
          body: state.tr('notFound.body'),
          action: FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
            icon: const Icon(Icons.home_outlined),
            label: Text(state.tr('notFound.cta')),
          ),
        ),
      ],
    );
  }
}
