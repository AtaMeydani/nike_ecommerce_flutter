part of 'payment_receipt_bloc.dart';

sealed class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

final class PaymentReceiptInitial extends PaymentReceiptState {}

class PaymentReceiptLoadingState extends PaymentReceiptState {}

class PaymentReceiptSuccessState extends PaymentReceiptState {
  final PaymentReceipt paymentReceipt;

  const PaymentReceiptSuccessState({required this.paymentReceipt});

  @override
  List<Object> get props => [paymentReceipt];
}

class PaymentReceiptErrorState extends PaymentReceiptState {
  final AppException appException;

  const PaymentReceiptErrorState({required this.appException});

  @override
  List<Object> get props => [appException];
}
