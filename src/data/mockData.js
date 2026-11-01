/**
 * Sample data set for the MulkCare demo build.
 *
 * Every value here is SAMPLE data. It must never be presented as live server
 * data, and no value here is a real business, address, phone number or price.
 * The app surfaces a persistent demo banner and marks plans as proposed test
 * prices. Dates are generated relative to "now" so the demo never looks stale.
 */
import { shiftDays } from '../core/format';

export const demoUser = {
  id: 'usr_1001',
  fullName: { ar: 'أحمد محمد', en: 'Ahmed Mohamed' },
  email: 'owner@mulkcare.demo',
  // Visibly non-real placeholder — deliberately not a dialable Egyptian number.
  phone: '01X XXX XXXX',
  preferredLanguage: 'ar',
  role: 'owner',
};

export const plans = [
  {
    id: 'plan_basic',
    nameKey: 'subscriptions.plans.basic.name',
    monthlyPrice: 999,
    isProposedTestPrice: true,
    featureKeys: ['subscriptions.featureReport', 'subscriptions.featureAlerts', 'subscriptions.featureExpenses'],
  },
  {
    id: 'plan_premium',
    nameKey: 'subscriptions.plans.premium.name',
    monthlyPrice: 1999,
    isProposedTestPrice: true,
    featureKeys: [
      'subscriptions.featurePrep',
      'subscriptions.featureReport',
      'subscriptions.featureAlerts',
      'subscriptions.featureExpenses',
      'subscriptions.featurePriority',
    ],
  },
];

export const properties = [
  {
    id: 'prp_01',
    ownerId: demoUser.id,
    name: { ar: 'شاليه المارينا', en: 'Marina Chalet' },
    location: { ar: 'المارينا، الغردقة', en: 'Marina, Hurghada' },
    propertyType: { ar: 'شاليه', en: 'Chalet' },
    bedrooms: 2,
    areaSqm: 95,
    status: 'occupied',
    planId: 'plan_premium',
    images: ['https://sc04.alicdn.com/kf/Se48a7846b7aa4611b5fafd6eb07e589a4.jpg', 'https://sc04.alicdn.com/kf/Sea3224f5749f46b4bae0bf87a351951e9.jpg'],
  },
  {
    id: 'prp_02',
    ownerId: demoUser.id,
    name: { ar: 'فيلا النخيل', en: 'Palm Villa' },
    location: { ar: 'السقالة، الغردقة', en: 'El Sakala, Hurghada' },
    propertyType: { ar: 'فيلا', en: 'Villa' },
    bedrooms: 4,
    areaSqm: 240,
    status: 'vacant',
    planId: 'plan_basic',
    images: ['https://sc04.alicdn.com/kf/Sd7c437dfd3eb46fabe290a06ccc99d4dJ.jpg', 'https://sc04.alicdn.com/kf/Se48a7846b7aa4611b5fafd6eb07e589a4.jpg'],
  },
  {
    id: 'prp_03',
    ownerId: demoUser.id,
    name: { ar: 'شقة البحر', en: 'Sea View Apartment' },
    location: { ar: 'الدهار، الغردقة', en: 'El Dahar, Hurghada' },
    propertyType: { ar: 'شقة', en: 'Apartment' },
    bedrooms: 2,
    areaSqm: 110,
    status: 'maintenance',
    planId: 'plan_basic',
    images: ['https://sc04.alicdn.com/kf/Sea3224f5749f46b4bae0bf87a351951e9.jpg', 'https://sc04.alicdn.com/kf/Se48a7846b7aa4611b5fafd6eb07e589a4.jpg'],
  },
];

/** Append-only audit trail per request — drives the "technician updates" list. */
export const serviceRequests = [
  {
    id: 'req_10432',
    reference: 'MC-10432',
    propertyId: 'prp_01',
    ownerId: demoUser.id,
    category: 'hvac',
    description: {
      ar: 'التكييف في غرفة النوم الرئيسية لا يبرّد بشكل كافٍ ويصدر صوتًا عاليًا عند التشغيل.',
      en: 'The main bedroom air conditioner is not cooling properly and is loud when it starts.',
    },
    images: ['https://sc04.alicdn.com/kf/S3de3719c54dd40daa17da98050deabdai.jpg'],
    status: 'awaiting_approval',
    preferredDate: shiftDays(3, 11),
    estimatedCost: 850,
    finalCost: null,
    createdAt: shiftDays(-2, 10),
    updates: [
      {
        at: shiftDays(-2, 12),
        text: {
          ar: 'تم استلام الطلب وتسجيله على شاليه المارينا.',
          en: 'The request was received and logged against Marina Chalet.',
        },
      },
      {
        at: shiftDays(-1, 9),
        text: {
          ar: 'زيارة فنية لتقدير الأعمال: يحتاج ضبط غاز التبريد وتغيير كابل التغذية.',
          en: 'Technical visit completed: the job needs a refrigerant top-up and a new supply cable.',
        },
      },
      {
        at: shiftDays(-1, 15),
        text: {
          ar: 'تم إرسال عرض سعر مبدئي بانتظار موافقتك.',
          en: 'An initial quotation was sent and is waiting for your approval.',
        },
      },
    ],
  },
  {
    id: 'req_10428',
    reference: 'MC-10428',
    propertyId: 'prp_02',
    ownerId: demoUser.id,
    category: 'cleaning',
    description: {
      ar: 'تنظيف شامل للفيلا وتجهيزها قبل وصول الأسرة نهاية الشهر.',
      en: 'Full villa cleaning and preparation before the family arrives at the end of the month.',
    },
    images: ['https://sc04.alicdn.com/kf/Sdb79242006e14059b3fa1f191345feaal.jpg'],
    status: 'scheduled',
    preferredDate: shiftDays(2, 10),
    estimatedCost: 400,
    finalCost: null,
    createdAt: shiftDays(-4, 14),
    updates: [
      {
        at: shiftDays(-4, 16),
        text: {
          ar: 'تم تأكيد الطلب وتحديد فريق التنظيف.',
          en: 'The request was confirmed and a cleaning team assigned.',
        },
      },
      {
        at: shiftDays(-3, 11),
        text: {
          ar: 'تم الاتفاق على موعد الزيارة.',
          en: 'The visit appointment was agreed.',
        },
      },
    ],
  },
  {
    id: 'req_10421',
    reference: 'MC-10421',
    propertyId: 'prp_03',
    ownerId: demoUser.id,
    category: 'plumbing',
    description: {
      ar: 'تسريب في سيفون حوض الحمام الرئيسي مع انسداد بطيء في التصريف.',
      en: 'A leak under the main bathroom sink with a slow drain.',
    },
    images: ['https://sc04.alicdn.com/kf/S3de3719c54dd40daa17da98050deabdai.jpg'],
    status: 'in_progress',
    preferredDate: shiftDays(0, 9),
    estimatedCost: 1200,
    finalCost: null,
    createdAt: shiftDays(-6, 8),
    updates: [
      {
        at: shiftDays(-6, 9),
        text: {
          ar: 'تم استلام الطلب.',
          en: 'Request received.',
        },
      },
      {
        at: shiftDays(-5, 13),
        text: {
          ar: 'تمت الموافقة على العرض وبدأ التنفيذ.',
          en: 'The quotation was approved and work started.',
        },
      },
      {
        at: shiftDays(0, 10),
        text: {
          ar: 'الفني في الموقع الآن، واستبدل الوصلة التالفة.',
          en: 'The technician is on site now and has replaced the damaged connector.',
        },
      },
    ],
  },
  {
    id: 'req_10405',
    reference: 'MC-10405',
    propertyId: 'prp_01',
    ownerId: demoUser.id,
    category: 'general',
    description: {
      ar: 'ضبط مفصلات باب الشرفة وتثبيت رف المطبخ المفكوك.',
      en: 'Adjust the balcony door hinges and re-fix the loose kitchen shelf.',
    },
    images: [],
    status: 'completed',
    preferredDate: shiftDays(-12, 10),
    estimatedCost: 600,
    finalCost: 620,
    createdAt: shiftDays(-15, 11),
    updates: [
      {
        at: shiftDays(-14, 10),
        text: {
          ar: 'تم اعتماد العرض.',
          en: 'The quotation was approved.',
        },
      },
      {
        at: shiftDays(-12, 17),
        text: {
          ar: 'تم إنهاء الأعمال وتسليمها. التكلفة النهائية 620 ج.م.',
          en: 'Work finished and handed over. Final cost 620 EGP.',
        },
      },
    ],
  },
  {
    id: 'req_10398',
    reference: 'MC-10398',
    propertyId: 'prp_02',
    ownerId: demoUser.id,
    category: 'pest',
    description: {
      ar: 'رش وقائي ضد الحشرات قبل موسم الصيف.',
      en: 'Preventive pest treatment before the summer season.',
    },
    images: [],
    status: 'pending',
    preferredDate: shiftDays(9, 9),
    estimatedCost: null,
    finalCost: null,
    createdAt: shiftDays(-1, 19),
    updates: [],
  },
  {
    id: 'req_10371',
    reference: 'MC-10371',
    propertyId: 'prp_03',
    ownerId: demoUser.id,
    category: 'electrical',
    description: {
      ar: 'مأخذ الكهرباء في غرفة النوم لا يعمل.',
      en: 'The bedroom power socket is not working.',
    },
    images: [],
    status: 'cancelled',
    preferredDate: shiftDays(-20, 12),
    estimatedCost: 300,
    finalCost: null,
    createdAt: shiftDays(-24, 12),
    updates: [
      {
        at: shiftDays(-23, 10),
        text: {
          ar: 'تم إلغاء الطلب بناءً على طلبك.',
          en: 'The request was cancelled at your request.',
        },
      },
    ],
  },
];

const marbellaChecklist = [
  {
    category: 'doorsWindows',
    items: [
      { id: 'dw1', label: { ar: 'إحكام إغلاق النوافذ', en: 'Window seals' }, result: 'ok' },
      { id: 'dw2', label: { ar: 'مفصلات باب الشرفة', en: 'Balcony door hinges' }, result: 'followup' },
      { id: 'dw3', label: { ar: 'شبك الحماية', en: 'Window screens' }, result: 'ok' },
    ],
  },
  {
    category: 'plumbing',
    items: [
      { id: 'pl1', label: { ar: 'ضغط المياه في الحمام', en: 'Bathroom water pressure' }, result: 'ok' },
      { id: 'pl2', label: { ar: 'سيفون حوض الحمام', en: 'Bathroom sink waste' }, result: 'repair' },
      { id: 'pl3', label: { ar: 'خزان السخان', en: 'Water heater tank' }, result: 'ok' },
    ],
  },
  {
    category: 'electrical',
    items: [
      { id: 'el1', label: { ar: 'لوحة الكهرباء الرئيسية', en: 'Main distribution board' }, result: 'ok' },
      { id: 'el2', label: { ar: 'مفاتيح وإضاءة الصالة', en: 'Living room switches and lighting' }, result: 'ok' },
      { id: 'el3', label: { ar: 'مأخذ غرفة النوم', en: 'Bedroom power socket' }, result: 'followup' },
    ],
  },
  {
    category: 'hvac',
    items: [
      { id: 'hv1', label: { ar: 'تكييف الصالة', en: 'Living room air conditioner' }, result: 'ok' },
      { id: 'hv2', label: { ar: 'تكييف غرفة النوم الرئيسية', en: 'Main bedroom air conditioner' }, result: 'repair' },
      { id: 'hv3', label: { ar: 'فلاتر التكييف', en: 'Air conditioner filters' }, result: 'followup' },
    ],
  },
  {
    category: 'leaks',
    items: [
      { id: 'lk1', label: { ar: 'أسفل حوض المطبخ', en: 'Under the kitchen sink' }, result: 'ok' },
      { id: 'lk2', label: { ar: 'سقف الحمام', en: 'Bathroom ceiling' }, result: 'followup' },
    ],
  },
  {
    category: 'cleanliness',
    items: [
      { id: 'cl1', label: { ar: 'الأرضيات والأسطح', en: 'Floors and surfaces' }, result: 'ok' },
      { id: 'cl2', label: { ar: 'المطبخ', en: 'Kitchen' }, result: 'ok' },
      { id: 'cl3', label: { ar: 'الشرفة', en: 'Balcony' }, result: 'followup' },
    ],
  },
];

const villaChecklist = [
  {
    category: 'doorsWindows',
    items: [
      { id: 'dw1', label: { ar: 'إحكام إغلاق النوافذ', en: 'Window seals' }, result: 'ok' },
      { id: 'dw2', label: { ar: 'باب المدخل الرئيسي', en: 'Main entrance door' }, result: 'followup' },
    ],
  },
  {
    category: 'plumbing',
    items: [
      { id: 'pl1', label: { ar: 'مضخة رفع المياه', en: 'Water booster pump' }, result: 'ok' },
      { id: 'pl2', label: { ar: 'حمام حوض السباحة', en: 'Pool-side bathroom' }, result: 'followup' },
    ],
  },
  {
    category: 'electrical',
    items: [
      { id: 'el1', label: { ar: 'لوحة الكهرباء الرئيسية', en: 'Main distribution board' }, result: 'ok' },
      { id: 'el2', label: { ar: 'إضاءة الحدائق', en: 'Garden lighting' }, result: 'repair' },
    ],
  },
  {
    category: 'hvac',
    items: [
      { id: 'hv1', label: { ar: 'تكييف غرفة المعيشة', en: 'Living room air conditioner' }, result: 'ok' },
      { id: 'hv2', label: { ar: 'تكييف غرفة الضيوف', en: 'Guest room air conditioner' }, result: 'followup' },
    ],
  },
  {
    category: 'leaks',
    items: [
      { id: 'lk1', label: { ar: 'جلسة حوض السباحة', en: 'Pool deck' }, result: 'ok' },
      { id: 'lk2', label: { ar: 'أسفل خزان المياه', en: 'Below the water tank' }, result: 'ok' },
    ],
  },
  {
    category: 'cleanliness',
    items: [
      { id: 'cl1', label: { ar: 'الأرضيات والأسطح', en: 'Floors and surfaces' }, result: 'ok' },
      { id: 'cl2', label: { ar: 'حوض السباحة', en: 'Swimming pool' }, result: 'followup' },
    ],
  },
];

export const inspectionReports = [
  {
    id: 'rep_2041',
    reference: 'IR-2041',
    propertyId: 'prp_01',
    inspectorId: 'ins_01',
    inspectorName: { ar: 'م. محمود سعد', en: 'Eng. Mahmoud Saad' },
    inspectionDate: shiftDays(-6, 11),
    overall: { score: 84, label: { ar: 'جيدة', en: 'Good' } },
    summary: {
      ar: 'العقار بحالة جيدة بشكل عام. لا توجد أضرار إنشائية. البنود الرئيسية المطلوبة: إصلاح سيفون حوض الحمام وضبط تكييف غرفة النوم الرئيسية.',
      en: 'The property is in good overall condition with no structural damage. The main open items are the bathroom sink waste and the main bedroom air conditioner.',
    },
    checklist: marbellaChecklist,
    notes: {
      ar: 'تم الفحص في وجود مندوب MulkCare. الشرفة تحتاج إعادة ترتيب الأثاث بعد زيارة الضيوف السابقة. لا توجد آثار رطوبة على الجدران.',
      en: 'The inspection was carried out with a MulkCare representative present. The balcony furniture needs re-arranging after the previous guest stay. No damp marks on the walls.',
    },
    images: [
      'https://sc04.alicdn.com/kf/S270377e5a2394c92af34452a2d625d93I.jpg',
      'https://sc04.alicdn.com/kf/S3de3719c54dd40daa17da98050deabdai.jpg',
      'https://sc04.alicdn.com/kf/Sdb79242006e14059b3fa1f191345feaal.jpg',
    ],
    issuePhotos: [
      {
        id: 'ip1',
        caption: { ar: 'سيفون حوض الحمام', en: 'Bathroom sink waste' },
        before: 'https://sc04.alicdn.com/kf/S3de3719c54dd40daa17da98050deabdai.jpg',
        after: null,
      },
    ],
    recommendations: [
      {
        id: 'rc1',
        label: { ar: 'استبدال سيفون حوض الحمام', en: 'Replace the bathroom sink waste' },
        estimatedCost: 350,
      },
      {
        id: 'rc2',
        label: { ar: 'ضبط غاز التبريد لجهاز التكييف الرئيسي', en: 'Top up refrigerant in the main air conditioner' },
        estimatedCost: 500,
      },
    ],
    estimatedCostTotal: 850,
  },
  {
    id: 'rep_2028',
    reference: 'IR-2028',
    propertyId: 'prp_02',
    inspectorId: 'ins_02',
    inspectorName: { ar: 'أ. هبة عبد الرحمن', en: 'Ms. Heba Abdelrahman' },
    inspectionDate: shiftDays(-20, 10),
    overall: { score: 71, label: { ar: 'مقبولة', en: 'Fair' } },
    summary: {
      ar: 'الفيلا تحتاج صيانة وقائية لبعض البنود قبل الموسم: إضاءة الحدائق، باب المدخل الرئيسي، وتنظيف حوض السباحة.',
      en: 'The villa needs preventive work before the season: garden lighting, the main entrance door and pool cleaning.',
    },
    checklist: villaChecklist,
    notes: {
      ar: 'حوض السباحة سليم إنشائيًا ويحتاج معالجة كيميائية. إضاءة الحدائق بها وحدتان لا تعملان.',
      en: 'The pool structure is sound and needs chemical treatment. Two garden lighting units are not working.',
    },
    images: ['https://sc04.alicdn.com/kf/Sd7c437dfd3eb46fabe290a06ccc99d4dJ.jpg', 'https://sc04.alicdn.com/kf/S270377e5a2394c92af34452a2d625d93I.jpg'],
    issuePhotos: [],
    recommendations: [
      {
        id: 'rc1',
        label: { ar: 'استبدال وحدتين من إضاءة الحدائق', en: 'Replace two garden lighting units' },
        estimatedCost: 640,
      },
      {
        id: 'rc2',
        label: { ar: 'ضبط باب المدخل الرئيسي', en: 'Adjust the main entrance door' },
        estimatedCost: null,
      },
    ],
    estimatedCostTotal: null,
  },
];

export const subscriptions = [
  {
    id: 'sub_9001',
    ownerId: demoUser.id,
    propertyId: 'prp_01',
    planId: 'plan_premium',
    status: 'active',
    startDate: shiftDays(-120, 10),
    renewalDate: shiftDays(11, 10),
  },
  {
    id: 'sub_9002',
    ownerId: demoUser.id,
    propertyId: 'prp_02',
    planId: 'plan_basic',
    status: 'active',
    startDate: shiftDays(-75, 10),
    renewalDate: shiftDays(16, 10),
  },
  {
    id: 'sub_9003',
    ownerId: demoUser.id,
    propertyId: 'prp_03',
    planId: 'plan_basic',
    status: 'pending',
    startDate: shiftDays(-9, 10),
    renewalDate: null,
  },
];

export const invoices = [
  {
    id: 'inv_5531',
    ownerId: demoUser.id,
    propertyId: 'prp_01',
    description: { ar: 'اشتراك الباقة المميّزة — شهر أكتوبر', en: 'Premium plan subscription — October' },
    amount: 1999,
    status: 'paid',
    createdAt: shiftDays(-22, 10),
  },
  {
    id: 'inv_5548',
    ownerId: demoUser.id,
    propertyId: 'prp_01',
    description: { ar: 'صيانة عامة — ضبط باب الشرفة ورف المطبخ', en: 'General maintenance — balcony door and kitchen shelf' },
    amount: 620,
    status: 'paid',
    createdAt: shiftDays(-11, 10),
  },
  {
    id: 'inv_5563',
    ownerId: demoUser.id,
    propertyId: 'prp_02',
    description: { ar: 'تنظيف شامل وتجهيز قبل الوصول', en: 'Full cleaning and pre-arrival preparation' },
    amount: 400,
    status: 'unpaid',
    createdAt: shiftDays(-3, 10),
  },
];

export const notifications = [
  {
    id: 'ntf_01',
    userId: demoUser.id,
    title: { ar: 'طلب بانتظار موافقتك', en: 'A request is waiting for your approval' },
    body: {
      ar: 'عرض سعر صيانة التكييف في شاليه المارينا بقيمة 850 ج.م بانتظار موافقتك.',
      en: 'The air-conditioning quotation for Marina Chalet, 850 EGP, is waiting for your approval.',
    },
    read: false,
    createdAt: shiftDays(-1, 15),
    href: '/services',
  },
  {
    id: 'ntf_02',
    userId: demoUser.id,
    title: { ar: 'زيارة ميدانية مكتملة', en: 'A visit was completed' },
    body: {
      ar: 'تم رفع تقرير الفحص IR-2041 لشاليه المارينا بالصور والملاحظات.',
      en: 'Inspection report IR-2041 for Marina Chalet was uploaded with photos and notes.',
    },
    read: false,
    createdAt: shiftDays(-6, 12),
    href: '/inspection/rep_2041',
  },
  {
    id: 'ntf_03',
    userId: demoUser.id,
    title: { ar: 'زيارة قادمة', en: 'Upcoming visit' },
    body: {
      ar: 'زيارة فحص مجدولة لفيلا النخيل خلال يومين.',
      en: 'An inspection visit for Palm Villa is scheduled in two days.',
    },
    read: true,
    createdAt: shiftDays(-4, 9),
    href: '/',
  },
  {
    id: 'ntf_04',
    userId: demoUser.id,
    title: { ar: 'فاتورة جديدة', en: 'New invoice' },
    body: {
      ar: 'فاتورة تنظيف شامل بقيمة 400 ج.م غير مدفوعة.',
      en: 'A full-cleaning invoice for 400 EGP is unpaid.',
    },
    read: true,
    createdAt: shiftDays(-3, 10),
    href: '/profile',
  },
];

export const upcomingVisits = [
  {
    id: 'vis_01',
    propertyId: 'prp_02',
    date: shiftDays(2, 10),
    type: { ar: 'زيارة فحص', en: 'Inspection visit' },
    note: { ar: 'فحص دوري قبل وصول الأسرة', en: 'Routine inspection before the family arrives' },
  },
  {
    id: 'vis_02',
    propertyId: 'prp_01',
    date: shiftDays(11, 10),
    type: { ar: 'تجهيز قبل الوصول', en: 'Pre-arrival preparation' },
    note: { ar: 'تنظيف وتجهيز حسب الباقة المميّزة', en: 'Cleaning and preparation per the Premium plan' },
  },
];

export const demoCredentials = {
  email: 'owner@mulkcare.demo',
  minPasswordLength: 6,
};

export const seedState = {
  user: demoUser,
  properties,
  serviceRequests,
  inspectionReports,
  subscriptions,
  invoices,
  notifications,
  upcomingVisits,
  plans,
};
