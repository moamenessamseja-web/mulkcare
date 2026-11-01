import 'package:flutter/widgets.dart';

import 'data/sample_data.dart';
import 'models.dart';
import 'strings.dart';

/// Stage 1 state: in-memory, demo sign-in. Real auth/persistence (Supabase +
/// SQLite) arrive in Stage 2 behind the same method names.
class AppState extends ChangeNotifier {
  AppState({
    List<PropertyUnit>? units,
    List<ServiceRequest>? requests,
    List<Invoice>? invoices,
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        _units = List<PropertyUnit>.of(units ?? sampleUnits()),
        _requests = [],
        _invoices = [] {
    final now = _clock();
    _requests.addAll(requests ?? sampleRequests(now));
    _invoices.addAll(invoices ?? sampleInvoices(now));
    for (final r in _requests) {
      if (r.number >= _nextNumber) _nextNumber = r.number + 1;
    }
  }

  final DateTime Function() _clock;
  final List<PropertyUnit> _units;
  final List<ServiceRequest> _requests;
  final List<Invoice> _invoices;
  int _nextNumber = 10430;
  int _nextInvoice = 100;
  UserProfile? _user;

  UserProfile? get user => _user;
  bool get isSignedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  /// Demo sign-in. Returns an Arabic error message, or null on success.
  /// Emails starting with "admin@" get the admin role (demo only).
  String? signIn({required String email, required String password}) {
    final e = email.trim();
    if (!_validEmail(e)) return Ar.errEmail;
    if (password.length < 6) return Ar.errPassword;
    final admin = e.toLowerCase().startsWith('admin@');
    _user = UserProfile(
      id: admin ? 'admin1' : 'owner1',
      name: admin ? 'فريق العناية' : 'المالك',
      email: e,
      isAdmin: admin,
    );
    notifyListeners();
    return null;
  }

  String? register({
    required String name,
    required String email,
    required String password,
  }) {
    if (name.trim().isEmpty) return Ar.errName;
    final err = signIn(email: email, password: password);
    if (err != null) return err;
    _user = UserProfile(
      id: _user!.id,
      name: name.trim(),
      email: _user!.email,
      isAdmin: _user!.isAdmin,
    );
    notifyListeners();
    return null;
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }

  bool _validEmail(String e) {
    final at = e.indexOf('@');
    return at > 0 && at < e.length - 3 && e.indexOf('.', at) > at + 1;
  }

  /// Owners see their own units; admins see all.
  List<PropertyUnit> get visibleUnits {
    final u = _user;
    if (u == null) return const [];
    if (u.isAdmin) return List.unmodifiable(_units);
    return List.unmodifiable(_units.where((x) => x.ownerId == u.id));
  }

  PropertyUnit? unitById(String id) {
    for (final u in _units) {
      if (u.id == id) return u;
    }
    return null;
  }

  List<ServiceRequest> requestsFor(String unitId) {
    final list = _requests.where((r) => r.unitId == unitId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Admin view: all requests, newest first, optional status filter.
  List<ServiceRequest> allRequests({RequestStatus? status}) {
    if (!isAdmin) return const [];
    final list = _requests
        .where((r) => status == null || r.status == status)
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<Invoice> invoicesFor(String unitId) {
    final list = _invoices.where((i) => i.unitId == unitId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<Invoice> invoicesForRequest(String requestId) =>
      _invoices.where((i) => i.requestId == requestId).toList();

  /// Creates a pending request. Returns null if the unit is not visible to the
  /// current user or notes are empty.
  ServiceRequest? createRequest({
    required String unitId,
    required ServiceType type,
    required String notes,
  }) {
    if (notes.trim().isEmpty) return null;
    if (!visibleUnits.any((u) => u.id == unitId)) return null;
    final r = ServiceRequest(
      id: 'r${_nextNumber}',
      number: _nextNumber,
      unitId: unitId,
      type: type,
      notes: notes.trim(),
      status: RequestStatus.pending,
      createdAt: _clock(),
    );
    _nextNumber += 1;
    _requests.add(r);
    notifyListeners();
    return r;
  }

  /// Admin only. Returns false when not allowed or request not found.
  bool setRequestStatus(String requestId, RequestStatus status) {
    if (!isAdmin) return false;
    final i = _requests.indexWhere((r) => r.id == requestId);
    if (i < 0) return false;
    _requests[i] = _requests[i].copyWith(status: status);
    notifyListeners();
    return true;
  }

  /// Admin only. Amount must be > 0. Returns the invoice or null.
  Invoice? addInvoice({required String requestId, required int amount}) {
    if (!isAdmin || amount <= 0) return null;
    final i = _requests.indexWhere((r) => r.id == requestId);
    if (i < 0) return null;
    final inv = Invoice(
      id: 'i$_nextInvoice',
      requestId: requestId,
      unitId: _requests[i].unitId,
      amount: amount,
      paid: false,
      createdAt: _clock(),
    );
    _nextInvoice += 1;
    _invoices.add(inv);
    notifyListeners();
    return inv;
  }

  /// Admin only.
  bool setInvoicePaid(String invoiceId, bool paid) {
    if (!isAdmin) return false;
    final i = _invoices.indexWhere((x) => x.id == invoiceId);
    if (i < 0) return false;
    _invoices[i] = _invoices[i].copyWith(paid: paid);
    notifyListeners();
    return true;
  }
}

/// Gives widgets access to the AppState and rebuilds them on change.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope missing above this widget');
    return scope!.notifier!;
  }
}
