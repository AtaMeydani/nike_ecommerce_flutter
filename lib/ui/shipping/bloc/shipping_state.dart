part of 'shipping_bloc.dart';

sealed class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

final class ShippingInitialState extends ShippingState {}

final class ShippingLoadingState extends ShippingState {}

final class ShippingErrorState extends ShippingState {
  final AppException appException;

  const ShippingErrorState({required this.appException});

  @override
  List<Object> get props => [appException];
}

final class ShippingSuccessState extends ShippingState {
  final OrderResult orderResult;

  const ShippingSuccessState({required this.orderResult});

  @override
  List<Object> get props => [orderResult];
}
