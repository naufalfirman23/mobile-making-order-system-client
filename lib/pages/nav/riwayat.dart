import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/pages/nav/subnav/detail_riwayat.dart';
import '../../const/cApiServices.dart';
import '../../const/chelper.dart';

class ColorPalette {
  static const Color accent = Color(0xFF00B0B9); // Warna aksen
  static const Color background = Color(0xFFF2F2F2); // Warna latar belakang
  static const Color textPrimary = Color(0xFF333333); // Warna teks utama
  static const Color cardBackground = Color(0xFFFFFFFF); // Warna latar belakang card
}

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final ApiServices apiServices = ApiServices();
  late Future<List<RiwayatOrder>> riwayatList;

  @override
  void initState() {
    super.initState();
    riwayatList = apiServices.ambilDataRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<RiwayatOrder>>(
        future: riwayatList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          List<RiwayatOrder> riwayat = snapshot.data!;
          riwayat.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          return Padding(
            padding: const EdgeInsets.all(13),
            child: ListView.builder(
              itemCount: riwayat.length,
              itemBuilder: (context, index) {
                return riwayatCard(riwayat[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget riwayatCard(RiwayatOrder riwayat) {
    int totalInt = double.parse(riwayat.totalPrice).toInt();
    int hargaInt = double.parse(riwayat.product.harga).toInt();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRiwayatPage(
              namaProduk: riwayat.product.nama,
              nomorPesanan: riwayat.nomorPesanan,
              createAt: riwayat.createdAt,
              quantity: riwayat.quantity,
              totalPrice: totalInt,
              hargaProduk: hargaInt,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        color: ColorPalette.cardBackground, // Menggunakan warna latar belakang card
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            "Order ID: ${riwayat.nomorPesanan}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: ColorPalette.textPrimary, // Warna teks utama
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(
                "Tanggal: ${DateFormat('dd MMM yyyy', 'id_ID').format(riwayat.createdAt)}",
                style: TextStyle(color: ColorPalette.textPrimary),
              ),
              Text(
                Helper().formatRupiah(totalInt),
                style: TextStyle(
                  color: ColorPalete.utama, // Menggunakan warna utama untuk harga
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
