import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PlacePrediction {
  final String placeId;
  final String title;
  final String subtitle;
  const PlacePrediction(
      {required this.placeId, required this.title, required this.subtitle});
}

typedef PlaceDetail = ({String address, double lat, double lng});

/// Wraps Google Places Autocomplete, Place Details, and Geocoding APIs.
class GooglePlacesService {
  static const _key = 'AIzaSyDZ_ZezX058d36aMTOc9E--MbyWqCdOI9I';
  static const _base = 'https://maps.googleapis.com/maps/api';
  final _dio = Dio();

  // ── Places Autocomplete ────────────────────────────────────────────────────
  Future<List<PlacePrediction>> autocomplete(String query) async {
    try {
      final res = await _dio.get('$_base/place/autocomplete/json',
          queryParameters: {'input': query, 'key': _key, 'language': 'ar'});
      final status = res.data['status'] as String;
      debugPrint('[Places] autocomplete status=$status  query="$query"');
      if (status != 'OK') {
        debugPrint('[Places] error=${res.data['error_message'] ?? status}');
        return [];
      }
      return (res.data['predictions'] as List).map((p) {
        final sf = p['structured_formatting'] as Map? ?? {};
        return PlacePrediction(
          placeId: p['place_id'] as String,
          title: sf['main_text'] as String? ?? p['description'] as String,
          subtitle: sf['secondary_text'] as String? ?? '',
        );
      }).toList();
    } catch (e, st) {
      debugPrint('[Places] autocomplete exception: $e\n$st');
      return [];
    }
  }

  // ── Place Details ──────────────────────────────────────────────────────────
  Future<PlaceDetail?> getDetails(String placeId) async {
    try {
      final res = await _dio.get('$_base/place/details/json',
          queryParameters: {
            'place_id': placeId,
            'fields': 'geometry,name,formatted_address',
            'key': _key,
            'language': 'ar',
          });
      final status = res.data['status'] as String;
      debugPrint('[Places] details status=$status  placeId=$placeId');
      if (status != 'OK') {
        debugPrint('[Places] details error=${res.data['error_message'] ?? status}');
        return null;
      }
      final r = res.data['result'] as Map;
      final loc = r['geometry']['location'] as Map;
      final address =
          (r['name'] ?? r['formatted_address']) as String;
      return (
        address: address,
        lat: (loc['lat'] as num).toDouble(),
        lng: (loc['lng'] as num).toDouble(),
      );
    } catch (e, st) {
      debugPrint('[Places] details exception: $e\n$st');
      return null;
    }
  }

  // ── Reverse Geocoding ──────────────────────────────────────────────────────
  Future<String> reverseGeocode(double lat, double lng) async {
    try {
      final res = await _dio.get('$_base/geocode/json',
          queryParameters: {
            'latlng': '$lat,$lng',
            'key': _key,
            'language': 'ar',
          });
      final status = res.data['status'] as String;
      debugPrint('[Geocode] reverse status=$status  latlng=$lat,$lng');
      if (status != 'OK') {
        debugPrint('[Geocode] error=${res.data['error_message'] ?? status}');
        return '$lat, $lng';
      }
      final results = res.data['results'] as List;
      return results.isNotEmpty
          ? results.first['formatted_address'] as String
          : '$lat, $lng';
    } catch (e, st) {
      debugPrint('[Geocode] reverse exception: $e\n$st');
      return '$lat, $lng';
    }
  }

  void dispose() => _dio.close();
}
