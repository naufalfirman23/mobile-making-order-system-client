import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/const/capi.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/core.dart';
import 'package:mobile/pages/nav/subnav/terima_pesanan.dart';

import '../../const/cApiServices.dart';

class InfoPesananPage extends StatefulWidget {
  @override
  _InfoPesananPageState createState() => _InfoPesananPageState();
}

class _InfoPesananPageState extends State<InfoPesananPage> {
  List<Map<String, dynamic>> pesanan = [];
  bool isLoading = true;
  final ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    fetchPesanan();
  }

  Future<void> fetchPesanan() async {
    final String? token = await apiServices.getToken();
    final url = Uri.parse(ApiUri.baseUrl + ApiUri.orders);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> apiData = data['data'];

        setState(() {
          pesanan = apiData.where((item) {
            return item['terima'] == 0;
          }).map((item) {
            return {
              "id_order": item['id'],
              "NoPesanan": item['nomor_pesanan'],
              "Nama": item['nama_pemesan'],
              "Produk": item['product']['nama'],
              "Kategori": item['nama_kategori'],
              "Total": "${item['total_price']}",
              "status": item['status'],
              "konfirmasi": item['konfirmasi'],
            };
          }).toList();

          pesanan.sort((a, b) {
            if (a['status'] == 'completed' && a['konfirmasi'] == 'sudah') {
              return -1;
            } else if (b['status'] == 'completed' && b['konfirmasi'] == 'sudah') {
              return 1;
            }

            if (a['status'] == 'pending' && a['konfirmasi'] == 'sudah') {
              return -1; 
            } else if (b['status'] == 'pending' && b['konfirmasi'] == 'sudah') {
              return 1;
            }

            if (a['status'] == 'pending' && a['konfirmasi'] == 'belum') {
              return -1; 
            } else if (b['status'] == 'pending' && b['konfirmasi'] == 'belum') {
              return 1;
            }
            return 0;
          });

          isLoading = false;
        });
      } else {
        print('Gagal mengambil data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: ColorPalete.utama,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        "Daftar Pemesan",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontType.interBold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pesanan.length,
                      itemBuilder: (context, index) {
                        final item = pesanan[index];

                        final statusText = (item['status'] == 'pending' &&
                                item['konfirmasi'] == 'belum')
                            ? "Belum\nKonfirmasi"
                            : (item['status'] == 'pending' &&
                                    item['konfirmasi'] == 'sudah')
                                ? "Di Proses"
                                : (item['status'] == 'completed' &&
                                        item['konfirmasi'] == 'sudah')
                                    ? "Pesanan\nReady"
                                    : "Status Tidak Dikenal";

                        final statusColor = (item['status'] == 'pending' &&
                                item['konfirmasi'] == 'belum')
                            ? Colors.orange
                            : (item['status'] == 'pending' &&
                                    item['konfirmasi'] == 'sudah')
                                ? Colors.blue
                                : (item['status'] == 'completed' &&
                                        item['konfirmasi'] == 'sudah')
                                    ? Colors.green
                                    : Colors.grey;

                        final statusIcon = (item['status'] == 'pending' &&
                                item['konfirmasi'] == 'belum')
                            ? Icons.warning_sharp
                            : (item['status'] == 'pending' &&
                                    item['konfirmasi'] == 'sudah')
                                ? Icons.pending
                                : (item['status'] == 'completed' &&
                                        item['konfirmasi'] == 'sudah')
                                    ? Icons.check_outlined
                                    : Icons.error_outline;

                        return GestureDetector(
                          onTap: (item['status'] == 'completed' &&
                                  item['konfirmasi'] == 'sudah')
                              ? () {
                                  // Navigasi hanya dilakukan jika kondisinya terpenuhi
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TerimaPesananPage(
                                        nama_pemesan: item['Nama'],
                                        kategori: item['Kategori'],
                                        itemPesanan: item['Produk'],
                                        idOrder: item['id_order'],
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 4.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: statusColor,
                                        child: Icon(
                                          statusIcon,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        statusText,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: statusColor,
                                          fontFamily: FontType.interReg,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "No. Pesanan : ${item['NoPesanan']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(
                                          "Nama Produk : ${item['Nama']}",
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        Text(
                                          "Kategori Pemesanan : ${item['Kategori']}",
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                        Text(
                                          "Total Pembayaran : ${item['Total']}",
                                          style: TextStyle(fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
