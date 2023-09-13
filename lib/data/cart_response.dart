class CartResponse {
  final int count;
  final int productId;
  final int cartItemId;

  CartResponse.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        productId = json['product_id'],
        cartItemId = json['id'];
}
