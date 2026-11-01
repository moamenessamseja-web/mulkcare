import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../models.dart';
import '../strings.dart';
import '../theme.dart';
import '../widgets.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  RequestStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final requests = state.allRequests(status: _filter);
    return ListView(
      padding: const EdgeInsets.all(AppSpace.screen),
      children: [
        const SectionTitle(Ar.allRequests),
        Wrap(
          spacing: AppSpace.xs,
          runSpacing: AppSpace.xs,
          children: [
            _filterChip(null, Ar.filterAll),
            for (final s in RequestStatus.values)
              _filterChip(s, Ar.status(s)),
          ],
        ),
        const SizedBox(height: AppSpace.md),
        if (requests.isEmpty)
          const EmptyNote(Ar.noRequestsAdmin)
        else
          for (final r in requests)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.sm),
              child: AppCard(
                onTap: () => _openSheet(context, r.id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                              '${Ar.service(r.type)} · ${state.unitById(r.unitId)?.name ?? ''}',
                              style: AppText.h3),
                        ),
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
      ],
    );
  }

  Widget _filterChip(RequestStatus? s, String label) {
    final selected = _filter == s;
    return ChoiceChip(
      key: Key('filter-${s?.name ?? 'all'}'),
      label: Text(label),
      labelStyle: AppText.label.copyWith(
          color: selected ? AppColors.onBrand : AppColors.text),
      selected: selected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      showCheckmark: false,
      shape: const StadiumBorder(side: BorderSide(color: AppColors.border)),
      onSelected: (_) => setState(() => _filter = s),
    );
  }

  void _openSheet(BuildContext context, String requestId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) => _RequestSheet(requestId: requestId),
    );
  }
}

class _RequestSheet extends StatefulWidget {
  final String requestId;
  const _RequestSheet({required this.requestId});

  @override
  State<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends State<_RequestSheet> {
  final _amount = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _addInvoice() {
    final state = AppScope.of(context);
    final amount = int.tryParse(_amount.text.trim()) ?? 0;
    final inv = state.addInvoice(requestId: widget.requestId, amount: amount);
    setState(() {
      if (inv == null) {
        _error = Ar.errAmount;
      } else {
        _error = null;
        _amount.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    ServiceRequest? req;
    for (final r in state.allRequests()) {
      if (r.id == widget.requestId) req = r;
    }
    if (req == null) return const SizedBox.shrink();
    final ServiceRequest current = req;
    final invoices = state.invoicesForRequest(current.id);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpace.screen,
        AppSpace.lg,
        AppSpace.screen,
        AppSpace.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${Ar.service(current.type)} · ${formatRequestNumber(current.number)}',
                style: AppText.h2),
            Text(current.notes, style: AppText.body),
            const SizedBox(height: AppSpace.md),
            const Text(Ar.changeStatus, style: AppText.label),
            const SizedBox(height: AppSpace.xs),
            Wrap(
              spacing: AppSpace.xs,
              runSpacing: AppSpace.xs,
              children: [
                for (final s in RequestStatus.values)
                  ChoiceChip(
                    key: Key('status-${s.name}'),
                    label: Text(Ar.status(s)),
                    labelStyle: AppText.label.copyWith(
                        color: current.status == s
                            ? AppColors.onBrand
                            : AppColors.text),
                    selected: current.status == s,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    showCheckmark: false,
                    shape: const StadiumBorder(
                        side: BorderSide(color: AppColors.border)),
                    onSelected: (_) =>
                        state.setRequestStatus(current.id, s),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.md),
            const Text(Ar.invoices, style: AppText.label),
            const SizedBox(height: AppSpace.xs),
            for (final inv in invoices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.xs),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(formatMoney(inv.amount),
                            style: AppText.body)),
                    PaidChip(paid: inv.paid),
                    TextButton(
                      key: Key('toggle-paid-${inv.id}'),
                      onPressed: () =>
                          state.setInvoicePaid(inv.id, !inv.paid),
                      child: Text(inv.paid ? Ar.markUnpaid : Ar.markPaid,
                          style: AppText.label
                              .copyWith(color: AppColors.secondaryStrong)),
                    ),
                  ],
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('invoice-amount'),
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(labelText: Ar.amount),
                  ),
                ),
                const SizedBox(width: AppSpace.sm),
                FilledButton(
                  key: const Key('add-invoice'),
                  onPressed: _addInvoice,
                  child: const Text(Ar.addInvoice),
                ),
              ],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpace.xs),
                child: Text(_error!,
                    key: const Key('invoice-error'),
                    style: AppText.label.copyWith(color: AppColors.danger)),
              ),
          ],
        ),
      ),
    );
  }
}
