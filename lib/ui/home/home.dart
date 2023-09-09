import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/common/http_client.dart';
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
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
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
                    )
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
