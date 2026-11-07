class AppBundle {
  final Map<String, dynamic> user;
  final List<dynamic> properties;
  final List<dynamic> serviceRequests;
  final List<dynamic> inspectionReports;
  final List<dynamic> subscriptions;
  final List<dynamic> invoices;
  final List<dynamic> notifications;

  AppBundle({
    required this.user,
    required this.properties,
    required this.serviceRequests,
    required this.inspectionReports,
    required this.subscriptions,
    required this.invoices,
    required this.notifications,
  });

  factory AppBundle.fromJson(Map<String, dynamic> j) => AppBundle(
    user: j['user'] ?? {},
    properties: j['properties'] ?? [],
    serviceRequests: j['serviceRequests'] ?? [],
    inspectionReports: j['inspectionReports'] ?? [],
    subscriptions: j['subscriptions'] ?? [],
    invoices: j['invoices'] ?? [],
    notifications: j['notifications'] ?? [],
  );

  Map<String, dynamic> toJson() => {
    'user': user,
    'properties': properties,
    'serviceRequests': serviceRequests,
    'inspectionReports': inspectionReports,
    'subscriptions': subscriptions,
    'invoices': invoices,
    'notifications': notifications,
  };

  factory AppBundle.seed() => AppBundle(
    user: {'id': 'usr_1001', 'fullName': 'أحمد محمد', 'email': 'owner@mulkcare.demo'},
    properties: [
      {'id': 'prp_01', 'name': 'شاليه المارينا', 'location': 'المارينا، الغردقة', 'status': 'occupied'},
      {'id': 'prp_02', 'name': 'فيلا النخيل', 'location': 'السقالة، الغردقة', 'status': 'vacant'},
    ],
    serviceRequests: [],
    inspectionReports: [],
    subscriptions: [],
    invoices: [],
    notifications: [],
  );
}
