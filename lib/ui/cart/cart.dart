import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cart_item.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login/login.dart';
import 'package:nike_ecommerce_flutter/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/cart/cart_item.dart';
import 'package:nike_ecommerce_flutter/ui/cart/price_info.dart';
import 'package:nike_ecommerce_flutter/ui/shipping/shipping.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final RefreshController _refreshController = RefreshController();
  StreamSubscription<CartState>? stateStreamSubscription;
  CartBloc? cartBloc;
  bool stateIsSuccess = false;

  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChangedEvent(authInfo: AuthRepository.authChangeNotifier.value));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: stateIsSuccess,
        child: Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          child: FloatingActionButton.extended(
            onPressed: () {
              final state = cartBloc!.state;

              if (state is CartSuccessState) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ShippingScreen(
                        cartResponse: state.cartResponse,
                      );
                    },
                  ),
                );
              }
            },
            label: const Text('پرداخت'),
          ),
        ),
      ),
      body: BlocProvider<CartBloc>(
        create: (context) {
          CartBloc cartBloc = CartBloc(cartRepository: cartRepository)
            ..add(CartStartedEvent(authInfo: AuthRepository.authChangeNotifier.value));
          stateStreamSubscription = cartBloc.stream.listen((state) {
            setState(() {
              stateIsSuccess = state is CartSuccessState;
            });

            if (_refreshController.isRefresh) {
              if (state is CartSuccessState) {
                _refreshController.refreshCompleted();
              } else if (state is CartErrorState) {
                _refreshController.refreshFailed();
              }
            }
          });

          this.cartBloc = cartBloc;
          return cartBloc;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is CartErrorState) {
              return Center(
                child: Text(state.appException.message),
              );
            } else if (state is CartSuccessState) {
              return SmartRefresher(
                controller: _refreshController,
                header: const ClassicHeader(
                  completeText: 'با موفقیت انجام شد',
                  refreshingText: 'در حال بروز رسانی',
                  idleText: 'برای بروزرسانی پایین بکشید',
                  releaseText: 'رها کنید',
                  failedText: 'خطای نامشخص',
                  spacing: 2,
                  completeIcon: Icon(CupertinoIcons.checkmark_circle),
                ),
                onRefresh: () {
                  cartBloc?.add(CartStartedEvent(
                    authInfo: AuthRepository.authChangeNotifier.value,
                    isRefreshing: true,
                  ));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: defaultScrollPhysics,
                  itemCount: state.cartResponse.cartItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.cartResponse.cartItems.length) {
                      final CartItemEntity cartItemEntity = state.cartResponse.cartItems[index];
                      return CartItem(
                        cartItemEntity: cartItemEntity,
                        onDeleteButtonClick: () {
                          cartBloc?.add(CartDeleteButtonIsClickedEvent(cartItemId: cartItemEntity.id));
                        },
                        onDecreaseButtonClick: () {
                          if (cartItemEntity.count > 0) {
                            cartBloc?.add(DecreaseCountButtonIsClickedEvent(cartItemId: cartItemEntity.id));
                          }
                        },
                        onIncreaseButtonClick: () {
                          cartBloc?.add(IncreaseCountButtonIsClickedEvent(cartItemId: cartItemEntity.id));
                        },
                      );
                    } else {
                      CartResponse cartResponse = state.cartResponse;
                      return PriceInfo(cartResponse: cartResponse);
                    }
                  },
                ),
              );
            } else if (state is CartAuthRequiredState) {
              return EmptyStateWidget(
                message: 'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید',
                callToAction: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  child: const Text('ورود به حساب کاربری'),
                ),
                image: SvgPicture.asset(
                  'assets/images/auth_required.svg',
                  width: 120,
                ),
              );
            } else if (state is CartEmptyState) {
              return EmptyStateWidget(
                message: 'سبد خرید شما خالی است',
                image: SvgPicture.asset(
                  'assets/images/empty_cart.svg',
                  width: 120,
                ),
              );
            } else {
              throw Exception('cart state is not valid');
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    cartBloc?.close();
    AuthRepository.authChangeNotifier.removeListener(authChangeNotifierListener);
    stateStreamSubscription?.cancel();
    super.dispose();
  }
}
