class User {
  final String token;
  final int id;
  late final String name;
  final String email;
  // Không nên sử dụng trường 'password' để lưu mật khẩu ở dạng văn bản rõ ràng
  final String password;
  final String phone;
   final String address;
   final bool gender;
  final bool status;
   final String image;
  final String registerDate;
  final List<String> roles;

  User({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.gender,
    required this.status,
    required this.image,
    required this.registerDate,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] ?? '',
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '', // Cần xem xét mã hóa mật khẩu trước khi lưu
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? false,
      status: json['status'] ?? false,
      image: json['image'] ?? '',
      registerDate: json['registerDate'] ?? '',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'password': password, // Cần xem xét mã hóa mật khẩu trước khi trả về
      'phone': phone,
      'address': address,
      'gender': gender,
      'status': status,
      'image': image,
      'registerDate': registerDate,
      'roles': roles,
    };
  }
}
