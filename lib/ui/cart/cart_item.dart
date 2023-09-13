import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cart_item.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.cartItemEntity,
    required this.onDeleteButtonClick,
  });

  final CartItemEntity cartItemEntity;
  final GestureTapCallback onDeleteButtonClick;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
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
                ),
              ],
            ),
          ),
          const Divider(
            height: 2,
          ),
          TextButton(
            onPressed: onDeleteButtonClick,
            child:
                cartItemEntity.deleteButtonLoading ? const CupertinoActivityIndicator() : const Text('حذف از سبد خرید'),
          ),
        ],
      ),
    );
  }
}
