import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/src/product_data_source.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchTerm);
}

class ProductRepository implements IProductRepository {
  IProductDataSource remoteDataSource;
  ProductRepository({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getAll(int sort) => remoteDataSource.getAll(sort);

  @override
  Future<List<ProductEntity>> search(String searchTerm) => remoteDataSource.search(searchTerm);
}

// final httpClient = Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'));
// final productRepository = ProductRepository(remoteDataSource: ProductRemoteDataSource(httpClient: httpClient));
