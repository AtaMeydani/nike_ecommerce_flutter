import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';

class PriceInfo extends StatelessWidget {
  final CartResponse cartResponse;

  const PriceInfo({super.key, required this.cartResponse});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'جزِیات خرید',
            style: themeData.textTheme.titleMedium!.copyWith(
              color: themeData.colorScheme.secondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            color: themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: themeData.colorScheme.shadow.withOpacity(0.1),
              ),
            ],
          ),
          child: Column(
            children: [
              PriceInfoItem(
                title: 'مبلغ کل خرید',
                value: RichText(
                  text: TextSpan(
                    text: cartResponse.totalPrice.separateByComma,
                    style: DefaultTextStyle.of(context).style.copyWith(
                          color: themeData.colorScheme.secondary,
                          fontSize: 18,
                        ),
                    children: const [
                      TextSpan(text: ' تومان', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 2,
              ),
              PriceInfoItem(
                title: 'هزینه ارسال',
                value: Text(cartResponse.shippingCost.withPriceLabel),
              ),
              const Divider(
                height: 2,
              ),
              PriceInfoItem(
                title: 'مبلغ قابل پرداخت',
                value: RichText(
                  text: TextSpan(
                    text: cartResponse.payablePrice.separateByComma,
                    style: DefaultTextStyle.of(context).style.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                    children: const [
                      TextSpan(
                        text: ' تومان',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PriceInfoItem extends StatelessWidget {
  final String title;
  final Widget value;

  const PriceInfoItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          value,
        ],
      ),
    );
  }
}
