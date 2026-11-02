import '../core/format.dart';

class LocalizedText {
  const LocalizedText(this.ar, this.en);
  final String ar;
  final String en;

  String value(String locale) => locale == 'en' ? en : ar;
  Map<String, dynamic> toJson() => {'ar': ar, 'en': en};
  factory LocalizedText.fromJson(dynamic json) {
    if (json is Map) return LocalizedText('${json['ar'] ?? ''}', '${json['en'] ?? json['ar'] ?? ''}');
    final text = '${json ?? ''}';
    return LocalizedText(text, text);
  }
}

class PropertyModel {
  const PropertyModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.propertyType,
    required this.bedrooms,
    required this.areaSqm,
    required this.status,
    required this.planId,
    required this.images,
  });

  final String id;
  final String ownerId;
  final LocalizedText name;
  final LocalizedText location;
  final LocalizedText propertyType;
  final int bedrooms;
  final int areaSqm;
  final String status;
  final String planId;
  final List<String> images;
}

class RequestUpdate {
  const RequestUpdate({required this.at, required this.text});
  final DateTime at;
  final LocalizedText text;

  Map<String, dynamic> toJson() => {'at': serializeCairo(at), 'text': text.toJson()};
  factory RequestUpdate.fromJson(Map<String, dynamic> json) => RequestUpdate(
        at: parseCairo(json['at'] as String),
        text: LocalizedText.fromJson(json['text']),
      );
}

class ServiceRequestModel {
  const ServiceRequestModel({
    required this.id,
    required this.reference,
    required this.propertyId,
    required this.ownerId,
    required this.category,
    required this.description,
    required this.images,
    required this.status,
    required this.preferredDate,
    required this.preferredTime,
    required this.estimatedCost,
    required this.finalCost,
    required this.createdAt,
    required this.updates,
  });

  final String id;
  final String reference;
  final String propertyId;
  final String ownerId;
  final String category;
  final LocalizedText description;
  final List<String> images;
  final String status;
  final DateTime? preferredDate;
  final String? preferredTime;
  final int? estimatedCost;
  final int? finalCost;
  final DateTime createdAt;
  final List<RequestUpdate> updates;

  ServiceRequestModel copyWith({String? status, int? estimatedCost, int? finalCost, List<RequestUpdate>? updates}) => ServiceRequestModel(
        id: id,
        reference: reference,
        propertyId: propertyId,
        ownerId: ownerId,
        category: category,
        description: description,
        images: images,
        status: status ?? this.status,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        estimatedCost: estimatedCost ?? this.estimatedCost,
        finalCost: finalCost ?? this.finalCost,
        createdAt: createdAt,
        updates: updates ?? this.updates,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'propertyId': propertyId,
        'ownerId': ownerId,
        'category': category,
        'description': description.toJson(),
        'images': images,
        'status': status,
        'preferredDate': preferredDate == null ? null : serializeCairo(preferredDate!),
        'preferredTime': preferredTime,
        'estimatedCost': estimatedCost,
        'finalCost': finalCost,
        'createdAt': serializeCairo(createdAt),
        'updates': updates.map((e) => e.toJson()).toList(),
      };

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) => ServiceRequestModel(
        id: json['id'] as String,
        reference: json['reference'] as String,
        propertyId: json['propertyId'] as String,
        ownerId: json['ownerId'] as String,
        category: json['category'] as String,
        description: LocalizedText.fromJson(json['description']),
        images: List<String>.from(json['images'] as List? ?? const []),
        status: json['status'] as String? ?? 'pending',
        preferredDate: json['preferredDate'] == null ? null : parseCairo(json['preferredDate'] as String),
        preferredTime: json['preferredTime'] as String?,
        estimatedCost: json['estimatedCost'] as int?,
        finalCost: json['finalCost'] as int?,
        createdAt: parseCairo(json['createdAt'] as String),
        updates: (json['updates'] as List? ?? const []).map((e) => RequestUpdate.fromJson(Map<String, dynamic>.from(e as Map))).toList(),
      );
}

class ChecklistItemModel {
  const ChecklistItemModel({required this.id, required this.label, required this.result});
  final String id;
  final LocalizedText label;
  final String result;
}

class ChecklistGroupModel {
  const ChecklistGroupModel({required this.category, required this.items});
  final String category;
  final List<ChecklistItemModel> items;
}

class IssuePhotoModel {
  const IssuePhotoModel({required this.id, required this.caption, required this.before, this.after});
  final String id;
  final LocalizedText caption;
  final String before;
  final String? after;
}

class RecommendationModel {
  const RecommendationModel({required this.id, required this.label, required this.estimatedCost});
  final String id;
  final LocalizedText label;
  final int? estimatedCost;
}

class InspectionReportModel {
  const InspectionReportModel({
    required this.id,
    required this.reference,
    required this.propertyId,
    required this.inspectorName,
    required this.inspectionDate,
    required this.score,
    required this.overallLabel,
    required this.summary,
    required this.checklist,
    required this.notes,
    required this.images,
    required this.issuePhotos,
    required this.recommendations,
    required this.estimatedCostTotal,
  });

  final String id;
  final String reference;
  final String propertyId;
  final LocalizedText inspectorName;
  final DateTime inspectionDate;
  final int score;
  final LocalizedText overallLabel;
  final LocalizedText summary;
  final List<ChecklistGroupModel> checklist;
  final LocalizedText notes;
  final List<String> images;
  final List<IssuePhotoModel> issuePhotos;
  final List<RecommendationModel> recommendations;
  final int? estimatedCostTotal;
}

class PlanModel {
  const PlanModel({required this.id, required this.nameKey, required this.monthlyPrice, required this.featureKeys});
  final String id;
  final String nameKey;
  final int monthlyPrice;
  final List<String> featureKeys;
}

class SubscriptionModel {
  const SubscriptionModel({required this.id, required this.propertyId, required this.planId, required this.status, required this.startDate, this.renewalDate});
  final String id;
  final String propertyId;
  final String planId;
  final String status;
  final DateTime startDate;
  final DateTime? renewalDate;

  Map<String, dynamic> toJson() => {
        'id': id,
        'propertyId': propertyId,
        'planId': planId,
        'status': status,
        'startDate': serializeCairo(startDate),
        'renewalDate': renewalDate == null ? null : serializeCairo(renewalDate!),
      };

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => SubscriptionModel(
        id: json['id'] as String,
        propertyId: json['propertyId'] as String,
        planId: json['planId'] as String,
        status: json['status'] as String? ?? 'pending',
        startDate: parseCairo(json['startDate'] as String),
        renewalDate: json['renewalDate'] == null ? null : parseCairo(json['renewalDate'] as String),
      );
}

class InvoiceModel {
  const InvoiceModel({required this.id, required this.propertyId, required this.description, required this.amount, required this.status, required this.createdAt});
  final String id;
  final String propertyId;
  final LocalizedText description;
  final int amount;
  final String status;
  final DateTime createdAt;
}

class NotificationModel {
  const NotificationModel({required this.id, required this.title, required this.body, required this.read, required this.createdAt, this.href});
  final String id;
  final LocalizedText title;
  final LocalizedText body;
  final bool read;
  final DateTime createdAt;
  final String? href;

  NotificationModel copyWith({bool? read}) => NotificationModel(id: id, title: title, body: body, read: read ?? this.read, createdAt: createdAt, href: href);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.toJson(),
        'body': body.toJson(),
        'read': read,
        'createdAt': serializeCairo(createdAt),
        'href': href,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        title: LocalizedText.fromJson(json['title']),
        body: LocalizedText.fromJson(json['body']),
        read: json['read'] as bool? ?? false,
        createdAt: parseCairo(json['createdAt'] as String),
        href: json['href'] as String?,
      );
}

class VisitModel {
  const VisitModel({required this.id, required this.propertyId, required this.date, required this.type, required this.note});
  final String id;
  final String propertyId;
  final DateTime date;
  final LocalizedText type;
  final LocalizedText note;
}

class UserModel {
  const UserModel({required this.id, required this.fullName, required this.email, required this.phone, this.role = 'owner'});
  final String id;
  final LocalizedText fullName;
  final String email;
  final String phone;
  final String role;

  UserModel copyWith({LocalizedText? fullName, String? email, String? phone}) => UserModel(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        role: role,
      );

  Map<String, dynamic> toJson() => {'id': id, 'fullName': fullName.toJson(), 'email': email, 'phone': phone, 'role': role};
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: LocalizedText.fromJson(json['fullName']),
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        role: json['role'] as String? ?? 'owner',
      );
}
