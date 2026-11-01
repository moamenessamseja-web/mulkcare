import 'package:flutter/material.dart';

import '../app_state.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'admin_screen.dart';
import 'unit_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final showAdmin = state.isAdmin;
    final onAdminTab = showAdmin && _tab == 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(onAdminTab
            ? Ar.admin
            : (showAdmin ? Ar.allUnits : Ar.myUnits)),
        actions: [
          IconButton(
            key: const Key('sign-out'),
            tooltip: Ar.signOut,
            icon: const Icon(Icons.logout),
            onPressed: state.signOut,
          ),
        ],
      ),
      body: onAdminTab ? const AdminScreen() : const _UnitList(),
      bottomNavigationBar: showAdmin
          ? NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (i) => setState(() => _tab = i),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_outlined), label: Ar.home),
                NavigationDestination(
                    icon: Icon(Icons.admin_panel_settings_outlined),
                    label: Ar.admin),
              ],
            )
          : null,
    );
  }
}

class _UnitList extends StatelessWidget {
  const _UnitList();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final units = state.visibleUnits;
    if (units.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpace.screen),
        child: EmptyNote(Ar.noUnits),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpace.screen),
      itemCount: units.length,
      separatorBuilder: (c, i) => const SizedBox(height: AppSpace.gutter),
      itemBuilder: (context, i) {
        final u = units[i];
        return AppCard(
          padding: const EdgeInsets.all(AppSpace.sm),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (_) => UnitDetailScreen(unitId: u.id)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UnitImage(asset: u.imageAsset, height: 160),
              const SizedBox(height: AppSpace.sm),
              Text(u.name, style: AppText.h3),
              Text('${Ar.kind(u.kind)} · ${u.location}',
                  style: AppText.caption),
              const SizedBox(height: AppSpace.xs),
              OccupancyChip(status: u.status),
            ],
          ),
        );
      },
    );
  }
}
