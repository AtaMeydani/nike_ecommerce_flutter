import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartLoadingState()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStartedEvent) {
        emit(CartLoadingState());
        try {
          final CartResponse cartResponse = await cartRepository.getAll();
          emit(CartSuccessState(cartResponse: cartResponse));
        } catch (e) {
          emit(CartErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
