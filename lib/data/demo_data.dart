import '../core/format.dart';
import 'models.dart';

class DemoData {
  static DateTime _at(int days, int hour) {
    final now = cairoNow();
    return cairoCalendarDate(now.year, now.month, now.day + days, hour);
  }

  static LocalizedText _text(String ar, String en) => LocalizedText(ar, en);

  static Map<String, dynamic> create() {
    final properties = <PropertyModel>[
      PropertyModel(
        id: 'prp_01', ownerId: 'usr_1001',
        name: _text('شاليه المارينا', 'Marina Chalet'),
        location: _text('المارينا، الغردقة', 'Marina, Hurghada'),
        propertyType: _text('شاليه', 'Chalet'), bedrooms: 2, areaSqm: 95,
        status: 'occupied', planId: 'plan_premium',
        images: const ['assets/images/property_chalet_interior.jpg', 'assets/images/property_apartment_sea.jpg'],
      ),
      PropertyModel(
        id: 'prp_02', ownerId: 'usr_1001',
        name: _text('فيلا النخيل', 'Palm Villa'),
        location: _text('السقالة، الغردقة', 'El Sakala, Hurghada'),
        propertyType: _text('فيلا', 'Villa'), bedrooms: 4, areaSqm: 240,
        status: 'vacant', planId: 'plan_basic',
        images: const ['assets/images/property_villa_pool.jpg', 'assets/images/property_chalet_interior.jpg'],
      ),
      PropertyModel(
        id: 'prp_03', ownerId: 'usr_1001',
        name: _text('شقة البحر', 'Sea View Apartment'),
        location: _text('الدهار، الغردقة', 'El Dahar, Hurghada'),
        propertyType: _text('شقة', 'Apartment'), bedrooms: 2, areaSqm: 110,
        status: 'maintenance', planId: 'plan_basic',
        images: const ['assets/images/property_apartment_sea.jpg', 'assets/images/property_chalet_interior.jpg'],
      ),
    ];

    final plans = <PlanModel>[
      const PlanModel(id: 'plan_basic', nameKey: 'subscriptions.plans.basic.name', monthlyPrice: 999,
        featureKeys: ['subscriptions.featureReport', 'subscriptions.featureAlerts', 'subscriptions.featureExpenses']),
      const PlanModel(id: 'plan_premium', nameKey: 'subscriptions.plans.premium.name', monthlyPrice: 1999,
        featureKeys: ['subscriptions.featurePrep', 'subscriptions.featureReport', 'subscriptions.featureAlerts', 'subscriptions.featureExpenses', 'subscriptions.featurePriority']),
    ];

    final requests = <ServiceRequestModel>[
      ServiceRequestModel(id: 'req_10432', reference: 'MC-10432', propertyId: 'prp_01', ownerId: 'usr_1001', category: 'hvac',
        description: _text('التكييف في غرفة النوم الرئيسية لا يبرّد بشكل كافٍ ويصدر صوتًا عاليًا عند التشغيل.', 'The main bedroom air conditioner is not cooling properly and is loud when it starts.'),
        images: const ['assets/images/service_maintenance_ac.jpg'], status: 'awaiting_approval', preferredDate: _at(3, 11), preferredTime: '11:00', estimatedCost: 850, finalCost: null, createdAt: _at(-2, 10),
        updates: [RequestUpdate(at: _at(-2, 12), text: _text('تم استلام الطلب وتسجيله على شاليه المارينا.', 'The request was received and logged against Marina Chalet.')), RequestUpdate(at: _at(-1, 9), text: _text('زيارة فنية لتقدير الأعمال: يحتاج ضبط غاز التبريد وتغيير كابل التغذية.', 'Technical visit completed: the job needs a refrigerant top-up and a new supply cable.')), RequestUpdate(at: _at(-1, 15), text: _text('تم إرسال عرض سعر مبدئي بانتظار موافقتك.', 'An initial quotation was sent and is waiting for your approval.'))]),
      ServiceRequestModel(id: 'req_10428', reference: 'MC-10428', propertyId: 'prp_02', ownerId: 'usr_1001', category: 'cleaning',
        description: _text('تنظيف شامل للفيلا وتجهيزها قبل وصول الأسرة نهاية الشهر.', 'Full villa cleaning and preparation before the family arrives at the end of the month.'),
        images: const ['assets/images/service_cleaning_prep.jpg'], status: 'scheduled', preferredDate: _at(2, 10), preferredTime: '10:00', estimatedCost: 400, finalCost: null, createdAt: _at(-4, 14),
        updates: [RequestUpdate(at: _at(-4, 16), text: _text('تم تأكيد الطلب وتحديد فريق التنظيف.', 'The request was confirmed and a cleaning team assigned.')), RequestUpdate(at: _at(-3, 11), text: _text('تم الاتفاق على موعد الزيارة.', 'The visit appointment was agreed.'))]),
      ServiceRequestModel(id: 'req_10421', reference: 'MC-10421', propertyId: 'prp_03', ownerId: 'usr_1001', category: 'plumbing',
        description: _text('تسريب في سيفون حوض الحمام الرئيسي مع انسداد بطيء في التصريف.', 'A leak under the main bathroom sink with a slow drain.'),
        images: const ['assets/images/service_maintenance_ac.jpg'], status: 'in_progress', preferredDate: _at(0, 9), preferredTime: '09:00', estimatedCost: 1200, finalCost: null, createdAt: _at(-6, 8),
        updates: [RequestUpdate(at: _at(-6, 9), text: _text('تم استلام الطلب.', 'Request received.')), RequestUpdate(at: _at(-5, 13), text: _text('تمت الموافقة على العرض وبدأ التنفيذ.', 'The quotation was approved and work started.')), RequestUpdate(at: _at(0, 10), text: _text('الفني في الموقع الآن، واستبدل الوصلة التالفة.', 'The technician is on site now and has replaced the damaged connector.'))]),
      ServiceRequestModel(id: 'req_10405', reference: 'MC-10405', propertyId: 'prp_01', ownerId: 'usr_1001', category: 'general',
        description: _text('ضبط مفصلات باب الشرفة وتثبيت رف المطبخ المفكوك.', 'Adjust the balcony door hinges and re-fix the loose kitchen shelf.'),
        images: const [], status: 'completed', preferredDate: _at(-12, 10), preferredTime: '10:00', estimatedCost: 600, finalCost: 620, createdAt: _at(-15, 11),
        updates: [RequestUpdate(at: _at(-14, 10), text: _text('تم اعتماد العرض.', 'The quotation was approved.')), RequestUpdate(at: _at(-12, 17), text: _text('تم إنهاء الأعمال وتسليمها. التكلفة النهائية 620 ج.م.', 'Work finished and handed over. Final cost 620 EGP.'))]),
      ServiceRequestModel(id: 'req_10398', reference: 'MC-10398', propertyId: 'prp_02', ownerId: 'usr_1001', category: 'pest',
        description: _text('رش وقائي ضد الحشرات قبل موسم الصيف.', 'Preventive pest treatment before the summer season.'),
        images: const [], status: 'pending', preferredDate: _at(9, 9), preferredTime: '09:00', estimatedCost: null, finalCost: null, createdAt: _at(-1, 19), updates: const []),
      ServiceRequestModel(id: 'req_10371', reference: 'MC-10371', propertyId: 'prp_03', ownerId: 'usr_1001', category: 'electrical',
        description: _text('مأخذ الكهرباء في غرفة النوم لا يعمل.', 'The bedroom power socket is not working.'),
        images: const [], status: 'cancelled', preferredDate: _at(-20, 12), preferredTime: '12:00', estimatedCost: 300, finalCost: null, createdAt: _at(-24, 12),
        updates: [RequestUpdate(at: _at(-23, 10), text: _text('تم إلغاء الطلب بناءً على طلبك.', 'The request was cancelled at your request.'))]),
    ];

    final marbella = <ChecklistGroupModel>[
      ChecklistGroupModel(category: 'doorsWindows', items: [ChecklistItemModel(id: 'dw1', label: _text('إحكام إغلاق النوافذ', 'Window seals'), result: 'ok'), ChecklistItemModel(id: 'dw2', label: _text('مفصلات باب الشرفة', 'Balcony door hinges'), result: 'followup'), ChecklistItemModel(id: 'dw3', label: _text('شبك الحماية', 'Window screens'), result: 'ok')]),
      ChecklistGroupModel(category: 'plumbing', items: [ChecklistItemModel(id: 'pl1', label: _text('ضغط المياه في الحمام', 'Bathroom water pressure'), result: 'ok'), ChecklistItemModel(id: 'pl2', label: _text('سيفون حوض الحمام', 'Bathroom sink waste'), result: 'repair'), ChecklistItemModel(id: 'pl3', label: _text('خزان السخان', 'Water heater tank'), result: 'ok')]),
      ChecklistGroupModel(category: 'electrical', items: [ChecklistItemModel(id: 'el1', label: _text('لوحة الكهرباء الرئيسية', 'Main distribution board'), result: 'ok'), ChecklistItemModel(id: 'el2', label: _text('مفاتيح وإضاءة الصالة', 'Living room switches and lighting'), result: 'ok'), ChecklistItemModel(id: 'el3', label: _text('مأخذ غرفة النوم', 'Bedroom power socket'), result: 'followup')]),
      ChecklistGroupModel(category: 'hvac', items: [ChecklistItemModel(id: 'hv1', label: _text('تكييف الصالة', 'Living room air conditioner'), result: 'ok'), ChecklistItemModel(id: 'hv2', label: _text('تكييف غرفة النوم الرئيسية', 'Main bedroom air conditioner'), result: 'repair'), ChecklistItemModel(id: 'hv3', label: _text('فلاتر التكييف', 'Air conditioner filters'), result: 'followup')]),
      ChecklistGroupModel(category: 'leaks', items: [ChecklistItemModel(id: 'lk1', label: _text('أسفل حوض المطبخ', 'Under the kitchen sink'), result: 'ok'), ChecklistItemModel(id: 'lk2', label: _text('سقف الحمام', 'Bathroom ceiling'), result: 'followup')]),
      ChecklistGroupModel(category: 'cleanliness', items: [ChecklistItemModel(id: 'cl1', label: _text('الأرضيات والأسطح', 'Floors and surfaces'), result: 'ok'), ChecklistItemModel(id: 'cl2', label: _text('المطبخ', 'Kitchen'), result: 'ok'), ChecklistItemModel(id: 'cl3', label: _text('الشرفة', 'Balcony'), result: 'followup')]),
    ];
    final villa = <ChecklistGroupModel>[
      ChecklistGroupModel(category: 'doorsWindows', items: [ChecklistItemModel(id: 'dw1', label: _text('إحكام إغلاق النوافذ', 'Window seals'), result: 'ok'), ChecklistItemModel(id: 'dw2', label: _text('باب المدخل الرئيسي', 'Main entrance door'), result: 'followup')]),
      ChecklistGroupModel(category: 'plumbing', items: [ChecklistItemModel(id: 'pl1', label: _text('مضخة رفع المياه', 'Water booster pump'), result: 'ok'), ChecklistItemModel(id: 'pl2', label: _text('حمام حوض السباحة', 'Pool-side bathroom'), result: 'followup')]),
      ChecklistGroupModel(category: 'electrical', items: [ChecklistItemModel(id: 'el1', label: _text('لوحة الكهرباء الرئيسية', 'Main distribution board'), result: 'ok'), ChecklistItemModel(id: 'el2', label: _text('إضاءة الحدائق', 'Garden lighting'), result: 'repair')]),
      ChecklistGroupModel(category: 'hvac', items: [ChecklistItemModel(id: 'hv1', label: _text('تكييف غرفة المعيشة', 'Living room air conditioner'), result: 'ok'), ChecklistItemModel(id: 'hv2', label: _text('تكييف غرفة الضيوف', 'Guest room air conditioner'), result: 'followup')]),
      ChecklistGroupModel(category: 'leaks', items: [ChecklistItemModel(id: 'lk1', label: _text('جلسة حوض السباحة', 'Pool deck'), result: 'ok'), ChecklistItemModel(id: 'lk2', label: _text('أسفل خزان المياه', 'Below the water tank'), result: 'ok')]),
      ChecklistGroupModel(category: 'cleanliness', items: [ChecklistItemModel(id: 'cl1', label: _text('الأرضيات والأسطح', 'Floors and surfaces'), result: 'ok'), ChecklistItemModel(id: 'cl2', label: _text('حوض السباحة', 'Swimming pool'), result: 'followup')]),
    ];

    final reports = <InspectionReportModel>[
      InspectionReportModel(id: 'rep_2041', reference: 'IR-2041', propertyId: 'prp_01', inspectorName: _text('م. محمود سعد', 'Eng. Mahmoud Saad'), inspectionDate: _at(-6, 11), score: 84, overallLabel: _text('جيدة', 'Good'),
        summary: _text('العقار بحالة جيدة بشكل عام. لا توجد أضرار إنشائية. البنود الرئيسية المطلوبة: إصلاح سيفون حوض الحمام وضبط تكييف غرفة النوم الرئيسية.', 'The property is in good overall condition with no structural damage. The main open items are the bathroom sink waste and the main bedroom air conditioner.'), checklist: marbella,
        notes: _text('تم الفحص في وجود مندوب MulkCare. الشرفة تحتاج إعادة ترتيب الأثاث بعد زيارة الضيوف السابقة. لا توجد آثار رطوبة على الجدران.', 'The inspection was carried out with a MulkCare representative present. The balcony furniture needs re-arranging after the previous guest stay. No damp marks on the walls.'),
        images: const ['assets/images/inspection_clipboard.jpg', 'assets/images/service_maintenance_ac.jpg', 'assets/images/service_cleaning_prep.jpg'],
        issuePhotos: [IssuePhotoModel(id: 'ip1', caption: _text('سيفون حوض الحمام', 'Bathroom sink waste'), before: 'assets/images/service_maintenance_ac.jpg')],
        recommendations: [RecommendationModel(id: 'rc1', label: _text('استبدال سيفون حوض الحمام', 'Replace the bathroom sink waste'), estimatedCost: 350), RecommendationModel(id: 'rc2', label: _text('ضبط غاز التبريد لجهاز التكييف الرئيسي', 'Top up refrigerant in the main air conditioner'), estimatedCost: 500)], estimatedCostTotal: 850),
      InspectionReportModel(id: 'rep_2028', reference: 'IR-2028', propertyId: 'prp_02', inspectorName: _text('أ. هبة عبد الرحمن', 'Ms. Heba Abdelrahman'), inspectionDate: _at(-20, 10), score: 71, overallLabel: _text('مقبولة', 'Fair'),
        summary: _text('الفيلا تحتاج صيانة وقائية لبعض البنود قبل الموسم: إضاءة الحدائق، باب المدخل الرئيسي، وتنظيف حوض السباحة.', 'The villa needs preventive work before the season: garden lighting, the main entrance door and pool cleaning.'), checklist: villa,
        notes: _text('حوض السباحة سليم إنشائيًا ويحتاج معالجة كيميائية. إضاءة الحدائق بها وحدتان لا تعملان.', 'The pool structure is sound and needs chemical treatment. Two garden lighting units are not working.'),
        images: const ['assets/images/property_villa_pool.jpg', 'assets/images/inspection_clipboard.jpg'], issuePhotos: const [],
        recommendations: [RecommendationModel(id: 'rc1', label: _text('استبدال وحدتين من إضاءة الحدائق', 'Replace two garden lighting units'), estimatedCost: 640), RecommendationModel(id: 'rc2', label: _text('ضبط باب المدخل الرئيسي', 'Adjust the main entrance door'), estimatedCost: null)], estimatedCostTotal: null),
    ];

    final subscriptions = <SubscriptionModel>[
      SubscriptionModel(id: 'sub_9001', propertyId: 'prp_01', planId: 'plan_premium', status: 'active', startDate: _at(-120, 10), renewalDate: _at(11, 10)),
      SubscriptionModel(id: 'sub_9002', propertyId: 'prp_02', planId: 'plan_basic', status: 'active', startDate: _at(-75, 10), renewalDate: _at(16, 10)),
      SubscriptionModel(id: 'sub_9003', propertyId: 'prp_03', planId: 'plan_basic', status: 'pending', startDate: _at(-9, 10)),
    ];
    final invoices = <InvoiceModel>[
      InvoiceModel(id: 'inv_5531', propertyId: 'prp_01', description: _text('اشتراك الباقة المميّزة — شهر أكتوبر', 'Premium plan subscription — October'), amount: 1999, status: 'paid', createdAt: _at(-22, 10)),
      InvoiceModel(id: 'inv_5548', propertyId: 'prp_01', description: _text('صيانة عامة — ضبط باب الشرفة ورف المطبخ', 'General maintenance — balcony door and kitchen shelf'), amount: 620, status: 'paid', createdAt: _at(-11, 10)),
      InvoiceModel(id: 'inv_5563', propertyId: 'prp_02', description: _text('تنظيف شامل وتجهيز قبل الوصول', 'Full cleaning and pre-arrival preparation'), amount: 400, status: 'unpaid', createdAt: _at(-3, 10)),
    ];
    final notifications = <NotificationModel>[
      NotificationModel(id: 'ntf_01', title: _text('طلب بانتظار موافقتك', 'A request is waiting for your approval'), body: _text('عرض سعر صيانة التكييف في شاليه المارينا بقيمة 850 ج.م بانتظار موافقتك.', 'The air-conditioning quotation for Marina Chalet, 850 EGP, is waiting for your approval.'), read: false, createdAt: _at(-1, 15), href: '/services'),
      NotificationModel(id: 'ntf_02', title: _text('زيارة ميدانية مكتملة', 'A visit was completed'), body: _text('تم رفع تقرير الفحص IR-2041 لشاليه المارينا بالصور والملاحظات.', 'Inspection report IR-2041 for Marina Chalet was uploaded with photos and notes.'), read: false, createdAt: _at(-6, 12), href: '/inspection/rep_2041'),
      NotificationModel(id: 'ntf_03', title: _text('زيارة قادمة', 'Upcoming visit'), body: _text('زيارة فحص مجدولة لفيلا النخيل خلال يومين.', 'An inspection visit for Palm Villa is scheduled in two days.'), read: true, createdAt: _at(-4, 9), href: '/'),
      NotificationModel(id: 'ntf_04', title: _text('فاتورة جديدة', 'New invoice'), body: _text('فاتورة تنظيف شامل بقيمة 400 ج.م غير مدفوعة.', 'A full-cleaning invoice for 400 EGP is unpaid.'), read: true, createdAt: _at(-3, 10), href: '/profile'),
    ];
    final visits = <VisitModel>[
      VisitModel(id: 'vis_01', propertyId: 'prp_02', date: _at(2, 10), type: _text('زيارة فحص', 'Inspection visit'), note: _text('فحص دوري قبل وصول الأسرة', 'Routine inspection before the family arrives')),
      VisitModel(id: 'vis_02', propertyId: 'prp_01', date: _at(11, 10), type: _text('تجهيز قبل الوصول', 'Pre-arrival preparation'), note: _text('تنظيف وتجهيز حسب الباقة المميّزة', 'Cleaning and preparation per the Premium plan')),
    ];

    return {
      'properties': properties,
      'plans': plans,
      'requests': requests,
      'reports': reports,
      'subscriptions': subscriptions,
      'invoices': invoices,
      'notifications': notifications,
      'visits': visits,
    };
  }
}
