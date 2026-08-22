import 'package:project_gofull/core/network/api_client.dart';
import 'package:project_gofull/core/network/api_constants.dart';
import 'package:project_gofull/core/error/exceptions.dart';
import 'package:project_gofull/features/home/data/models/offer_model.dart';

abstract class HomeDataSource {
  Future<List<OfferModel>> getOffers();
}

class HomeMockDataSource implements HomeDataSource {
  @override
  Future<List<OfferModel>> getOffers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      OfferModel(
        id: 'offer-1',
        title: '20% off your first fuel order',
        code: 'GO20',
        colorValue: 0xFF004B3B,
      ),
      OfferModel(
        id: 'offer-2',
        title: '20% off your first tow request',
        code: 'GO20',
        colorValue: 0xFF006B52,
      ),
    ];
  }
}

class HomeRemoteDataSource implements HomeDataSource {
  final ApiClient apiClient;
  HomeRemoteDataSource(this.apiClient);

  @override
  Future<List<OfferModel>> getOffers() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.offers);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ServerException('Failed to load offers');
    }
  }
}
