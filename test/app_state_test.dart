import 'package:flutter_test/flutter_test.dart';
import 'package:mullky/app_state.dart';
import 'package:mullky/format.dart';
import 'package:mullky/models.dart';
import 'package:mullky/strings.dart';

AppState makeState() => AppState(clock: () => DateTime(2026, 11, 1, 12));

void main() {
  group('sign in', () {
    test('rejects bad email and short password with Arabic messages', () {
      final s = makeState();
      expect(s.signIn(email: 'abc', password: '123456'), Ar.errEmail);
      expect(s.signIn(email: 'a@b.com', password: '123'), Ar.errPassword);
      expect(s.isSignedIn, false);
    });

    test('owner is not admin; admin@ email gets the admin role', () {
      final s = makeState();
      expect(s.signIn(email: 'owner@example.com', password: '123456'), isNull);
      expect(s.isAdmin, false);
      s.signOut();
      expect(s.isSignedIn, false);
      expect(s.signIn(email: 'admin@example.com', password: '123456'), isNull);
      expect(s.isAdmin, true);
    });

    test('register requires a name and keeps it', () {
      final s = makeState();
      expect(
          s.register(name: ' ', email: 'a@b.com', password: '123456'),
          Ar.errName);
      expect(
          s.register(name: 'محمد', email: 'a@b.com', password: '123456'),
          isNull);
      expect(s.user!.name, 'محمد');
    });
  });

  group('units visibility', () {
    test('signed out sees nothing; owner sees own units', () {
      final s = makeState();
      expect(s.visibleUnits, isEmpty);
      s.signIn(email: 'owner@example.com', password: '123456');
      expect(s.visibleUnits.length, 3);
    });
  });

  group('service requests', () {
    test('empty notes are rejected', () {
      final s = makeState();
      s.signIn(email: 'owner@example.com', password: '123456');
      expect(
          s.createRequest(
              unitId: 'u2', type: ServiceType.cleaning, notes: '   '),
          isNull);
    });

    test('new request is pending, numbered after existing, first in history',
        () {
      final s = makeState();
      s.signIn(email: 'owner@example.com', password: '123456');
      final r = s.createRequest(
          unitId: 'u1', type: ServiceType.pestControl, notes: 'نمل في المطبخ');
      expect(r, isNotNull);
      expect(r!.status, RequestStatus.pending);
      expect(r.number, 10432);
      expect(s.requestsFor('u1').first.id, r.id);
    });

    test('owner cannot create a request for a unit that is not theirs', () {
      final s = makeState();
      s.signIn(email: 'owner@example.com', password: '123456');
      expect(
          s.createRequest(
              unitId: 'nope', type: ServiceType.cleaning, notes: 'x'),
          isNull);
    });
  });

  group('admin permissions', () {
    test('non-admin cannot change status, add invoice, or list all requests',
        () {
      final s = makeState();
      s.signIn(email: 'owner@example.com', password: '123456');
      expect(s.setRequestStatus('r2', RequestStatus.done), false);
      expect(s.addInvoice(requestId: 'r2', amount: 500), isNull);
      expect(s.setInvoicePaid('i1', false), false);
      expect(s.allRequests(), isEmpty);
      expect(s.requestsFor('u1').firstWhere((r) => r.id == 'r2').status,
          RequestStatus.inProgress);
    });

    test('admin changes status through the whole workflow', () {
      final s = makeState();
      s.signIn(email: 'admin@example.com', password: '123456');
      expect(s.setRequestStatus('r2', RequestStatus.done), true);
      expect(s.allRequests(status: RequestStatus.done).length, 2);
      expect(s.allRequests(status: RequestStatus.pending), isEmpty);
    });

    test('admin adds unpaid invoice; amount must be positive; can mark paid',
        () {
      final s = makeState();
      s.signIn(email: 'admin@example.com', password: '123456');
      expect(s.addInvoice(requestId: 'r2', amount: 0), isNull);
      expect(s.addInvoice(requestId: 'missing', amount: 100), isNull);
      final inv = s.addInvoice(requestId: 'r2', amount: 500);
      expect(inv, isNotNull);
      expect(inv!.paid, false);
      expect(inv.unitId, 'u1');
      expect(s.setInvoicePaid(inv.id, true), true);
      expect(s.invoicesForRequest('r2').single.paid, true);
    });
  });

  group('formatting', () {
    test('groupThousands', () {
      expect(groupThousands(0), '0');
      expect(groupThousands(999), '999');
      expect(groupThousands(1250), '1,250');
      expect(groupThousands(1234567), '1,234,567');
    });

    test('money and date contain Arabic units/month names', () {
      expect(formatMoney(1250), contains('1,250'));
      expect(formatMoney(1250), contains('ج.م'));
      expect(formatDate(DateTime(2026, 10, 12)), contains('أكتوبر'));
      expect(formatRequestNumber(10432), contains('#MC-10432'));
    });
  });
}
