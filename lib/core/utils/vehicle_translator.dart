import 'package:flutter/widgets.dart';

/// Locale-aware translator for standardized vehicle values (make, model,
/// optionally color) that are stored as free text in the backend.
///
/// Personal names and addresses are *not* covered here on purpose — those
/// must always be shown as entered. Only standardized values that have a
/// canonical English/Arabic spelling go through this helper.
class VehicleTranslator {
  VehicleTranslator._();

  // ── Make / Model ──────────────────────────────────────────────────────
  /// Canonical Arabic → English mapping for vehicle makes and models we
  /// commonly see in the Saudi / Libyan market.
  static const Map<String, String> _arToEn = {
    // Makes
    'تويوتا': 'Toyota',
    'لكزس': 'Lexus',
    'نيسان': 'Nissan',
    'هوندا': 'Honda',
    'هيونداي': 'Hyundai',
    'هيوندا': 'Hyundai',
    'كيا': 'Kia',
    'فورد': 'Ford',
    'شيفروليه': 'Chevrolet',
    'شفروليه': 'Chevrolet',
    'جي ام سي': 'GMC',
    'جي إم سي': 'GMC',
    'دودج': 'Dodge',
    'جيب': 'Jeep',
    'مرسيدس': 'Mercedes',
    'مرسيدس بنز': 'Mercedes-Benz',
    'بي ام دبليو': 'BMW',
    'بي إم دبليو': 'BMW',
    'اودي': 'Audi',
    'أودي': 'Audi',
    'فولكس فاجن': 'Volkswagen',
    'بورش': 'Porsche',
    'لاند روفر': 'Land Rover',
    'رينج روفر': 'Range Rover',
    'جاكوار': 'Jaguar',
    'فيات': 'Fiat',
    'بيجو': 'Peugeot',
    'رينو': 'Renault',
    'سوزوكي': 'Suzuki',
    'مازدا': 'Mazda',
    'ميتسوبيشي': 'Mitsubishi',
    'سوبارو': 'Subaru',
    'إنفينيتي': 'Infiniti',
    'انفينيتي': 'Infiniti',
    'كاديلاك': 'Cadillac',
    'بويك': 'Buick',
    'كرايسلر': 'Chrysler',
    'تسلا': 'Tesla',
    'شيري': 'Chery',
    'جيلي': 'Geely',
    'إم جي': 'MG',
    'ام جي': 'MG',

    // Common Toyota models
    'هايلكس': 'Hilux',
    'كامري': 'Camry',
    'كورولا': 'Corolla',
    'لاند كروزر': 'Land Cruiser',
    'برادو': 'Prado',
    'أفالون': 'Avalon',
    'افالون': 'Avalon',
    'يارس': 'Yaris',
    'راف فور': 'RAV4',
    'هايس': 'Hiace',
    'فورتشنر': 'Fortuner',
    'إنوفا': 'Innova',
    'انوفا': 'Innova',
    'سيكويا': 'Sequoia',

    // Common Hyundai / Kia models
    'اكسنت': 'Accent',
    'أكسنت': 'Accent',
    'النترا': 'Elantra',
    'سوناتا': 'Sonata',
    'توسان': 'Tucson',
    'سنتافي': 'Santa Fe',
    'سانتافي': 'Santa Fe',
    'سيراتو': 'Cerato',
    'ريو': 'Rio',
    'سبورتاج': 'Sportage',
    'سورنتو': 'Sorento',
    'بيكانتو': 'Picanto',

    // Common Nissan models
    'صني': 'Sunny',
    'التيما': 'Altima',
    'مكسيما': 'Maxima',
    'باترول': 'Patrol',
    'إكس تريل': 'X-Trail',
    'اكس تريل': 'X-Trail',
    'ناڤارا': 'Navara',
    'نافارا': 'Navara',

    // Common Honda models
    'سيفيك': 'Civic',
    'أكورد': 'Accord',
    'اكورد': 'Accord',
    'سي ار في': 'CR-V',
    'بايلوت': 'Pilot',

    // Common Ford models
    'إكسبلورر': 'Explorer',
    'اكسبلورر': 'Explorer',
    'إكسبيدشن': 'Expedition',
    'موستانج': 'Mustang',
    'فيوجن': 'Fusion',
    'إف 150': 'F-150',
    'ف 150': 'F-150',
    'إيدج': 'Edge',
    'ايدج': 'Edge',

    // Common Chevrolet / GMC
    'تاهو': 'Tahoe',
    'سوبربان': 'Suburban',
    'سيلفرادو': 'Silverado',
    'كابتيفا': 'Captiva',
    'يوكن': 'Yukon',

    // Common Mercedes / BMW / Audi (kept English-as-is mostly)
    'الفئة سي': 'C-Class',
    'الفئة اي': 'E-Class',
    'الفئة إي': 'E-Class',
    'الفئة اس': 'S-Class',
    'الفئة إس': 'S-Class',
  };

  /// Canonical English → Arabic mapping (lowercase keys for robustness).
  /// Derived from _arToEn but kept explicit so it survives refactors.
  static const Map<String, String> _enToAr = {
    // Makes
    'toyota': 'تويوتا',
    'lexus': 'لكزس',
    'nissan': 'نيسان',
    'honda': 'هوندا',
    'hyundai': 'هيونداي',
    'kia': 'كيا',
    'ford': 'فورد',
    'chevrolet': 'شيفروليه',
    'gmc': 'جي ام سي',
    'dodge': 'دودج',
    'jeep': 'جيب',
    'mercedes': 'مرسيدس',
    'mercedes-benz': 'مرسيدس بنز',
    'bmw': 'بي ام دبليو',
    'audi': 'أودي',
    'volkswagen': 'فولكس فاجن',
    'porsche': 'بورش',
    'land rover': 'لاند روفر',
    'range rover': 'رينج روفر',
    'jaguar': 'جاكوار',
    'fiat': 'فيات',
    'peugeot': 'بيجو',
    'renault': 'رينو',
    'suzuki': 'سوزوكي',
    'mazda': 'مازدا',
    'mitsubishi': 'ميتسوبيشي',
    'subaru': 'سوبارو',
    'infiniti': 'إنفينيتي',
    'cadillac': 'كاديلاك',
    'buick': 'بويك',
    'chrysler': 'كرايسلر',
    'tesla': 'تسلا',
    'chery': 'شيري',
    'geely': 'جيلي',
    'mg': 'إم جي',

    // Models
    'hilux': 'هايلكس',
    'camry': 'كامري',
    'corolla': 'كورولا',
    'land cruiser': 'لاند كروزر',
    'prado': 'برادو',
    'avalon': 'أفالون',
    'yaris': 'يارس',
    'rav4': 'راف فور',
    'hiace': 'هايس',
    'fortuner': 'فورتشنر',
    'innova': 'إنوفا',
    'sequoia': 'سيكويا',
    'accent': 'أكسنت',
    'elantra': 'النترا',
    'sonata': 'سوناتا',
    'tucson': 'توسان',
    'santa fe': 'سانتافي',
    'cerato': 'سيراتو',
    'rio': 'ريو',
    'sportage': 'سبورتاج',
    'sorento': 'سورنتو',
    'picanto': 'بيكانتو',
    'sunny': 'صني',
    'altima': 'التيما',
    'maxima': 'مكسيما',
    'patrol': 'باترول',
    'x-trail': 'إكس تريل',
    'navara': 'ناڤارا',
    'civic': 'سيفيك',
    'accord': 'أكورد',
    'cr-v': 'سي ار في',
    'pilot': 'بايلوت',
    'explorer': 'إكسبلورر',
    'expedition': 'إكسبيدشن',
    'mustang': 'موستانج',
    'fusion': 'فيوجن',
    'f-150': 'إف 150',
    'edge': 'إيدج',
    'tahoe': 'تاهو',
    'suburban': 'سوبربان',
    'silverado': 'سيلفرادو',
    'captiva': 'كابتيفا',
    'yukon': 'يوكن',
    'c-class': 'الفئة سي',
    'e-class': 'الفئة إي',
    's-class': 'الفئة إس',
  };

  /// Returns [raw] translated into the active app locale.
  ///
  /// - In **English** mode an Arabic make/model is converted to its English
  ///   spelling (e.g. `"تويوتا هايلكس"` → `"Toyota Hilux"`).
  /// - In **Arabic** mode an English make/model is converted to its Arabic
  ///   spelling (e.g. `"Toyota Hilux"` → `"تويوتا هايلكس"`).
  /// - Tokens we don't have a mapping for are kept as-is, so user-entered
  ///   nicknames or rare brands still render — they just don't get
  ///   translated.
  static String localize(BuildContext context, String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Try whole-string match first (handles multi-word entries like
    // "Land Cruiser" or "Range Rover").
    final whole = _lookupWhole(raw, toArabic: isArabic);
    if (whole != null) return whole;

    // Fall back to token-by-token translation.
    final tokens = raw.trim().split(RegExp(r'\s+'));
    final translated = tokens.map((t) {
      final single = _lookupWhole(t, toArabic: isArabic);
      return single ?? t;
    }).toList();
    return translated.join(' ');
  }

  /// Convenience wrapper for `make` + `model` pairs. Either may be null /
  /// empty. Returns a single space-separated string in the active locale.
  static String localizeMakeModel(
    BuildContext context, {
    String? make,
    String? model,
  }) {
    final parts = <String>[
      if (make != null && make.trim().isNotEmpty) localize(context, make),
      if (model != null && model.trim().isNotEmpty) localize(context, model),
    ];
    return parts.join(' ');
  }

  static String? _lookupWhole(String value, {required bool toArabic}) {
    final trimmed = value.trim();
    if (toArabic) {
      // English value → Arabic
      return _enToAr[trimmed.toLowerCase()];
    }
    // Arabic value → English (exact match on the original string)
    return _arToEn[trimmed];
  }
}
