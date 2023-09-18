import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/banner_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/product_repository.dart';
import 'package:nike_ecommerce_flutter/data/src/banner_data_source.dart';
import 'package:nike_ecommerce_flutter/data/src/product_data_source.dart';
import 'package:nike_ecommerce_flutter/ui/home/bloc/home_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/product/product.dart';
import 'package:nike_ecommerce_flutter/ui/product_list/product_list.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/error.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/slider.dart';

final productRepository = ProductRepository(remoteDataSource: ProductRemoteDataSource(httpClient: httpClient));
final bannerRepository = BannerRepository(remoteDataSource: BannerRemoteDataSource(httpClient: httpClient));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return BlocProvider(
      create: (context) {
        return HomeBloc(bannerRepository: bannerRepository, productRepository: productRepository)
          ..add(HomeStartedEvent());
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccessState) {
                return ListView(
                  physics: defaultScrollPhysics,
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 100),
                  children: [
                    SizedBox(
                      height: 26,
                      child: Image.asset(
                        'assets/images/nike_logo.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      height: 56,
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          label: const Text('جستجو'),
                          isCollapsed: false,
                          prefixIcon: IconButton(
                            onPressed: () {
                              _search(context);
                            },
                            icon: const Icon(CupertinoIcons.search),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide(width: 2, color: themeData.colorScheme.primary),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        style: themeData.textTheme.bodyMedium,
                        onSubmitted: (value) {
                          _search(context);
                        },
                      ),
                    ),
                    BannerSlider(
                      banners: state.banners,
                    ),
                    _HorizontalProductListTitle(
                      title: 'جدیدترین',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const ProductListScreen(sort: ProductSort.latest);
                            },
                          ),
                        );
                      },
                    ),
                    _HorizontalProductList(
                      products: state.latestProducts,
                    ),
                    _HorizontalProductListTitle(
                      title: 'پربازدیدترین',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const ProductListScreen(sort: ProductSort.popular);
                            },
                          ),
                        );
                      },
                    ),
                    _HorizontalProductList(
                      products: state.popularProducts,
                    ),
                  ],
                );
              } else if (state is HomeLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeErrorState) {
                return AppErrorWidget(
                  appException: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefreshEvent());
                  },
                );
              } else {
                throw Exception('state is not supported');
              }
            },
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProductListScreen.search(searchTerm: _searchController.text);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          return ProductItem(
            productEntity: products[index],
            borderRadius: BorderRadius.circular(12),
          );
        },
      ),
    );
  }
}
