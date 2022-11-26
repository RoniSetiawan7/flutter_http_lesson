import 'dart:convert';
import 'dart:io';

import 'package:http_lesson/products/models/product.dart';
import 'package:http/http.dart' as http;

class ProductServices {
  static Future<List<Product>> getProduct() async {
    try {
      String fullUrl = 'https://dummyjson.com/products';
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['products'];
        return jsonResponse.map((e) => Product.fromJson(e)).toList();
      } else {
        return Future.error('Gagal Memuat Data Produk :(');
      }
    } on SocketException {
      return Future.error('Tidak Ada Koneksi Internet :(');
    } on HttpException {
      return Future.error('Layanan Tidak Ditemukan :(');
    } on FormatException {
      return Future.error('Format Data Tidak Valid :(');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
