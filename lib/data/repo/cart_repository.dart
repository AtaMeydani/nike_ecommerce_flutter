import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/add_to_cart_response.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/data/src/cart_data_source.dart';

final cartRepository = CartRepository(remoteDataSource: CartRemoteDataSource(httpClient: httpClient));

/// You can also extend ICartDataSource because all return types are the same
/// and we only have one data source
abstract class ICartRepository {
  Future<AddToCartResponse> add({required int productId});
  Future<AddToCartResponse> changeCount({required int count, required int cartItemId});
  Future<void> remove({required int cartItemId});
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRepository implements ICartRepository {
  final ICartDataSource remoteDataSource;

  CartRepository({required this.remoteDataSource});

  @override
  Future<AddToCartResponse> add({required int productId}) {
    return remoteDataSource.add(productId: productId);
  }

  @override
  Future<AddToCartResponse> changeCount({required int count, required int cartItemId}) {
    return remoteDataSource.changeCount(count: count, cartItemId: cartItemId);
  }

  @override
  Future<int> count() {
    return remoteDataSource.count();
  }

  @override
  Future<CartResponse> getAll() {
    return remoteDataSource.getAll();
  }

  @override
  Future<void> remove({required int cartItemId}) {
    return remoteDataSource.remove(cartItemId: cartItemId);
  }
}
