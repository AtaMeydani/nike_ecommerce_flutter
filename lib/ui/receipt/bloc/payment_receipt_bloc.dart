import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/payment_receipt.dart';
import 'package:nike_ecommerce_flutter/data/repo/order_repository.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository orderRepository;

  PaymentReceiptBloc({required this.orderRepository}) : super(PaymentReceiptLoadingState()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStartedEvent) {
        try {
          emit(PaymentReceiptLoadingState());
          final PaymentReceipt paymentReceipt = await orderRepository.getPaymentReceipt(orderId: event.orderId);
          emit(PaymentReceiptSuccessState(paymentReceipt: paymentReceipt));
        } catch (e) {
          emit(PaymentReceiptErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
