import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll({required int sort});
  Future<List<ProductEntity>> search({required String searchTerm});
}

class ProductRemoteDataSource with HttpResponseValidator implements IProductDataSource {
  final Dio httpClient;

  const ProductRemoteDataSource({required this.httpClient});

  @override
  Future<List<ProductEntity>> getAll({required int sort}) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validateResponse(response);
    return (response.data as List).map((json) => ProductEntity.fromJson(json)).toList();
  }

  @override
  Future<List<ProductEntity>> search({required String searchTerm}) async {
    final response = await httpClient.get('product/search?q=$searchTerm');
    validateResponse(response);
    return (response.data as List).map((json) => ProductEntity.fromJson(json)).toList();
  }
}
