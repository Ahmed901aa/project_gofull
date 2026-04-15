import 'package:flutter/material.dart';

class BannerData {
  final List<Color> gradientColors;
  final String headline;
  final String headlineAccent;
  final String badge;
  final String tag;
  const BannerData({
    required this.gradientColors,
    required this.headline,
    required this.headlineAccent,
    required this.badge,
    required this.tag,
  });
}

const bannerSlides = [
  BannerData(
    gradientColors: [Color(0xFFFFB800), Color(0xFFE1A200), Color(0xFF996E00)],
    headline: 'جميع خدمات الطوارئ في ',
    headlineAccent: 'اشتراك واحد',
    badge: 'قسائم مجانية + خصومات حصرية',
    tag: 'عرض حصري',
  ),
  BannerData(
    gradientColors: [Color(0xFF1A6B54), Color(0xFF004B3B), Color(0xFF003329)],
    headline: 'خدمة الساحبة على مدار ',
    headlineAccent: '24 ساعة',
    badge: 'استجابة سريعة في أي وقت',
    tag: 'متاح الآن',
  ),
  BannerData(
    gradientColors: [Color(0xFF2979FF), Color(0xFF1565C0), Color(0xFF0D47A1)],
    headline: 'احصل على خصم ',
    headlineAccent: '20%',
    badge: 'استخدم الكود: GO20',
    tag: 'لفترة محدودة',
  ),
];
