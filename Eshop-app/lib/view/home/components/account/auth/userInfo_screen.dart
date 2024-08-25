import 'package:flutter/material.dart';
import '../../../../../model/userInfo.dart';
import '../../../../../service/remote_service/remote_auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({super.key, required this.token});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserIf?> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _fetchUser();
  }

  Future<UserIf?> _fetchUser() async {
    // Lấy thông tin người dùng từ API bằng RemoteAuthService
    return await RemoteAuthService().getProfile(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal information'),
      ),
      body: Center(
        child: FutureBuilder<UserIf?>(
          future: _futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: snapshot.data!.image != null
                            ? NetworkImage(snapshot.data!.image!)
                            : null, // Trả về null nếu image là null
                        child: snapshot.data!.image == null
                            ? Icon(Icons.person) // Hiển thị biểu tượng mặc định nếu image là null
                            : null, // Không có child khi backgroundImage được sử dụng
                      ),
                    ),


                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, size: 24), // Thêm biểu tượng người dùng
                          const SizedBox(width: 8),
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.mail),
                          Text(
                            ' ${snapshot.data!.email}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on),
                          Container(
                            width: 200, // Điều chỉnh độ rộng để địa chỉ không tràn màn hình
                            child: Text(
                              ' ${snapshot.data!.address}',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1, // Giới hạn số dòng là 1
                              overflow: TextOverflow.ellipsis, // Hiển thị dấu chấm ở cuối nếu tràn
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone),
                          Text(
                            ' ${snapshot.data!.phone}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    // Add more user information here as needed
                  ],
                ),
              );
            } else {
              return const Text(
                'No user data available',
                style: TextStyle(color: Colors.grey),
              );
            }
          },
        ),
      ),
    );
  }
}
