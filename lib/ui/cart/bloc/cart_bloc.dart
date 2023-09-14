import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/auth.dart';
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
          await loadCartItems(emit: emit, isRefreshing: event.isRefreshing);
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
          await cartRepository.count();

          if (state is CartSuccessState) {
            final successState = state as CartSuccessState;
            successState.cartResponse.cartItems.removeWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmptyState());
            } else {
              emit(calculatePriceInfo(successState.cartResponse));
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
            await loadCartItems(emit: emit);
          }
        }
      } else if (event is IncreaseCountButtonIsClickedEvent) {
        try {
          if (state is CartSuccessState) {
            final successState = state as CartSuccessState;
            final int cartItemEntityIndex =
                successState.cartResponse.cartItems.indexWhere((element) => element.id == event.cartItemId);
            successState.cartResponse.cartItems[cartItemEntityIndex].changeCountLoading = true;
            emit(CartSuccessState(cartResponse: successState.cartResponse));

            await Future.delayed(Duration(seconds: 2));
            final newCount = successState.cartResponse.cartItems[cartItemEntityIndex].count + 1;

            await cartRepository.changeCount(
              cartItemId: event.cartItemId,
              count: newCount,
            );
            await cartRepository.count();

            successState.cartResponse.cartItems.firstWhere((element) => element.id == event.cartItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          emit(CartErrorState(appException: e is AppException ? e : AppException()));
        }
      } else if (event is DecreaseCountButtonIsClickedEvent) {
        try {
          if (state is CartSuccessState) {
            final successState = state as CartSuccessState;
            final int cartItemEntityIndex =
                successState.cartResponse.cartItems.indexWhere((element) => element.id == event.cartItemId);
            successState.cartResponse.cartItems[cartItemEntityIndex].changeCountLoading = true;
            emit(CartSuccessState(cartResponse: successState.cartResponse));

            await Future.delayed(Duration(seconds: 2));
            final newCount = successState.cartResponse.cartItems[cartItemEntityIndex].count - 1;

            await cartRepository.changeCount(
              cartItemId: event.cartItemId,
              count: newCount,
            );
            await cartRepository.count();

            successState.cartResponse.cartItems.firstWhere((element) => element.id == event.cartItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          emit(CartErrorState(appException: e is AppException ? e : AppException()));
        }
      }
    });
  }

  Future<void> loadCartItems({required Emitter<CartState> emit, bool isRefreshing = false}) async {
    try {
      if (!isRefreshing) {
        emit(CartLoadingState());
      }
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

  CartSuccessState calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    for (var cartItem in cartResponse.cartItems) {
      totalPrice += cartItem.productEntity.previousPrice * cartItem.count;
      payablePrice += cartItem.productEntity.price * cartItem.count;
    }
    shippingCost = payablePrice >= 250000 ? 0 : 25000;

    return CartSuccessState(
      cartResponse: CartResponse(
        payablePrice: payablePrice,
        totalPrice: totalPrice,
        shippingCost: shippingCost,
        cartItems: cartResponse.cartItems,
      ),
    );
  }
}
