import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/theme.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductDetailScreen({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: size.width - 48,
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('افزودن به سبد خرید'),
          ),
        ),
        body: CustomScrollView(
          physics: defaultScrollPhysics,
          slivers: [
            SliverAppBar(
              expandedHeight: size.width * 0.6,
              flexibleSpace: ImageLoadingService(imageUrl: productEntity.image),
              foregroundColor: LightThemeColors.primaryTextColor,
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
                          productEntity.title,
                          style: themeData.textTheme.titleLarge,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              productEntity.previousPrice.withPriceLabel,
                              style: themeData.textTheme.bodySmall!.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(productEntity.price.withPriceLabel),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'این کتون شدیدا برای دویدن و راه رفتن مناسب است و تقریبا هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
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
          ],
        ),
      ),
    );
  }
}
