import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../const.dart';
import '../../model/favorites.dart';
Future<List<Favorite>> fetchFavorites(String email) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/favorites/email/$email'),
  );
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(
        utf8.decode(response.bodyBytes)); // Giải mã UTF-8
    List<Favorite> favorites = body.map((dynamic item) =>
        Favorite.fromJson(item)).toList();
    return favorites;
  } else {
    throw Exception('Failed to load favorites');
  }
}
Future<void> addToFavorite(int userId, int productId) async {

  final response = await http.post(
    Uri.parse('$baseUrl/api/favorites/email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'user': {
        'userId': userId,
      },
      'product': {
        'productId': productId,
      },
    }),
  );

  if (response.statusCode == 200) {
    // Handle successful response
    print("Added to favorites successfully");
  } else {
    // Handle error response
    throw Exception('Failed to add to favorites.');
  }
}

Future<http.Response> removeFavorite(int favoriteId) {
  return http.delete(
    Uri.parse('$baseUrl/api/favorites/$favoriteId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

Future<bool> checkIfFavorite( int productId,String email) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/favorites/$productId/$email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    return true;

  } else {
    throw Exception('Failed to check favorite status ${response.body}' );
  }
}

Future<Favorite?> fetchFavorite(int productId,String email) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/favorites/$productId/$email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    if (body != null) {
      return Favorite.fromJson(body);  // Assuming you have a Favorite model with fromJson method
    }
    return null;
  } else {
    throw Exception('Failed to fetch favorite');
  }
}


