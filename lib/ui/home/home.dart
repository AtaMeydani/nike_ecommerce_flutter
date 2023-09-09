import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/banner_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/product_repository.dart';
import 'package:nike_ecommerce_flutter/data/src/banner_data_source.dart';
import 'package:nike_ecommerce_flutter/data/src/product_data_source.dart';
import 'package:nike_ecommerce_flutter/ui/home/bloc/home_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/image.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/slider.dart';

final productRepository = ProductRepository(remoteDataSource: ProductRemoteDataSource(httpClient: httpClient));
final bannerRepository = BannerRepository(remoteDataSource: BannerRemoteDataSource(httpClient: httpClient));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HomeBloc(bannerRepository: bannerRepository, productRepository: productRepository)
          ..add(HomeStartedEvent());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccessState) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 100),
                  children: [
                    SizedBox(
                      height: 26,
                      child: Image.asset(
                        'assets/images/nike_logo.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    BannerSlider(
                      banners: state.banners,
                    ),
                    _HorizontalProductListTitle(
                      title: 'جدیدترین',
                      onTap: () {},
                    ),
                    _HorizontalProductList(
                      products: state.latestProducts,
                    ),
                    _HorizontalProductListTitle(
                      title: 'پربازدیدترین',
                      onTap: () {},
                    ),
                    _HorizontalProductList(
                      products: state.popularProducts,
                    ),
                  ],
                );
              } else if (state is HomeLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeErrorState) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent());
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ));
              } else {
                throw Exception('state is not supported');
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HorizontalProductListTitle extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  const _HorizontalProductListTitle({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: onTap,
            child: const Text('مشاهده همه'),
          ),
        ],
      ),
    );
  }
}

class _HorizontalProductList extends StatelessWidget {
  final List<ProductEntity> products;
  const _HorizontalProductList({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: ListView.builder(
        physics: defaultScrollPhysics,
        padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _Product(productEntity: products[index]);
        },
      ),
    );
  }
}

class _Product extends StatelessWidget {
  final ProductEntity productEntity;
  const _Product({required this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      constraints: const BoxConstraints.expand(width: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ImageLoadingService(
                  imageUrl: productEntity.image,
                  borderRadius: BorderRadius.circular(12),
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
    );
  }
}
