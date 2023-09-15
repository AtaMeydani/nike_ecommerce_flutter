part of 'payment_receipt_bloc.dart';

sealed class PaymentReceiptEvent extends Equatable {
  const PaymentReceiptEvent();

  @override
  List<Object> get props => [];
}

class PaymentReceiptStartedEvent extends PaymentReceiptEvent {
  final int orderId;

  const PaymentReceiptStartedEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
