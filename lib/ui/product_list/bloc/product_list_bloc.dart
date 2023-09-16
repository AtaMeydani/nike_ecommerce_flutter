import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepository;

  ProductListBloc({required this.productRepository}) : super(ProductListLoadingState()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStartedEvent) {
        emit(ProductListLoadingState());
        try {
          final List<ProductEntity> products = await productRepository.getAll(sort: event.sort);
          emit(ProductListSuccessState(products: products, sort: event.sort));
        } catch (e) {
          emit(ProductListErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
