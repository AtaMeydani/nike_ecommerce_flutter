// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:nike_ecommerce_flutter/data/banner.dart';
import 'package:nike_ecommerce_flutter/data/src/banner_data_source.dart';

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource remoteDataSource;

  const BannerRepository({required this.remoteDataSource});

  @override
  Future<List<BannerEntity>> getAll() async {
    return remoteDataSource.getAll();
  }
}
