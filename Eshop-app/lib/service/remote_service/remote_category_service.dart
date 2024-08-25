import 'dart:convert';
import 'package:eshop/model/category.dart';
import 'package:http/http.dart' as http;
import 'package:eshop/const.dart';

class RemoteCategoryService {
  final String remoteUrl = '$baseUrl/api/categories';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(remoteUrl));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      List jsonResponse = json.decode(decodedBody);
      return jsonResponse.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
