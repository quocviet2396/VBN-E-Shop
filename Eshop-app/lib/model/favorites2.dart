class Favorite2 {

  final int userId;
  final int productId;

  Favorite2({required this.userId, required this.productId});

  factory Favorite2.fromJson(Map<String, dynamic> json) {
    return Favorite2(
      userId: json['userId'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
    };
  }
}

