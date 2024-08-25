import 'package:eshop/model/category.dart';
class Product {
  final int productId;
  final String name;
  final int quantity;
  final double price;
  final int discount;
  final String image;
  final String description;
  final DateTime enteredDate;
  final bool status;
  final int sold;
  final Category category;

  Product({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.image,
    required this.description,
    required this.enteredDate,
    required this.status,
    required this.sold,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      discount: json['discount'],
      image: json['image'],
      description: json['description'],
      enteredDate: DateTime.parse(json['enteredDate']),
      status: json['status'],
      sold: json['sold'],
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'image': image,
      'description': description,
      'enteredDate': enteredDate.toIso8601String(),
      'status': status,
      'sold': sold,
      'category': category.toJson(),
    };
  }
}
