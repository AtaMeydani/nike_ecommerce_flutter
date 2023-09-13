import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/ui/product/bloc/product_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/product/comment/comment_list.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity productEntity;
  const ProductDetailScreen({super.key, required this.productEntity});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository: cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccessState) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text('با موفیت به سبد خرید شما اضافه شد'),
                ),
              );
            } else if (state is ProductAddToCartErrorState) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text(state.appException.message),
                ),
              );
            }
          });

          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldMessengerKey,
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonIsClickedEvent(productId: widget.productEntity.id));
                    },
                    label: state is ProductAddToCartButtonLoadingState
                        ? const CupertinoActivityIndicator()
                        : const Text('افزودن به سبد خرید'),
                  );
                },
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: size.width * 0.6,
                  flexibleSpace: ImageLoadingService(imageUrl: widget.productEntity.image),
                  foregroundColor: themeData.colorScheme.onSurface,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.heart),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.productEntity.title,
                              style: themeData.textTheme.titleLarge,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.productEntity.previousPrice.withPriceLabel,
                                  style: themeData.textTheme.bodySmall!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(widget.productEntity.price.withPriceLabel),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'این کتون شدیدا برای دویدن و راه رفتن مناسب است و تقریبا هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: themeData.textTheme.titleMedium,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('ثبت نظر'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.productEntity.id)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldMessengerKey.currentState?.dispose();
    super.dispose();
  }
}
