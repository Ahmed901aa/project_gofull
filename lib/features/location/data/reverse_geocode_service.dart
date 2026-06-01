import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Reverse geocoding with Google Geocoding API + Nominatim fallback.
class ReverseGeocodeService {
  final Dio _dio;
  final String _apiKey;

  static const _geocodeBase = 'https://maps.googleapis.com/maps/api/geocode/json';

  ReverseGeocodeService({required Dio dio, required String apiKey})
      : _dio = dio,
        _apiKey = apiKey;

  Future<String> reverseGeocode(double lat, double lng) async {
    // 1 -- Google Geocoding API
    try {
      final res = await _dio.get(_geocodeBase, queryParameters: {
        'latlng': '$lat,$lng',
        'key': _apiKey,
        'language': 'ar',
      });
      if (res.data['status'] == 'OK') {
        final results = res.data['results'] as List;
        if (results.isNotEmpty) {

          return results.first['formatted_address'] as String;

        }
      }
      debugPrint('[Geocode] status=${res.data['status']} — using Nominatim fallback');
    } catch (_) {
      debugPrint('[Geocode] Google failed — using Nominatim fallback');
    }

    // 2 -- Nominatim fallback (no API key needed)
    try {
      final r = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {'format': 'json', 'lat': lat, 'lon': lng, 'accept-language': 'ar'},
        options: Options(headers: {'User-Agent': 'GoFullApp/1.0'}),
      );
      final addr = r.data['address'] as Map<String, dynamic>?;
      if (addr != null) {
        final parts = [
          addr['neighbourhood'],
          addr['suburb'],
          addr['city'] ?? addr['town'] ?? addr['village'],
        ].whereType<String>().where((s) => s.isNotEmpty).toList();
        if (parts.isNotEmpty) {

          return parts.join('، ');

        }
      }
      return r.data['display_name'] as String? ?? '$lat, $lng';
    } catch (_) {
      return '$lat, $lng';
    }
  }
}
