part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitialState extends ProductState {}

final class ProductAddToCartButtonLoadingState extends ProductState {}

final class ProductAddToCartSuccessState extends ProductState {}

final class ProductAddToCartErrorState extends ProductState {
  final AppException appException;

  const ProductAddToCartErrorState({required this.appException});

  @override
  List<Object> get props => [appException];
}
