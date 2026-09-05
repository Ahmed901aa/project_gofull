import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project_gofull/core/config/api_keys.dart';
import 'reverse_geocode_service.dart';

class PlacePrediction {
  final String placeId;
  final String title;
  final String subtitle;
  const PlacePrediction({required this.placeId, required this.title, required this.subtitle});
}

typedef PlaceDetail = ({String address, double lat, double lng});

/// Places API (New) + Geocoding API wrapper.
class GooglePlacesService {
  static const _key = ApiKeys.googleMaps;
  static const _placesBase = 'https://places.googleapis.com/v1/places';

  final _dio = Dio();
  late final _reverseGeocoder = ReverseGeocodeService(dio: _dio, apiKey: _key);

  Future<List<PlacePrediction>> autocomplete(String query) async {
    try {
      final res = await _dio.post(
        '$_placesBase:autocomplete',
        data: {'input': query, 'languageCode': 'ar'},
        options: Options(headers: {'X-Goog-Api-Key': _key, 'Content-Type': 'application/json'}),
      );
      final suggestions = res.data['suggestions'] as List? ?? [];
      debugPrint('[Places] autocomplete: ${suggestions.length} results for "$query"');
      return suggestions.map((s) {
        final p = s['placePrediction'] as Map;
        final sf = p['structuredFormat'] as Map? ?? {};
        return PlacePrediction(
          placeId: p['placeId'] as String,
          title: (sf['mainText'] as Map?)?['text'] as String? ?? (p['text'] as Map?)?['text'] as String? ?? query,
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

  Future<PlaceDetail?> getDetails(String placeId) async {
    try {
      final res = await _dio.get(
        '$_placesBase/$placeId',
        options: Options(headers: {'X-Goog-Api-Key': _key, 'X-Goog-FieldMask': 'displayName,location,formattedAddress'}),
      );
      final loc = res.data['location'] as Map;
      final name = (res.data['displayName'] as Map?)?['text'] as String? ?? res.data['formattedAddress'] as String? ?? placeId;
      debugPrint('[Places] details: "$name"');
      return (address: name, lat: (loc['latitude'] as num).toDouble(), lng: (loc['longitude'] as num).toDouble());
    } on DioException catch (e) {
      debugPrint('[Places] details error: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      debugPrint('[Places] details exception: $e');
      return null;
    }
  }

  Future<String> reverseGeocode(double lat, double lng) => _reverseGeocoder.reverseGeocode(lat, lng);

  void dispose() => _dio.close();
}
