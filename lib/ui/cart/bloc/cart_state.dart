part of 'cart_bloc.dart';

sealed class CartState {
  const CartState();
}

final class CartLoadingState extends CartState {}

final class CartSuccessState extends CartState {
  final CartResponse cartResponse;

  const CartSuccessState({required this.cartResponse});
}

final class CartErrorState extends CartState {
  final AppException appException;

  const CartErrorState({required this.appException});
}

final class CartAuthRequiredState extends CartState {}

final class CartEmptyState extends CartState {}
