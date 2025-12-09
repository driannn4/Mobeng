import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductApi {
  // BASE URL MockAPI kamu
  static const String baseUrl =
      "https://69361f9afa8e704dafbfb321.mockapi.io/products";

  // ============================
  //           GET ALL
  // ============================
  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load products");
    }
  }

  // ============================
  //           CREATE
  // ============================
  // Fungsi ini menerima ARGUMEN BERNAMA (name:, price:, image:, description:)
  static Future<dynamic> createProduct({
    required String name,
    required num price,
    required String image,
    String description = '',
  }) async {
    final body = json.encode({
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to create product: ${response.statusCode} ${response.body}');
    }
  }

  // ============================
  //           UPDATE
  // ============================
  static Future<dynamic> updateProduct({
    required String id,
    required String name,
    required num price,
    required String image,
    String description = '',
  }) async {
    final body = json.encode({
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    });

    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          "Failed to update product: ${response.statusCode} ${response.body}");
    }
  }

  // ============================
  //           DELETE
  // ============================
  static Future<bool> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to delete product: ${response.statusCode} ${response.body}");
    }
  }
}