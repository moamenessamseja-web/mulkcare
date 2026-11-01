import '../models.dart';

/// Sample data for the demo (Stage 1: in-memory only). Replaced by
/// Supabase + SQLite cache in Stage 2.
List<PropertyUnit> sampleUnits() => const [
      PropertyUnit(
        id: 'u1',
        ownerId: 'owner1',
        name: 'شاليه المارينا',
        location: 'المارينا، الغردقة',
        kind: UnitKind.chalet,
        status: OccupancyStatus.rented,
        imageAsset: 'assets/images/chalet-interior.jpg',
      ),
      PropertyUnit(
        id: 'u2',
        ownerId: 'owner1',
        name: 'فيلا النخيل',
        location: 'السقالة، الغردقة',
        kind: UnitKind.villa,
        status: OccupancyStatus.vacant,
        imageAsset: 'assets/images/villa-pool.jpg',
      ),
      PropertyUnit(
        id: 'u3',
        ownerId: 'owner1',
        name: 'شاليه البحر',
        location: 'الدهار، الغردقة',
        kind: UnitKind.chalet,
        status: OccupancyStatus.vacant,
        imageAsset: 'assets/images/chalet-sea.jpg',
      ),
    ];

List<ServiceRequest> sampleRequests(DateTime now) => [
      ServiceRequest(
        id: 'r1',
        number: 10430,
        unitId: 'u1',
        type: ServiceType.cleaning,
        notes: 'تنظيف شامل قبل وصول الضيوف',
        status: RequestStatus.done,
        createdAt: DateTime(now.year, now.month, now.day - 12),
      ),
      ServiceRequest(
        id: 'r2',
        number: 10431,
        unitId: 'u1',
        type: ServiceType.maintenance,
        notes: 'تسريب بسيط في حوض المطبخ',
        status: RequestStatus.inProgress,
        createdAt: DateTime(now.year, now.month, now.day - 3),
      ),
    ];

List<Invoice> sampleInvoices(DateTime now) => [
      Invoice(
        id: 'i1',
        requestId: 'r1',
        unitId: 'u1',
        amount: 850,
        paid: true,
        createdAt: DateTime(now.year, now.month, now.day - 10),
      ),
    ];
