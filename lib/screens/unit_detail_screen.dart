import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'request_form_screen.dart';

class UnitDetailScreen extends StatelessWidget {
  final String unitId;
  const UnitDetailScreen({super.key, required this.unitId});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final unit = state.unitById(unitId);
    if (unit == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Padding(
          padding: EdgeInsets.all(AppSpace.screen),
          child: EmptyNote(Ar.noUnits),
        ),
      );
    }
    final requests = state.requestsFor(unitId);
    final invoices = state.invoicesFor(unitId);
    return Scaffold(
      appBar: AppBar(title: Text(unit.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.screen),
        children: [
          UnitImage(
              asset: unit.imageAsset, height: 200, radius: AppRadius.xl),
          const SizedBox(height: AppSpace.md),
          Text(unit.name, style: AppText.h1),
          Text('${Ar.kind(unit.kind)} · ${unit.location}',
              style: AppText.caption),
          const SizedBox(height: AppSpace.xs),
          OccupancyChip(status: unit.status),
          const SizedBox(height: AppSpace.lg),
          const SectionTitle(Ar.requestsHistory),
          if (requests.isEmpty)
            const EmptyNote(Ar.noRequests)
          else
            for (final r in requests)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.sm),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(Ar.service(r.type),
                                  style: AppText.h3)),
                          RequestStatusChip(status: r.status),
                        ],
                      ),
                      Text(r.notes, style: AppText.body),
                      Text(
                          '${formatRequestNumber(r.number)} · ${formatDate(r.createdAt)}',
                          style: AppText.caption),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: AppSpace.lg),
          const SectionTitle(Ar.invoices),
          if (invoices.isEmpty)
            const EmptyNote(Ar.noInvoices)
          else
            for (final inv in invoices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.sm),
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatMoney(inv.amount),
                                style: AppText.h3.copyWith(
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ])),
                            Text(formatDate(inv.createdAt),
                                style: AppText.caption),
                          ],
                        ),
                      ),
                      PaidChip(paid: inv.paid),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: AppSpace.actionRow),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: raisedShadow,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.screen, vertical: AppSpace.sm),
            child: FilledButton(
              key: const Key('new-request'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => RequestFormScreen(unitId: unitId)),
              ),
              child: const Text(Ar.newRequest),
            ),
          ),
        ),
      ),
    );
  }
}
