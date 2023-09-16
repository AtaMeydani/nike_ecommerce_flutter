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
