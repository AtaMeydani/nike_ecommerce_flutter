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
import 'package:nike_ecommerce_flutter/ui/widgets/empty_state.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

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
    ThemeData themeData = Theme.of(context);

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
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: themeData.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: themeData.colorScheme.shadow.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints.expand(height: 120),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ImageLoadingService(
                                  imageUrl: cartItemEntity.productEntity.image,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(cartItemEntity.productEntity.title),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text('تعداد'),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(CupertinoIcons.plus_rectangle),
                                      ),
                                      Text(
                                        cartItemEntity.count.toString(),
                                        style: themeData.textTheme.titleLarge,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(CupertinoIcons.minus_rectangle),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(cartItemEntity.productEntity.previousPrice.withPriceLabel,
                                      style: themeData.textTheme.bodySmall!.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      )),
                                  Text(
                                    cartItemEntity.productEntity.price.withPriceLabel,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('حذف از سبد خرید'),
                        ),
                      ],
                    ),
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
