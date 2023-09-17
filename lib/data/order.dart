import 'package:nike_ecommerce_flutter/data/product.dart';

class OrderResult {
  final int orderId;
  final String bankGatewayUrl;

  OrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class OrderParams {
  final String firstName;
  final String lastName;
  final String mobile;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  OrderParams(
      {required this.firstName,
      required this.lastName,
      required this.mobile,
      required this.postalCode,
      required this.address,
      required this.paymentMethod});
}

enum PaymentMethod {
  online,
  // ignore: constant_identifier_names
  cash_on_delivery,
}

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> products;

  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        products =
            (json['order_items'] as List).map((orderItem) => ProductEntity.fromJson(orderItem['product'])).toList();
}
