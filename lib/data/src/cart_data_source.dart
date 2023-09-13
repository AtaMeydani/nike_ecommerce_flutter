import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/add_to_cart_response.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add({required int productId});
  Future<AddToCartResponse> changeCount({required int count, required int cartItemId});
  Future<void> remove({required int cartItemId});
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource with HttpResponseValidator implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource({
    required this.httpClient,
  });

  @override
  Future<AddToCartResponse> add({required int productId}) async {
    final Map<String, dynamic> headers = {
      'product_id': 'refresh_token',
    };
    final response = await httpClient.post('cart/add', data: headers);
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount({required int count, required int cartItemId}) {
    // TODO: implement changeCount
    throw UnimplementedError();
  }

  @override
  Future<int> count() {
    // TODO: implement count
    throw UnimplementedError();
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');
    validateResponse(response);
    return CartResponse.fromJson(response.data);
  }

  @override
  Future<void> remove({required int cartItemId}) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}
