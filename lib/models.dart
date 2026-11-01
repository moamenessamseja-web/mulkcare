enum UnitKind { villa, chalet }

enum OccupancyStatus { vacant, rented }

enum ServiceType { cleaning, maintenance, inspection, pestControl }

/// pending -> inProgress -> done (owner brief).
enum RequestStatus { pending, inProgress, done }

class UserProfile {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });
}

class PropertyUnit {
  final String id;
  final String ownerId;
  final String name;
  final String location;
  final UnitKind kind;
  final OccupancyStatus status;
  final String imageAsset;
  const PropertyUnit({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.kind,
    required this.status,
    required this.imageAsset,
  });
}

class ServiceRequest {
  final String id;
  final int number;
  final String unitId;
  final ServiceType type;
  final String notes;
  final RequestStatus status;
  final DateTime createdAt;
  const ServiceRequest({
    required this.id,
    required this.number,
    required this.unitId,
    required this.type,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  ServiceRequest copyWith({RequestStatus? status}) => ServiceRequest(
        id: id,
        number: number,
        unitId: unitId,
        type: type,
        notes: notes,
        status: status ?? this.status,
        createdAt: createdAt,
      );
}

class Invoice {
  final String id;
  final String requestId;
  final String unitId;
  final int amount; // whole EGP, no online payment in MVP
  final bool paid;
  final DateTime createdAt;
  const Invoice({
    required this.id,
    required this.requestId,
    required this.unitId,
    required this.amount,
    required this.paid,
    required this.createdAt,
  });

  Invoice copyWith({bool? paid}) => Invoice(
        id: id,
        requestId: requestId,
        unitId: unitId,
        amount: amount,
        paid: paid ?? this.paid,
        createdAt: createdAt,
      );
}
