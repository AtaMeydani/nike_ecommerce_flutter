part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStartedEvent extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStartedEvent({required this.authInfo, this.isRefreshing = false});
}

class CartDeleteButtonIsClickedEvent extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonIsClickedEvent({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}

class CartAuthInfoChangedEvent extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChangedEvent({required this.authInfo});
}
