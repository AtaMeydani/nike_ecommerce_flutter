import 'package:hive_flutter/hive_flutter.dart';
part 'product.g.dart';

class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;

  static const List<String> names = [
    'جدید ترین',
    'پربازدیدترین',
    'قیمت بالا ترین',
    'قیمت پایین ترین',
  ];
}

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int previousPrice;

  ProductEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.discount,
    required this.previousPrice,
  });

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        price = json['previous_price'] == null ? json['price'] - json['discount'] : json['price'],
        discount = json['discount'],
        previousPrice = json['previous_price'] ?? json['price'];
}
