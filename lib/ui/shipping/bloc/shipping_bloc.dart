import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/repo/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository orderRepository;

  ShippingBloc({required this.orderRepository}) : super(ShippingInitialState()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrderEvent) {
        try {
          emit(ShippingLoadingState());
          final OrderResult orderResult = await orderRepository.order(orderParams: event.orderParams);
          emit(ShippingSuccessState(orderResult: orderResult));
        } catch (e) {
          emit(ShippingErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
