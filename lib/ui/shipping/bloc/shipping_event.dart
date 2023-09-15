part of 'shipping_bloc.dart';

sealed class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

class ShippingCreateOrderEvent extends ShippingEvent {
  final OrderParams orderParams;

  const ShippingCreateOrderEvent({required this.orderParams});
}
