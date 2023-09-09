import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/src/product_data_source.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> getAll({required int sort});
  Future<List<ProductEntity>> search({required String searchTerm});
}

class ProductRepository implements IProductRepository {
  final IProductDataSource remoteDataSource;

  const ProductRepository({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getAll({required int sort}) => remoteDataSource.getAll(sort: sort);

  @override
  Future<List<ProductEntity>> search({required String searchTerm}) => remoteDataSource.search(searchTerm: searchTerm);
}
