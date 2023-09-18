part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductListStartedEvent extends ProductListEvent {
  final int sort;
  final String searchTerm;

  const ProductListStartedEvent({required this.sort, required this.searchTerm});

  @override
  List<Object> get props => [sort];
}
