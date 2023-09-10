import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/banner_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;

  HomeBloc({
    required this.bannerRepository,
    required this.productRepository,
  }) : super(HomeLoadingState()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStartedEvent || event is HomeRefreshEvent) {
        emit(HomeLoadingState());
        try {
          final List<BannerEntity> banners = await bannerRepository.getAll();
          final List<ProductEntity> latestProducts = await productRepository.getAll(sort: ProductSort.latest);
          final List<ProductEntity> popularProducts = await productRepository.getAll(sort: ProductSort.popular);
          emit(HomeSuccessState(
            banners: banners,
            latestProducts: latestProducts,
            popularProducts: popularProducts,
          ));
        } catch (e) {
          emit(HomeErrorState(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
