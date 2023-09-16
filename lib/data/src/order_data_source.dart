import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/payment_receipt.dart';

abstract class IOrderDataSource {
  Future<OrderResult> order({required OrderParams orderParams});
  Future<PaymentReceipt> getPaymentReceipt({required int orderId});
}

class OrderRemoteDataSource with HttpResponseValidator implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource({required this.httpClient});

  @override
  Future<OrderResult> order({required OrderParams orderParams}) async {
    final Map<String, dynamic> body = {
      'first_name': orderParams.firstName,
      'last_name': orderParams.lastName,
      'mobile': orderParams.mobile,
      'postal_code': orderParams.postalCode,
      'address': orderParams.address,
      'payment_method': orderParams.paymentMethod.toString().split('.')[1],
    };

    final response = await httpClient.post('order/submit', data: body);
    validateResponse(response);
    return OrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceipt> getPaymentReceipt({required int orderId}) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    validateResponse(response);
    return PaymentReceipt.fromJson(response.data);
  }
}
