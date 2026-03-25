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

/// Places API (New) — places.googleapis.com/v1
/// Geocoding API   — maps.googleapis.com/maps/api/geocode/json
///
/// Requires "Places API (New)" and "Geocoding API" enabled in Google Cloud Console.
class GooglePlacesService {
  static const _key = 'AIzaSyDZ_ZezX058d36aMTOc9E--MbyWqCdOI9I';
  static const _placesBase = 'https://places.googleapis.com/v1/places';
  static const _geocodeBase =
      'https://maps.googleapis.com/maps/api/geocode/json';

  final _dio = Dio();

  // ── Autocomplete ───────────────────────────────────────────────────────────
  // POST https://places.googleapis.com/v1/places:autocomplete
  // Headers: X-Goog-Api-Key, Content-Type: application/json
  // Body:    { "input": "query", "languageCode": "ar" }
  Future<List<PlacePrediction>> autocomplete(String query) async {
    try {
      final res = await _dio.post(
        '$_placesBase:autocomplete',
        data: {'input': query, 'languageCode': 'ar'},
        options: Options(headers: {
          'X-Goog-Api-Key': _key,
          'Content-Type': 'application/json',
        }),
      );
      final suggestions = res.data['suggestions'] as List? ?? [];
      debugPrint('[Places] autocomplete: ${suggestions.length} results for "$query"');
      return suggestions.map((s) {
        final p = s['placePrediction'] as Map;
        final sf = p['structuredFormat'] as Map? ?? {};
        return PlacePrediction(
          placeId: p['placeId'] as String,
          title: (sf['mainText'] as Map?)?['text'] as String?
              ?? (p['text'] as Map?)?['text'] as String? ?? query,
          subtitle: (sf['secondaryText'] as Map?)?['text'] as String? ?? '',
        );
      }).toList();
    } on DioException catch (e) {
      debugPrint('[Places] autocomplete error: ${e.response?.data ?? e.message}');
      return [];
    } catch (e) {
      debugPrint('[Places] autocomplete exception: $e');
      return [];
    }
  }

  // ── Place Details ──────────────────────────────────────────────────────────
  // GET https://places.googleapis.com/v1/places/{placeId}
  // Headers: X-Goog-Api-Key, X-Goog-FieldMask: displayName,location,formattedAddress
  Future<PlaceDetail?> getDetails(String placeId) async {
    try {
      final res = await _dio.get(
        '$_placesBase/$placeId',
        options: Options(headers: {
          'X-Goog-Api-Key': _key,
          'X-Goog-FieldMask': 'displayName,location,formattedAddress',
        }),
      );
      final loc = res.data['location'] as Map;
      final name = (res.data['displayName'] as Map?)?['text'] as String?
          ?? res.data['formattedAddress'] as String? ?? placeId;
      debugPrint('[Places] details: "$name" @ ${loc['latitude']},${loc['longitude']}');
      return (
        address: name,
        lat: (loc['latitude'] as num).toDouble(),
        lng: (loc['longitude'] as num).toDouble(),
      );
    } on DioException catch (e) {
      debugPrint('[Places] details error: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      debugPrint('[Places] details exception: $e');
      return null;
    }
  }

  // ── Reverse Geocoding ──────────────────────────────────────────────────────
  // GET https://maps.googleapis.com/maps/api/geocode/json?latlng=LAT,LNG&key=K&language=ar
  Future<String> reverseGeocode(double lat, double lng) async {
    try {
      final res = await _dio.get(_geocodeBase, queryParameters: {
        'latlng': '$lat,$lng',
        'key': _key,
        'language': 'ar',
      });
      final status = res.data['status'] as String;
      if (status != 'OK') {
        debugPrint('[Geocode] reverse status=$status  error=${res.data['error_message'] ?? '-'}');
        return '$lat, $lng';
      }
      final results = res.data['results'] as List;
      return results.isNotEmpty
          ? results.first['formatted_address'] as String
          : '$lat, $lng';
    } catch (e) {
      debugPrint('[Geocode] reverse exception: $e');
      return '$lat, $lng';
    }
  }

  void dispose() => _dio.close();
}
