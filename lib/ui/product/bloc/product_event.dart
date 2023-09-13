part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CartAddButtonIsClickedEvent extends ProductEvent {
  final int productId;

  const CartAddButtonIsClickedEvent({required this.productId});
}
