import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/repo/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderRepository orderRepository;

  OrderHistoryBloc({required this.orderRepository}) : super(OrderHistoryLoadingState()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStartedEvent) {
        try {
          emit(OrderHistoryLoadingState());
          final List<OrderEntity> orders = await orderRepository.getOrders();
          emit(OrderHistorySuccessState(orders: orders));
        } catch (e) {
          emit(OrderHistoryErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
