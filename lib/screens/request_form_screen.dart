import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../strings.dart';
import '../theme.dart';

class RequestFormScreen extends StatefulWidget {
  final String unitId;
  const RequestFormScreen({super.key, required this.unitId});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _notes = TextEditingController();
  ServiceType _type = ServiceType.cleaning;
  String? _error;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    final state = AppScope.of(context);
    final r = state.createRequest(
        unitId: widget.unitId, type: _type, notes: _notes.text);
    if (r == null) {
      setState(() => _error = Ar.errNotes);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text(Ar.requestSent)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Ar.newRequest)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.screen),
        children: [
          const Text(Ar.serviceType, style: AppText.label),
          const SizedBox(height: AppSpace.xs),
          Wrap(
            spacing: AppSpace.xs,
            runSpacing: AppSpace.xs,
            children: [
              for (final t in ServiceType.values)
                ChoiceChip(
                  key: Key('type-${t.name}'),
                  label: Text(Ar.service(t)),
                  labelStyle: AppText.label.copyWith(
                      color: t == _type
                          ? AppColors.onBrand
                          : AppColors.text),
                  selected: t == _type,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  showCheckmark: false,
                  shape: const StadiumBorder(
                      side: BorderSide(color: AppColors.border)),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onSelected: (_) => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          const Text(Ar.notes, style: AppText.label),
          const SizedBox(height: AppSpace.xs),
          TextField(
            key: const Key('notes'),
            controller: _notes,
            minLines: 4,
            maxLines: 8,
            decoration: const InputDecoration(hintText: Ar.notesHint),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpace.sm),
            Text(_error!,
                key: const Key('request-error'),
                style: AppText.label.copyWith(color: AppColors.danger)),
          ],
          const SizedBox(height: AppSpace.lg),
          FilledButton(
            key: const Key('submit-request'),
            onPressed: _submit,
            child: const Text(Ar.submitRequest),
          ),
        ],
      ),
    );
  }
}
