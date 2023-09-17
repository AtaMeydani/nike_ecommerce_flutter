import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/favorite_manager.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/ui/product/details.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  final ProductEntity productEntity;
  final BorderRadius borderRadius;
  const ProductItem({
    super.key,
    required this.productEntity,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      constraints: const BoxConstraints.expand(width: 180),
      child: InkWell(
        borderRadius: widget.borderRadius,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productEntity: widget.productEntity,
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
                    imageUrl: widget.productEntity.image,
                    borderRadius: widget.borderRadius,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () async {
                        await favoriteManager.toggle(widget.productEntity);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: favoriteManager.isFavorite(widget.productEntity)
                            ? const Icon(
                                CupertinoIcons.heart_fill,
                                size: 20,
                              )
                            : const Icon(
                                CupertinoIcons.heart,
                                size: 20,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.productEntity.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              widget.productEntity.previousPrice.withPriceLabel,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
            Text(
              widget.productEntity.price.withPriceLabel,
            ),
          ],
        ),
      ),
    );
  }
}
