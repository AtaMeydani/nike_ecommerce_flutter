import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/ui/product/details.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity productEntity;
  final BorderRadius borderRadius;
  const ProductItem({
    super.key,
    required this.productEntity,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      constraints: const BoxConstraints.expand(width: 180),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productEntity: productEntity,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ImageLoadingService(
                    imageUrl: productEntity.image,
                    borderRadius: borderRadius,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      alignment: Alignment.center,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        CupertinoIcons.heart,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productEntity.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              productEntity.previousPrice.withPriceLabel,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
            Text(
              productEntity.price.withPriceLabel,
            ),
          ],
        ),
      ),
    );
  }
}
