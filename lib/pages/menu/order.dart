import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile/const/cApiServices.dart';
import 'package:mobile/const/calert.dart';
import 'package:mobile/const/capi.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/const/cfont.dart';
import 'package:mobile/core.dart';
import 'package:mobile/pages/mainMenu.dart';

import '../../const/chelper.dart';

class OrderPage extends StatefulWidget {
  final String foodName;
  final int priceProduk;
  final int id_produk;

  OrderPage(
      {required this.id_produk,
      required this.foodName,
      required this.priceProduk});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final AlertWidget alert = AlertWidget();
  final ApiServices apiServices = ApiServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orderCountController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();

  bool isLoading = false;
  int _orderCount = 1;
  int _totalPrice = 0;
  List<dynamic> _categories = [];
  int? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _orderCountController.text = _orderCount.toString();
    _totalPrice = widget.priceProduk * _orderCount;
    _totalPriceController.text = Helper().formatRupiah(_totalPrice);
    _selectedCategory =
        _categories.isNotEmpty ? _categories[0]['nama_kategori'] : 4;
    _fetchCategories();
  }

  Future<void> postData() async {
    final Uri url = Uri.parse(ApiUri.baseUrl + ApiUri.orders);
    final String? token = await apiServices.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'nama_pemesan': _nameController.text,
      'quantity': int.parse(_orderCountController.text),
      'id_kategori_pesanan': _selectedCategory,
      'product_id': widget.id_produk,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      setState(() {
        isLoading = true;
      });
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final datanya = responseData['data'];
        final nomor = datanya['nomor_pesanan'];
        final selecttttt = _categories.isNotEmpty ? _categories[0]['nama_kategori'] : _selectedCategory;
        alert.SuccessAlert(
            context,
            "Anda berhasil melakukan Order dengan nomor $nomor dalam kategori $selecttttt dengan Total Harga: $_totalPrice",
            "Order Berhasil",
            MainMenu(selectedIndex: 0));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil: ${responseData['message']}')),
        );
      } else {
        final errorData = jsonDecode(response.body);
        alert.ErrorAlert(
          context,
          "Error: ${errorData['error']}",
          "Error!");
      }
    } catch (e) {
      alert.ErrorAlert(
          context,
          "Maaf, Terjadi Kesalahan",
          "Peringatan!");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _fetchCategories() async {
    final String? token = await apiServices.getToken();
    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiServices.get(
        ApiUri.baseUrl + ApiUri.kategoripesanan,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body);

      setState(() {
        final datanya = data['data'];
        _categories = datanya;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      alert.ErrorAlert(context, "Gagal mengambil kategori: $e", "Error");
    }
  }

  void _updateTotalPrice() {
    setState(() {
      _totalPrice = widget.priceProduk * _orderCount;
      _totalPriceController.text = Helper().formatRupiah(_totalPrice);
    });
  }

  void _submitOrder() {
    final String name = _nameController.text.trim();
    if (name.isEmpty || _orderCount <= 0 || _selectedCategory == null) {
      alert.ErrorAlert(
          context,
          "Nama pemesan, jumlah order, dan kategori tidak boleh kosong!",
          "Peringatan!");
    } else {
      postData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalete.merah,
        title: Text(
          "Order Pesanan",
          style: TextStyle(color: Colors.white, fontFamily: FontType.interBold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Pemesan",
                style: TextStyle(fontSize: 16, fontFamily: FontType.interBold),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Masukkan nama pemesan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Jumlah Order",
                style: TextStyle(fontSize: 16, fontFamily: FontType.interBold),
              ),
              TextField(
                controller: _orderCountController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _orderCount = int.tryParse(value) ?? 1;
                    _updateTotalPrice();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Order Kategori",
                style: TextStyle(fontSize: 16, fontFamily: FontType.interBold),
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                items: _categories.map<DropdownMenuItem<int>>((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal:
                              16.0), // Menambahkan padding kiri-kanan pada item
                      child: Text(category['nama_kategori']),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: const Text("Pilih Kategori"),
                isDense: true, // Membuat dropdown lebih padat
                iconSize: 24, // Ukuran icon lebih kecil jika diperlukan
              ),
              const SizedBox(height: 16),
              TextField(
                enabled: false,
                controller: _totalPriceController,
                decoration: InputDecoration(
                  labelText: "Total Harga",
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: FontType.interSemiBold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: FontType.interBold,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    backgroundColor: ColorPalete.merah,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white) 
                      :Text(
                    "Order",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: FontType.interBold),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
