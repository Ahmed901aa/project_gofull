import 'package:shared_preferences/shared_preferences.dart';
import 'location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationCubit extends Cubit<LocationState> {
  static const _keyAddress = 'saved_address';
  static const _keyLat = 'saved_lat';
  static const _keyLng = 'saved_lng';

  LocationCubit() : super(const LocationState()) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString(_keyAddress);
    final lat = prefs.getDouble(_keyLat);
    final lng = prefs.getDouble(_keyLng);
    if (address != null) {
      emit(LocationState(address: address, lat: lat, lng: lng));
    }
  }

  Future<void> setLocation(String address, double lat, double lng) async {
    emit(LocationState(address: address, lat: lat, lng: lng));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAddress, address);
    await prefs.setDouble(_keyLat, lat);
    await prefs.setDouble(_keyLng, lng);
  }
}
