part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListStartedEvent extends ProductListEvent {
  final int sort;

  const ProductListStartedEvent({required this.sort});

  @override
  List<Object> get props => [sort];
}
