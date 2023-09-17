part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

final class OrderHistoryLoadingState extends OrderHistoryState {}

final class OrderHistorySuccessState extends OrderHistoryState {
  final List<OrderEntity> orders;

  const OrderHistorySuccessState({required this.orders});
  @override
  List<Object> get props => [orders];
}

final class OrderHistoryErrorState extends OrderHistoryState {
  final AppException appException;

  const OrderHistoryErrorState({required this.appException});

  @override
  List<Object> get props => [appException];
}
