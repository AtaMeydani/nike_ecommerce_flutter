import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cart_item.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
          return CartBloc(cartRepository: cartRepository)..add(CartStartedEvent());
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
            } else {
              throw Exception('cart state is not valid');
            }
          },
        ),
      ),
    );

    // body: ValueListenableBuilder<AuthInfo?>(
    //   valueListenable: AuthRepository.authChangeNotifier,
    //   builder: (BuildContext context, authInfo, Widget? child) {
    //     bool isAuthenticated = authInfo?.accessToken != null;
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(isAuthenticated ? 'خوش آمدید' : 'لطفا وارد حساب کاربری خود شوید'),
    //         if (!isAuthenticated)
    //           ElevatedButton(
    //             onPressed: () {
    //               Navigator.of(context, rootNavigator: true).pushReplacement(
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return LoginScreen();
    //                   },
    //                 ),
    //               );
    //             },
    //             child: Text('ورود'),
    //           )
    //       ],
    //     );
    //   },
    // ),
    // );
  }
}
