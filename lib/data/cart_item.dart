import 'package:nike_ecommerce_flutter/data/product.dart';

// cart/list
class CartItemEntity {
  final ProductEntity productEntity;
  final int id;
  final int count;
  bool deleteButtonLoading = false;

  CartItemEntity({
    required this.productEntity,
    required this.id,
    required this.count,
  });

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : productEntity = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];
}
