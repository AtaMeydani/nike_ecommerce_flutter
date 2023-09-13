class AddToCartResponse {
  final int count;
  final int productId;
  final int cartItemId;

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        productId = json['product_id'],
        cartItemId = json['id'];
}
