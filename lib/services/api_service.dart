
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String apiUrl =
      'https://mock.apidog.com/m1/890655-872447-default/v2/product';

  static Future<List<Product>> getProducts() async {
    try {
      // 1. Gửi HTTP GET request
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      // 2. Kiểm tra HTTP status code
      if (response.statusCode != 200) {
        throw Exception(
          'HTTP Error: ${response.statusCode}',
        );
      }

      // 3. Chuyển JSON thành dữ liệu Dart
      final decoded = jsonDecode(response.body);

      // 4. Xác định dữ liệu là object hay list
      List<dynamic> productList;

      if (decoded is List) {
        productList = decoded;
      } else if (decoded is Map<String, dynamic>) {
        final data = decoded['data'];

        if (data is List) {
          productList = data;
        } else if (data is Map<String, dynamic>) {
          productList = [data];
        } else {
          productList = [decoded];
        }
      } else {
        throw Exception('JSON không hợp lệ');
      }

      // 5. Chuyển JSON thành danh sách Product
      return productList
          .map((item) => Product.fromJson(item))
          .toList();

    } catch (e) {
      throw Exception('Lỗi lấy dữ liệu: $e');
    }
  }
}
