import 'dart:convert';
import 'package:eshop/const.dart';
import 'package:eshop/model/product.dart';
import 'package:http/http.dart' as http;
class RemoteProductService{
    final String remoteUrl='$baseUrl/api/products/status';
    Future<List<Product>>fetchProduct() async{
        final response= await http.get(Uri.parse(remoteUrl));
    if(response.statusCode==200){
        final decodedBody=utf8.decode(response.bodyBytes);
        List jsonResponse = json.decode(decodedBody);
        return jsonResponse.map((product) =>Product.fromJson(product)).toList();
    }else{
        throw Exception('Failed to load product');
    }

    }
    // Lấy thông tin chi tiết của sản phẩm dựa trên productId
    Future<Product> fetchProductDetail(int productId) async {
        final productDetailUrl = '$remoteUrl/$productId';
        final response = await http.get(Uri.parse(productDetailUrl));
        if (response.statusCode == 200) {
            final decodedBody = utf8.decode(response.bodyBytes);
            final jsonData = json.decode(decodedBody);
            return Product.fromJson(jsonData);
        } else {
            throw Exception('Failed to load product detail');
        }
    }

    // new product
    Future<List<Product>> fetchLatestProducts() async {
        try {
            final response = await http.get(Uri.parse(remoteUrl));

            if (response.statusCode == 200) {
                final decodedBody = utf8.decode(response.bodyBytes); // Sử dụng mã hóa UTF-8
                List<dynamic> jsonData = json.decode(decodedBody);
                List<Product> latestProducts = jsonData.map((json) => Product.fromJson(json)).toList();

                // Sắp xếp danh sách sản phẩm theo ngày tạo gần nhất
                latestProducts.sort((a, b) => b.enteredDate.compareTo(a.enteredDate));

                return latestProducts.take(10).toList(); // Chỉ lấy 10 sản phẩm đầu tiên
            } else {
                throw Exception('Không thể tải danh sách sản phẩm mới nhất');
            }
        } catch (e) {
            throw Exception('Lỗi: $e');
        }
    }


}