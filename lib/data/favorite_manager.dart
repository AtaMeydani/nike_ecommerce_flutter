import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';

final FavoriteManager favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = 'favorite';
  final _box = Hive.box<ProductEntity>(_boxName);
  ValueListenable<Box<ProductEntity>> get listenable => Hive.box<ProductEntity>(_boxName).listenable();

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  Future<void> toggle(ProductEntity productEntity) async {
    if (isFavorite(productEntity)) {
      return delete(productEntity);
    } else {
      return add(productEntity);
    }
  }

  Future<void> add(ProductEntity productEntity) {
    return _box.put(productEntity.id, productEntity);
  }

  Future<void> delete(ProductEntity productEntity) async {
    return _box.delete(productEntity.id);
  }

  List<ProductEntity> get favorites => _box.values.toList();

  bool isFavorite(ProductEntity productEntity) {
    return _box.containsKey(productEntity.id);
  }
}
