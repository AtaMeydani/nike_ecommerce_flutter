part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStartedEvent extends CartEvent {
  final AuthInfo? authInfo;

  const CartStartedEvent({required this.authInfo});
}

class CartDeleteButtonIsClickedEvent extends CartEvent {}

class CartAuthInfoChangedEvent extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChangedEvent({required this.authInfo});
}
