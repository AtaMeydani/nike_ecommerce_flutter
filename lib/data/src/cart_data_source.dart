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
      'product_id': productId,
    };
    final response = await httpClient.post('cart/add', data: headers);
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount({required int count, required int cartItemId}) async {
    final Map<String, dynamic> headers = {
      'cart_item_id': cartItemId,
      'count': count,
    };
    final response = await httpClient.post('cart/changeCount', data: headers);
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    validateResponse(response);
    return response.data['count'];
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');
    validateResponse(response);
    return CartResponse.fromJson(response.data);
  }

  @override
  Future<void> remove({required int cartItemId}) async {
    final Map<String, dynamic> headers = {
      'cart_item_id': cartItemId,
    };
    await httpClient.post('cart/remove', data: headers);
  }
}
