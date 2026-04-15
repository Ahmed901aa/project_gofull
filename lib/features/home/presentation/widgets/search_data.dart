import 'package:flutter/material.dart';
import 'package:project_gofull/core/routes/routes.dart';

const searchableItems = [
  {'title': 'إمداد وقود', 'subtitle': 'توصيل الوقود لموقعك', 'icon': Icons.local_gas_station_outlined, 'route': Routes.fuelType, 'category': 'خدمات'},
  {'title': 'ساحبة', 'subtitle': 'خدمة سحب السيارات', 'icon': Icons.fire_truck_outlined, 'route': Routes.towingRequest, 'category': 'خدمات'},
  {'title': 'طلباتي', 'subtitle': 'عرض الطلبات الحالية والسابقة', 'icon': Icons.receipt_long_outlined, 'route': '_orders', 'category': 'التطبيق'},
  {'title': 'أكواد الخصم', 'subtitle': 'إدخال وعرض أكواد الخصم', 'icon': Icons.local_offer_outlined, 'route': Routes.discountCodes, 'category': 'التطبيق'},
  {'title': 'الأسئلة الشائعة', 'subtitle': 'إجابات على الأسئلة المتكررة', 'icon': Icons.help_outline_rounded, 'route': Routes.faq, 'category': 'التطبيق'},
  {'title': 'تعديل بيانات الحساب', 'subtitle': 'تعديل الاسم ورقم الجوال', 'icon': Icons.person_outline_rounded, 'route': Routes.editProfile, 'category': 'الحساب'},
  {'title': 'الشروط والأحكام', 'subtitle': 'شروط استخدام التطبيق', 'icon': Icons.description_outlined, 'route': Routes.terms, 'category': 'التطبيق'},
  {'title': 'الدعم والمساعدة', 'subtitle': 'تواصل معنا للمساعدة', 'icon': Icons.headset_mic_outlined, 'route': '_support', 'category': 'التطبيق'},
];

const searchKeywords = {
  'إمداد وقود': ['وقود', 'بنزين', 'ديزل', 'تعبئة', 'طلب وقود'],
  'ساحبة': ['ساحبة', 'سحب', 'نقل', 'طلب ساحبة', 'سيارة'],
  'طلباتي': ['طلبات', 'طلب', 'سجل', 'تاريخ'],
  'أكواد الخصم': ['كود', 'خصم', 'عرض', 'تخفيض', 'كوبون'],
  'الأسئلة الشائعة': ['سؤال', 'أسئلة', 'مساعدة', 'كيف'],
  'تعديل بيانات الحساب': ['تعديل', 'حساب', 'اسم', 'رقم', 'جوال', 'بيانات'],
  'الشروط والأحكام': ['شروط', 'أحكام', 'سياسة'],
  'الدعم والمساعدة': ['دعم', 'مساعدة', 'تواصل', 'شكوى'],
};

const quickShortcuts = [
  {'title': 'إمداد وقود', 'icon': Icons.local_gas_station_outlined, 'route': Routes.fuelType},
  {'title': 'ساحبة', 'icon': Icons.fire_truck_outlined, 'route': Routes.towingRequest},
  {'title': 'طلباتي', 'icon': Icons.receipt_long_outlined, 'route': '_orders'},
  {'title': 'الدعم', 'icon': Icons.headset_mic_outlined, 'route': '_support'},
];
