import 'package:eshop/model/product.dart';
import 'package:eshop/model/userInfo.dart';

// class User {
//   int userId;
//   String name;
//   String email;
//   String password;
//   String phone;
//   String address;
//   bool gender;
//   String image;
//   String registerDate;
//   bool status;
//   String token;
//   List<Role> roles;
//
//   User({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.phone,
//     required this.address,
//     required this.gender,
//     required this.image,
//     required this.registerDate,
//     required this.status,
//     required this.token,
//     required this.roles,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     var list = json['roles'] as List;
//     List<Role> rolesList = list.map((i) => Role.fromJson(i)).toList();
//
//     return User(
//       userId: json['userId'],
//       name: json['name'],
//       email: json['email'],
//       password: json['password'],
//       phone: json['phone'],
//       address: json['address'],
//       gender: json['gender'],
//       image: json['image'],
//       registerDate: json['registerDate'],
//       status: json['status'],
//       token: json['token'],
//       roles: rolesList,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'name': name,
//       'email': email,
//       'password': password,
//       'phone': phone,
//       'address': address,
//       'gender': gender,
//       'image': image,
//       'registerDate': registerDate,
//       'status': status,
//       'token': token,
//
//     };
//   }
// }
//
//
//
//
// class Role {
//   int id;
//   String name;
//
//   Role({required this.id, required this.name});
//
//   factory Role.fromJson(Map<String, dynamic> json) {
//     return Role(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }


// class Category {
//   int categoryId;
//   String categoryName;
//
//   Category({required this.categoryId, required this.categoryName});
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       categoryId: json['categoryId'],
//       categoryName: json['categoryName'],
//     );
//   }
// }
//
// class Product {
//   int productId;
//   String name;
//   int quantity;
//   double price;
//   int discount;
//   String image;
//   String description;
//   String enteredDate;
//   bool status;
//   int sold;
//   Category category;
//
//   Product({
//     required this.productId,
//     required this.name,
//     required this.quantity,
//     required this.price,
//     required this.discount,
//     required this.image,
//     required this.description,
//     required this.enteredDate,
//     required this.status,
//     required this.sold,
//     required this.category,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productId: json['productId'],
//       name: json['name'],
//       quantity: json['quantity'],
//       price: json['price'],
//       discount: json['discount'],
//       image: json['image'],
//       description: json['description'],
//       enteredDate: json['enteredDate'],
//       status: json['status'],
//       sold: json['sold'],
//       category: Category.fromJson(json['category']),
//     );
//   }
// }

class Favorite {
  int favoriteId;
  UserIf user;
  Product product;

  Favorite({required this.favoriteId, required this.user, required this.product});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoriteId: json['favoriteId'],
      user: UserIf.fromJson(json['user']),
      product: Product.fromJson(json['product']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
      'user': user.toJson(),
      'product': product.toJson(),
    };
  }
}
