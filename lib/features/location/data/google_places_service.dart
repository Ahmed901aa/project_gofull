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
      debugPrint('[Places] details: "$name"');
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
  // Primary: Google Geocoding API
  // Fallback: Nominatim (free, no key — ensures a readable name is always returned)
  Future<String> reverseGeocode(double lat, double lng) async {
    // 1 — Google Geocoding API
    try {
      final res = await _dio.get(_geocodeBase, queryParameters: {
        'latlng': '$lat,$lng',
        'key': _key,
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

    // 2 — Nominatim fallback (no API key needed)
    try {
      final r = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lng,
          'accept-language': 'ar',
        },
        options: Options(headers: {'User-Agent': 'GoFullApp/1.0'}),
      );
      final addr = r.data['address'] as Map<String, dynamic>?;
      if (addr != null) {
        final parts = [
          addr['neighbourhood'],
          addr['suburb'],
          addr['city'] ?? addr['town'] ?? addr['village'],
        ].whereType<String>().where((s) => s.isNotEmpty).toList();
        if (parts.isNotEmpty) return parts.join('، ');
      }
      return r.data['display_name'] as String? ?? '$lat, $lng';
    } catch (_) {
      return '$lat, $lng';
    }
  }

  void dispose() => _dio.close();
}
