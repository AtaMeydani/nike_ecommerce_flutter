import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerEntity> banners;
  final PageController _pageController = PageController();
  BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      /**
       * The aspect ratio is expressed as a ratio of width to height.
       * For example, an aspect ratio of 2 means that the width should be 
       * twice as large as the height
       */
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: defaultScrollPhysics,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return _Banner(bannerEntity: banners[index]);
            },
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: banners.length,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                  spacing: 8.0,
                  radius: 4.0,
                  dotWidth: 24.0,
                  dotHeight: 3.0,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 1.5,
                  dotColor: Colors.grey.shade400,
                  activeDotColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final BannerEntity bannerEntity;
  const _Banner({
    required this.bannerEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: ImageLoadingService(
        imageUrl: bannerEntity.image,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
