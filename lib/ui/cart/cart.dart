import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cart_item.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login/login.dart';
import 'package:nike_ecommerce_flutter/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/cart/cart_item.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/empty_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),
      body: BlocProvider<CartBloc>(
        create: (context) {
          CartBloc cartBloc = CartBloc(cartRepository: cartRepository)
            ..add(CartStartedEvent(authInfo: AuthRepository.authChangeNotifier.value));

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
              return ListView.builder(
                physics: defaultScrollPhysics,
                itemCount: state.cartResponse.cartItems.length,
                itemBuilder: (context, index) {
                  final CartItemEntity cartItemEntity = state.cartResponse.cartItems[index];
                  return CartItem(
                    cartItemEntity: cartItemEntity,
                    onDeleteButtonClick: () {
                      cartBloc?.add(CartDeleteButtonIsClickedEvent(cartItemId: cartItemEntity.id));
                    },
                  );
                },
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
    super.dispose();
  }
}
