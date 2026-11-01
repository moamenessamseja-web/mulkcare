import 'models.dart';

/// Arabic UI strings (Arabic-first MVP, no English UI).
class Ar {
  static const appName = 'MulkCare';
  static const tagline = 'بيتك في الغردقة، وعنايتنا';
  static const demoBadge = 'وضع تجريبي';
  static const signIn = 'تسجيل الدخول';
  static const register = 'إنشاء حساب';
  static const email = 'البريد الإلكتروني';
  static const password = 'كلمة المرور';
  static const fullName = 'الاسم الكامل';
  static const haveAccount = 'لديك حساب؟ سجّل الدخول';
  static const noAccount = 'ليس لديك حساب؟ أنشئ حسابًا';
  static const myUnits = 'وحداتي';
  static const allUnits = 'كل الوحدات';
  static const admin = 'الأدمن';
  static const home = 'الرئيسية';
  static const signOut = 'تسجيل الخروج';
  static const noUnits = 'لا توجد وحدات بعد';
  static const requestsHistory = 'سجل الطلبات';
  static const invoices = 'الفواتير';
  static const noRequests = 'لا توجد طلبات خدمة لهذه الوحدة بعد';
  static const noInvoices = 'لا توجد فواتير بعد';
  static const newRequest = 'طلب خدمة';
  static const serviceType = 'نوع الخدمة';
  static const notes = 'ملاحظات';
  static const notesHint = 'اكتب ما تحتاجه بالتفصيل';
  static const submitRequest = 'إرسال الطلب';
  static const requestSent = 'تم إرسال الطلب';
  static const allRequests = 'كل الطلبات';
  static const filterAll = 'الكل';
  static const changeStatus = 'تغيير الحالة';
  static const addInvoice = 'إضافة فاتورة';
  static const amount = 'المبلغ (ج.م)';
  static const add = 'إضافة';
  static const paid = 'مدفوعة';
  static const unpaid = 'غير مدفوعة';
  static const markPaid = 'تحديد كمدفوعة';
  static const markUnpaid = 'تحديد كغير مدفوعة';
  static const noRequestsAdmin = 'لا توجد طلبات';
  static const errEmail = 'أدخل بريدًا إلكترونيًا صحيحًا';
  static const errPassword = 'كلمة المرور 6 أحرف على الأقل';
  static const errName = 'أدخل الاسم';
  static const errAmount = 'أدخل مبلغًا صحيحًا أكبر من صفر';
  static const errNotes = 'اكتب ملاحظاتك أولًا';
  static const currency = 'ج.م';
  static const startupError = 'تعذّر تشغيل التطبيق';

  static String kind(UnitKind k) =>
      k == UnitKind.villa ? 'فيلا' : 'شاليه';

  static String occupancy(OccupancyStatus s) =>
      s == OccupancyStatus.vacant ? 'شاغرة' : 'مؤجرة';

  static String service(ServiceType t) {
    switch (t) {
      case ServiceType.cleaning:
        return 'تنظيف';
      case ServiceType.maintenance:
        return 'صيانة';
      case ServiceType.inspection:
        return 'فحص';
      case ServiceType.pestControl:
        return 'مكافحة حشرات';
    }
  }

  static String status(RequestStatus s) {
    switch (s) {
      case RequestStatus.pending:
        return 'قيد الانتظار';
      case RequestStatus.inProgress:
        return 'جاري';
      case RequestStatus.done:
        return 'مكتمل';
    }
  }
}
