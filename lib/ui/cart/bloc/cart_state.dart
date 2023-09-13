part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartLoadingState extends CartState {}

final class CartSuccessState extends CartState {
  final CartResponse cartResponse;

  const CartSuccessState({required this.cartResponse});

  @override
  List<Object> get props => [cartResponse];
}

final class CartErrorState extends CartState {
  final AppException appException;

  const CartErrorState({required this.appException});
}

final class CartAuthRequiredState extends CartState {}

final class CartEmptyState extends CartState {}
