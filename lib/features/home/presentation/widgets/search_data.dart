import 'package:flutter/material.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

List<Map<String, dynamic>> getSearchableItems(BuildContext context) {
  final l10n = S.of(context);
  return [
    {'title': l10n.searchFuelDelivery, 'subtitle': l10n.searchFuelDeliveryDesc, 'icon': Icons.local_gas_station_outlined, 'route': Routes.fuelType, 'category': l10n.servicesCategory},
    {'title': l10n.searchTowing, 'subtitle': l10n.searchTowingDesc, 'icon': Icons.fire_truck_outlined, 'route': Routes.towingRequest, 'category': l10n.servicesCategory},
    {'title': l10n.searchMyOrders, 'subtitle': l10n.searchMyOrdersDesc, 'icon': Icons.receipt_long_outlined, 'route': '_orders', 'category': l10n.appCategory},
    {'title': l10n.searchDiscountCodes, 'subtitle': l10n.searchDiscountCodesDesc, 'icon': Icons.local_offer_outlined, 'route': Routes.discountCodes, 'category': l10n.appCategory},
    {'title': l10n.searchFAQ, 'subtitle': l10n.searchFAQDesc, 'icon': Icons.help_outline_rounded, 'route': Routes.faq, 'category': l10n.appCategory},
    {'title': l10n.searchEditProfile, 'subtitle': l10n.searchEditProfileDesc, 'icon': Icons.person_outline_rounded, 'route': Routes.editProfile, 'category': l10n.accountCategory},
    {'title': l10n.searchTerms, 'subtitle': l10n.searchTermsDesc, 'icon': Icons.description_outlined, 'route': Routes.terms, 'category': l10n.appCategory},
    {'title': l10n.searchSupport, 'subtitle': l10n.searchSupportDesc, 'icon': Icons.headset_mic_outlined, 'route': '_support', 'category': l10n.appCategory},
  ];
}

Map<String, List<String>> getSearchKeywords(BuildContext context) {
  final l10n = S.of(context);
  return {
    l10n.searchFuelDelivery: l10n.searchKeywordFuel.split(','),
    l10n.searchTowing: l10n.searchKeywordTow.split(','),
    l10n.searchMyOrders: l10n.searchKeywordOrders.split(','),
    l10n.searchDiscountCodes: l10n.searchKeywordDiscount.split(','),
    l10n.searchFAQ: l10n.searchKeywordFAQ.split(','),
    l10n.searchEditProfile: l10n.searchKeywordProfile.split(','),
    l10n.searchTerms: l10n.searchKeywordTerms.split(','),
    l10n.searchSupport: l10n.searchKeywordSupport.split(','),
  };
}

List<Map<String, dynamic>> getQuickShortcuts(BuildContext context) {
  final l10n = S.of(context);
  return [
    {'title': l10n.searchFuelDelivery, 'icon': Icons.local_gas_station_outlined, 'route': Routes.fuelType},
    {'title': l10n.searchTowing, 'icon': Icons.fire_truck_outlined, 'route': Routes.towingRequest},
    {'title': l10n.searchMyOrders, 'icon': Icons.receipt_long_outlined, 'route': '_orders'},
    {'title': l10n.searchSupport, 'icon': Icons.headset_mic_outlined, 'route': '_support'},
  ];
}
