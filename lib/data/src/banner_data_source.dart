import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource with HttpResponseValidator implements IBannerDataSource {
  final Dio httpClient;

  const BannerRemoteDataSource({required this.httpClient});

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    return (response.data as List).map((json) => BannerEntity.fromJson(json)).toList();
  }
}
