import 'package:flutter/material.dart';
import 'package:mobile/const/capi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<int?> shareUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_userData');
  }

  static Future<http.Response> get(String url,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> konfirmasi(int idOrder, BuildContext context) async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }
    final url = Uri.parse(ApiUri.baseUrl + ApiUri.terima);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'order_id': idOrder,
        }),
      );
      if (response.statusCode == 201) {
        final dataResponse = response.body;
        final data = jsonDecode(dataResponse);
        return data['message'];
      } else {
        return null;
      }
    } catch (e) {
      return 'Terjadi Kesalahan';
    }
  }

  Future<Map<String, dynamic>?> getDataUser() async {
    final String? token = await getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }
    final Uri url = Uri.parse(ApiUri.baseUrl + ApiUri.user);
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.body;

        return jsonDecode(data);
      } else {
        throw Exception('Gagal mendapatkan data siswa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<MenuCategory>> fetchCategories() async {
    final String? token = await getToken();
    final response = await http.get(
      Uri.parse(ApiUri.baseUrl + ApiUri.kategori),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 'success') {
        List<dynamic> data = body['data'];

        return data.map((item) => MenuCategory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories: ${body['status']}');
      }
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  Future<List<Produk>> fetchProdukByCategory(int categoryId) async {
    final String? token = await getToken();
    final response = await http.get(
      Uri.parse(
          "${ApiUri.baseUrl}${ApiUri.productsbycategory}?category_id=$categoryId"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data != null) {
        return List<Produk>.from(data.map((item) => Produk.fromJson(item)));
      } else {
        throw Exception('Data produk tidak tersedia');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<RiwayatOrder>> ambilDataRiwayat() async {
    final String? token = await getToken();
    final response = await http.get(
      Uri.parse(ApiUri.baseUrl + ApiUri.orderHistory),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data != null) {
        return List<RiwayatOrder>.from(
            data.map((item) => RiwayatOrder.fromJson(item)));
      } else {
        throw Exception('Data produk tidak tersedia');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class RiwayatOrder {
  final int id;
  final int userId;
  final String nomorPesanan;
  final String namaPemesan;
  final int productId;
  final int quantity;
  final String totalPrice;
  final String status;
  final String konfirmasi;
  final int idKategoriPesanan;
  final int terima;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  RiwayatOrder({
    required this.id,
    required this.userId,
    required this.nomorPesanan,
    required this.namaPemesan,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.konfirmasi,
    required this.idKategoriPesanan,
    required this.terima,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory RiwayatOrder.fromJson(Map<String, dynamic> json) {
    return RiwayatOrder(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      nomorPesanan: json['nomor_pesanan'] ?? "",
      namaPemesan: json['nama_pemesan'] ?? "",
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      totalPrice: json['total_price'] ?? "0.00",
      status: json['status'] ?? "",
      konfirmasi: json['konfirmasi'] ?? "",
      idKategoriPesanan: json['id_kategori_pesanan'] ?? 0,
      terima: json['terima'] ?? 0,
      createdAt: _parseTanggal(json['created_at']),
      updatedAt: _parseTanggal(json['updated_at']),
      product: Product.fromJson(json['product']),
    );
  }

  static DateTime _parseTanggal(dynamic createdAt) {
    if (createdAt is String) {
      try {
        return DateTime.parse(createdAt); 
      } catch (e) {
        return DateTime.now();
      }
    } else {
      return DateTime.now();
    }
  }
}

class Product {
  final int id;
  final String nama;
  final String harga;
  final String gambar;
  final int kategoriId;

  Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.kategoriId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? "",
      harga: json['harga'] ?? "0.00",
      gambar: json['gambar'] ?? "",
      kategoriId: json['kategori_id'] ?? 0,
    );
  }
}


class Produk {
  final int id;
  final String nama;
  final String gambar;
  final int kategoriId;
  final String harga;

  Produk({
    required this.id,
    required this.nama,
    required this.gambar,
    required this.kategoriId,
    required this.harga,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? "",
      gambar: json['gambar'] ?? "",
      kategoriId: json['kategori_id'] ?? 0,
      harga: json['harga'] ?? 0,
    );
  }
}

class MenuCategory {
  final int id;
  final String nama;

  MenuCategory({required this.id, required this.nama});

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      nama: json['nama'],
    );
  }
}
