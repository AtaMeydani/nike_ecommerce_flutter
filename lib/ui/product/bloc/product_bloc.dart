import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/add_to_cart_response.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;

  ProductBloc({required this.cartRepository}) : super(ProductInitialState()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonIsClickedEvent) {
        emit(ProductAddToCartButtonLoadingState());
        try {
          final AddToCartResponse cartResponse = await cartRepository.add(productId: event.productId);
          emit(ProductAddToCartSuccessState());
        } catch (e) {
          emit(ProductAddToCartErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
