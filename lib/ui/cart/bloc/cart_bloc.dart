import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/auth.dart';
import 'package:nike_ecommerce_flutter/data/cart_item.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartLoadingState()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStartedEvent) {
        final AuthInfo? authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequiredState());
        } else {
          await loadCartItems(emit);
        }
      } else if (event is CartDeleteButtonIsClickedEvent) {
        try {
          if (state is CartSuccessState) {
            final successState = state as CartSuccessState;
            final int cartItemEntityIndex =
                successState.cartResponse.cartItems.indexWhere((element) => element.id == event.cartItemId);
            successState.cartResponse.cartItems[cartItemEntityIndex].deleteButtonLoading = true;
            emit(CartSuccessState(cartResponse: successState.cartResponse));
          }
          await Future.delayed(Duration(seconds: 2));

          await cartRepository.remove(cartItemId: event.cartItemId);

          if (state is CartSuccessState) {
            final successState = state as CartSuccessState;
            successState.cartResponse.cartItems.removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmptyState());
            } else {
              emit(CartSuccessState(cartResponse: successState.cartResponse));
            }
          }
        } catch (e) {
          emit(CartErrorState(appException: e is AppException ? e : AppException()));
        }
      } else if (event is CartAuthInfoChangedEvent) {
        final AuthInfo? authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequiredState());
        } else {
          if (state is CartAuthRequiredState) {
            await loadCartItems(emit);
          }
        }
      }
    });
  }

  Future<void> loadCartItems(Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      final CartResponse cartResponse = await cartRepository.getAll();
      if (cartResponse.cartItems.isEmpty) {
        emit(CartEmptyState());
      } else {
        emit(CartSuccessState(cartResponse: cartResponse));
      }
    } catch (e) {
      emit(CartErrorState(appException: e is AppException ? e : AppException()));
    }
  }
}
