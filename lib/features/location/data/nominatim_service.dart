import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../domain/nominatim_result.dart';

class NominatimService {
  static const _base = 'https://nominatim.openstreetmap.org';

  final _dio = Dio(BaseOptions(
    headers: {'User-Agent': 'GoFullApp/1.0'},
  ));

  Future<String> reverseGeocode(LatLng pos) async {
    final res = await _dio.get('$_base/reverse', queryParameters: {
      'format': 'json',
      'lat': pos.latitude,
      'lon': pos.longitude,
      'accept-language': 'ar',
    });
    return _extractName(res.data as Map<String, dynamic>);
  }

  Future<List<NominatimResult>> search(String query) async {
    final res = await _dio.get('$_base/search', queryParameters: {
      'format': 'json',
      'q': query,
      'accept-language': 'ar',
      'limit': '6',
    });
    return (res.data as List)
        .map((r) => NominatimResult(
              displayName: r['display_name'] as String,
              lat: double.parse(r['lat'] as String),
              lng: double.parse(r['lon'] as String),
            ))
        .toList();
  }

  String _extractName(Map<String, dynamic> data) {
    final addr = data['address'] as Map<String, dynamic>?;
    if (addr == null) return data['display_name'] as String? ?? '';
    return [
      addr['neighbourhood'],
      addr['suburb'],
      addr['city'] ?? addr['town'] ?? addr['village'],
    ].where((s) => s != null && (s as String).isNotEmpty).join('، ');
  }

  void dispose() => _dio.close();
}
