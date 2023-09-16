part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListLoadingState extends ProductListState {}

final class ProductListSuccessState extends ProductListState {
  final List<ProductEntity> products;
  final int sort;

  const ProductListSuccessState({
    required this.products,
    required this.sort,
  });

  @override
  List<Object> get props => [products, sort];
}

final class ProductListErrorState extends ProductListState {
  final AppException appException;

  const ProductListErrorState({required this.appException});

  @override
  List<Object> get props => [appException];
}
