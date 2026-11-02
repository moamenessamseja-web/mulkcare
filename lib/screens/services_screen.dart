import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/format.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

const _serviceCategories = <String>[
  'general',
  'plumbing',
  'electrical',
  'hvac',
  'cleaning',
  'pest',
  'other',
];

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<String> _imagePaths = [];
  final Map<String, String> _errors = {};

  String? _propertyId;
  String? _category;
  String? _formError;
  String? _openRequestId;
  DateTime? _preferredDate;
  TimeOfDay _preferredTime = const TimeOfDay(hour: 10, minute: 0);
  bool _submitting = false;
  bool _actionPending = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  String _timeString(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  bool _validate(AppState state) {
    final next = <String, String>{};
    if (_propertyId == null || _propertyId!.isEmpty) {
      next['propertyId'] = 'services.errProperty';
    }
    if (_category == null || _category!.isEmpty) {
      next['category'] = 'services.errCategory';
    }
    if (_descriptionController.text.trim().length < 10) {
      next['description'] = 'services.errDescription';
    }
    final now = cairoNow();
    final today = cairoCalendarDate(now.year, now.month, now.day);
    if (_preferredDate == null ||
        cairoCalendarDate(_preferredDate!.year, _preferredDate!.month, _preferredDate!.day).isBefore(today)) {
      next['preferredDate'] = 'services.errDate';
    }
    setState(() {
      _errors
        ..clear()
        ..addAll(next);
      _formError = next.isEmpty ? null : 'services.errSubmit';
    });
    return next.isEmpty;
  }

  Future<void> _chooseDate() async {
    final now = cairoNow();
    final today = cairoCalendarDate(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _preferredDate ?? today,
      firstDate: today,
      lastDate: cairoCalendarDate(today.year + 10, today.month, today.day),
    );
    if (picked != null && mounted) {
      setState(() {
        _preferredDate = cairoCalendarDate(picked.year, picked.month, picked.day);
        _errors.remove('preferredDate');
        if (_errors.isEmpty) _formError = null;
      });
    }
  }

  Future<void> _chooseTime() async {
    final picked = await showTimePicker(context: context, initialTime: _preferredTime);
    if (picked != null && mounted) setState(() => _preferredTime = picked);
  }

  Future<void> _addPhoto() async {
    if (_imagePaths.length >= 4) return;
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() => _imagePaths.add(picked.path));
      }
    } catch (_) {
      if (mounted) _showMessage(context.readState().tr('services.uploadNotice'));
    }
  }

  Future<void> _submit(AppState state) async {
    if (!_validate(state)) return;
    setState(() {
      _submitting = true;
      _formError = null;
    });
    final selectedDate = _preferredDate!;
    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      _preferredTime.hour,
      _preferredTime.minute,
    );
    final errorKey = state.createServiceRequest(
      propertyId: _propertyId!,
      category: _category!,
      description: _descriptionController.text,
      preferredDate: dateTime,
      preferredTime: _timeString(_preferredTime),
      imagePaths: List<String>.unmodifiable(_imagePaths.take(4)),
    );
    if (!mounted) return;
    if (errorKey == null) {
      setState(() {
        _propertyId = null;
        _category = null;
        _descriptionController.clear();
        _preferredDate = null;
        _preferredTime = const TimeOfDay(hour: 10, minute: 0);
        _imagePaths.clear();
        _errors.clear();
        _openRequestId = state.serviceRequests.first.id;
      });
      _showMessage(state.tr('services.successSubmit'));
    } else {
      setState(() => _formError = errorKey);
    }
    setState(() => _submitting = false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmTransition(
    AppState state,
    ServiceRequestModel request,
    String action,
  ) async {
    final isApprove = action == 'approve';
    final isReject = action == 'reject';
    final titleKey = isApprove
        ? 'services.approveConfirmTitle'
        : isReject
            ? 'services.rejectConfirmTitle'
            : 'services.cancelConfirmTitle';
    final bodyKey = isApprove
        ? 'services.approveConfirmBody'
        : isReject
            ? 'services.rejectConfirmBody'
            : 'services.cancelConfirmBody';
    final confirmKey = isApprove
        ? 'services.approve'
        : isReject
            ? 'services.reject'
            : 'services.cancelRequest';
    final nextStatus = isApprove ? 'approved' : 'cancelled';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(state.tr(titleKey)),
        content: Text(state.tr(bodyKey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(state.tr('common.cancel')),
          ),
          FilledButton(
            style: (isReject || action == 'cancel')
                ? FilledButton.styleFrom(
                    backgroundColor: AppColors.danger,
                    foregroundColor: AppColors.onBrand,
                  )
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(state.tr(confirmKey)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _actionPending = true);
    final succeeded = state.transitionRequest(request.id, nextStatus);
    if (!mounted) return;
    setState(() => _actionPending = false);
    if (succeeded) {
      final messageKey = isApprove
          ? 'services.approveSuccess'
          : isReject
              ? 'services.rejectSuccess'
              : 'services.cancelSuccess';
      _showMessage(state.tr(messageKey));
    } else {
      _showMessage(state.tr('services.actionUnavailable'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final properties = state.properties;
    final requests = [...state.serviceRequests]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (_propertyId != null && !properties.any((property) => property.id == _propertyId)) {
      _propertyId = null;
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.screen, AppSpace.md, AppSpace.screen, AppSpace.xl),
      children: [
        Text(state.tr('services.title'), style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpace.lg),
        SectionHeading(state.tr('services.categoriesTitle')),
        SurfaceCard(
          padding: const EdgeInsets.all(AppSpace.sm),
          child: Wrap(
            spacing: AppSpace.xs,
            runSpacing: AppSpace.xs,
            children: [
              for (final category in _serviceCategories)
                ChoiceChip(
                  avatar: Icon(_categoryIcon(category), size: 18),
                  label: Text(state.tr('services.categories.$category')),
                  selected: _category == category,
                  onSelected: (_) => setState(() {
                    _category = category;
                    _errors.remove('category');
                    if (_errors.isEmpty) _formError = null;
                  }),
                ),
            ],
          ),
        ),
        if (_errors['category'] != null) ...[
          const SizedBox(height: AppSpace.xxs),
          _ErrorText(state.tr(_errors['category']!)),
        ],
        const SizedBox(height: AppSpace.lg),
        SectionHeading(state.tr('services.formTitle')),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_formError != null) ...[
                _ErrorBanner(message: state.tr(_formError!)),
                const SizedBox(height: AppSpace.md),
              ],
              DropdownButtonFormField<String>(
                initialValue: _propertyId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: state.tr('services.property'),
                  hintText: state.tr('services.propertyPh'),
                  errorText: _errors['propertyId'] == null ? null : state.tr(_errors['propertyId']!),
                ),
                items: [
                  for (final property in properties)
                    DropdownMenuItem<String>(
                      value: property.id,
                      child: Text(state.text(property.name), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) => setState(() {
                  _propertyId = value;
                  _errors.remove('propertyId');
                  if (_errors.isEmpty) _formError = null;
                }),
              ),
              const SizedBox(height: AppSpace.md),
              DropdownButtonFormField<String>(
                initialValue: _category,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: state.tr('services.category'),
                  hintText: state.tr('services.categoryPh'),
                  errorText: _errors['category'] == null ? null : state.tr(_errors['category']!),
                ),
                items: [
                  for (final category in _serviceCategories)
                    DropdownMenuItem<String>(
                      value: category,
                      child: Text(state.tr('services.categories.$category'), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) => setState(() {
                  _category = value;
                  _errors.remove('category');
                  if (_errors.isEmpty) _formError = null;
                }),
              ),
              const SizedBox(height: AppSpace.md),
              TextField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: state.tr('services.description'),
                  hintText: state.tr('services.descriptionPh'),
                  alignLabelWithHint: true,
                  errorText: _errors['description'] == null ? null : state.tr(_errors['description']!),
                ),
                onChanged: (_) {
                  if (_errors.containsKey('description')) {
                    setState(() {
                      _errors.remove('description');
                      if (_errors.isEmpty) _formError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpace.lg),
              Text(state.tr('services.photos'), style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpace.xs),
              if (_imagePaths.isNotEmpty)
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagePaths.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpace.xs),
                    itemBuilder: (context, index) => _SelectedPhoto(
                      path: _imagePaths[index],
                      removeLabel: state.tr('services.removePhoto'),
                      onRemove: () => setState(() => _imagePaths.removeAt(index)),
                    ),
                  ),
                ),
              if (_imagePaths.length < 4)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    onPressed: _addPhoto,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(state.tr('services.addPhoto')),
                  ),
                ),
              const SizedBox(height: AppSpace.xxs),
              Text(state.tr('services.photosHint'), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpace.md),
              _DateTimeField(
                label: state.tr('services.preferredDate'),
                value: _preferredDate == null ? null : formatDate(_preferredDate, state.language),
                error: _errors['preferredDate'] == null ? null : state.tr(_errors['preferredDate']!),
                icon: Icons.calendar_today_outlined,
                onTap: _chooseDate,
              ),
              const SizedBox(height: AppSpace.md),
              _DateTimeField(
                label: state.tr('services.preferredTime'),
                value: _timeString(_preferredTime),
                icon: Icons.schedule_outlined,
                onTap: _chooseTime,
                forceLtr: true,
              ),
              const SizedBox(height: AppSpace.md),
              InlineNotice(
                title: state.tr('services.photos'),
                body: state.tr('services.uploadNotice'),
              ),
              const SizedBox(height: AppSpace.md),
              FilledButton.icon(
                onPressed: _submitting ? null : () => _submit(state),
                icon: _submitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(state.tr(_submitting ? 'common.submitting' : 'services.submitRequest')),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xl),
        SectionHeading(
          state.tr('services.trackingTitle'),
          trailing: Text('${requests.length} ${state.tr('services.countLabel')}',
              style: Theme.of(context).textTheme.bodySmall),
        ),
        if (requests.isEmpty)
          EmptyState(
            title: state.tr('services.emptyTitle'),
            body: state.tr('services.emptyBody'),
            icon: Icons.handyman_outlined,
          )
        else
          for (final request in requests) ...[
            _RequestCard(
              request: request,
              property: state.propertyById(request.propertyId),
              expanded: _openRequestId == request.id,
              actionPending: _actionPending,
              onToggle: () => setState(() {
                _openRequestId = _openRequestId == request.id ? null : request.id;
              }),
              onAction: (action) => _confirmTransition(state, request, action),
            ),
            const SizedBox(height: AppSpace.sm),
          ],
      ],
    );
  }

  IconData _categoryIcon(String category) => switch (category) {
        'plumbing' => Icons.plumbing_outlined,
        'electrical' => Icons.electrical_services_outlined,
        'hvac' => Icons.ac_unit_outlined,
        'cleaning' => Icons.cleaning_services_outlined,
        'pest' => Icons.pest_control_outlined,
        'other' => Icons.home_repair_service_outlined,
        _ => Icons.handyman_outlined,
      };
}

extension on BuildContext {
  AppState readState() => AppState.of(this);
}

class _SelectedPhoto extends StatelessWidget {
  const _SelectedPhoto({required this.path, required this.removeLabel, required this.onRemove});

  final String path;
  final String removeLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Image.file(
              File(path),
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 88,
                height: 88,
                color: AppColors.surfaceMuted,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, color: AppColors.onSurfaceMuted),
              ),
            ),
          ),
          PositionedDirectional(
            top: 2,
            end: 2,
            child: Semantics(
              label: removeLabel,
              button: true,
              child: Material(
                color: AppColors.surface.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 16, color: AppColors.danger),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.error,
    this.forceLtr = false,
  });

  final String label;
  final String? value;
  final String? error;
  final IconData icon;
  final VoidCallback onTap;
  final bool forceLtr;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpace.xxs),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value ?? label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: forceLtr ? TextDirection.ltr : null,
              ),
            ),
            style: OutlinedButton.styleFrom(alignment: AlignmentDirectional.centerStart),
          ),
          if (error != null) ...[
            const SizedBox(height: AppSpace.xxs),
            _ErrorText(error!),
          ],
        ],
      );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String message;

  @override
  Widget build(BuildContext context) => Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.danger),
      );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: AppColors.dangerTint,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
            const SizedBox(width: AppSpace.xs),
            Expanded(child: Text(message, style: const TextStyle(color: AppColors.danger))),
          ],
        ),
      );
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.property,
    required this.expanded,
    required this.actionPending,
    required this.onToggle,
    required this.onAction,
  });

  final ServiceRequestModel request;
  final PropertyModel? property;
  final bool expanded;
  final bool actionPending;
  final VoidCallback onToggle;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final canApprove = state.canTransition(request.status, 'approved');
    final canCancel = state.canTransition(request.status, 'cancelled');
    final propertyName = property == null ? '—' : state.text(property!.name);

    return SurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.tr('services.categories.${request.category}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpace.xs),
                        Icon(expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.onSurfaceMuted),
                      ],
                    ),
                    const SizedBox(height: AppSpace.xs),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpace.sm,
                      runSpacing: AppSpace.xs,
                      children: [
                        Text(
                          '${request.reference} · $propertyName',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        StatusChip(status: request.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(state.text(request.description), style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpace.md),
                  _RequestDetails(request: request),
                  if (request.images.isNotEmpty) ...[
                    const SizedBox(height: AppSpace.md),
                    Text(state.tr('services.photos'), style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpace.xs),
                    SizedBox(
                      height: 88,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: request.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpace.xs),
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: Image.file(
                            File(request.images[index]),
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 88,
                              height: 88,
                              color: AppColors.surfaceMuted,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpace.lg),
                  Text(state.tr('services.technicianUpdates'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpace.xs),
                  if (request.updates.isEmpty)
                    Text(state.tr('services.noUpdates'), style: Theme.of(context).textTheme.bodySmall)
                  else
                    for (final update in request.updates)
                      _UpdateRow(update: update),
                  const SizedBox(height: AppSpace.md),
                  if (canApprove || canCancel)
                    Wrap(
                      spacing: AppSpace.xs,
                      runSpacing: AppSpace.xs,
                      children: [
                        if (canApprove)
                          FilledButton(
                            onPressed: actionPending ? null : () => onAction('approve'),
                            child: Text(state.tr('services.approve')),
                          ),
                        if (canApprove)
                          OutlinedButton(
                            onPressed: actionPending ? null : () => onAction('reject'),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                            child: Text(state.tr('services.reject')),
                          ),
                        if (canCancel)
                          TextButton(
                            onPressed: actionPending ? null : () => onAction('cancel'),
                            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                            child: Text(state.tr('services.cancelRequest')),
                          ),
                      ],
                    )
                  else
                    Text(state.tr('services.actionUnavailable'), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequestDetails extends StatelessWidget {
  const _RequestDetails({required this.request});
  final ServiceRequestModel request;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final appointment = request.preferredDate == null
        ? state.tr('services.noAppointment')
        : '${formatDate(request.preferredDate, state.language)} · ${request.preferredTime ?? formatTime(request.preferredDate)}';
    return Wrap(
      spacing: AppSpace.lg,
      runSpacing: AppSpace.md,
      children: [
        _DetailValue(
          label: state.tr('services.submittedAt'),
          value: '${formatDate(request.createdAt, state.language)} · ${formatTime(request.createdAt)}',
        ),
        _DetailValue(label: state.tr('services.appointment'), value: appointment),
        _DetailValue(
          label: state.tr('services.estimate'),
          value: request.estimatedCost == null
              ? state.tr('services.noEstimate')
              : formatMoney(request.estimatedCost, state.language),
        ),
        if (request.finalCost != null)
          _DetailValue(
            label: state.tr('services.finalCost'),
            value: formatMoney(request.finalCost, state.language),
          ),
      ],
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpace.xxs),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
}

class _UpdateRow extends StatelessWidget {
  const _UpdateRow({required this.update});
  final RequestUpdate update;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(top: 6, end: AppSpace.xs),
            child: Icon(Icons.circle, size: 8, color: AppColors.secondary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.text(update.text)),
                const SizedBox(height: AppSpace.xxs),
                Text(
                  '${formatDate(update.at, state.language)} · ${formatTime(update.at)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
