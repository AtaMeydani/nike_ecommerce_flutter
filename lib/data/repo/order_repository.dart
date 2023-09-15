import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/payment_receipt.dart';
import 'package:nike_ecommerce_flutter/data/src/order_data_source.dart';

final orderRepository = OrderRepository(remoteDataSource: OrderRemoteDataSource(httpClient: httpClient));

abstract class IOrderRepository {
  Future<OrderResult> order({required OrderParams orderParams});
  Future<PaymentReceipt> getPaymentReceipt({required int orderId});
}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource remoteDataSource;

  OrderRepository({required this.remoteDataSource});

  @override
  Future<OrderResult> order({required OrderParams orderParams}) {
    return remoteDataSource.order(orderParams: orderParams);
  }

  @override
  Future<PaymentReceipt> getPaymentReceipt({required int orderId}) {
    return remoteDataSource.getPaymentReceipt(orderId: orderId);
  }
}
