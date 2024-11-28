import 'package:flutter/material.dart';
import 'package:mobile/const/cApiServices.dart';
import 'package:mobile/const/calert.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/core.dart';
import 'package:mobile/pages/mainMenu.dart';

class TerimaPesananPage extends StatefulWidget {
  final String nama_pemesan;
  final String kategori;
  final String itemPesanan;
  final int idOrder;

  TerimaPesananPage(
      {super.key,
      required this.nama_pemesan,
      required this.kategori,
      required this.itemPesanan,
      required this.idOrder});
  @override
  _TerimaPesananPageState createState() => _TerimaPesananPageState();
}

class _TerimaPesananPageState extends State<TerimaPesananPage> {
  bool _isLoading = false;
  final ApiServices apiServices = ApiServices();
  final AlertWidget alertWidget = AlertWidget();

  Future<void> kirimId(int id) async {
    setState(() {
      _isLoading = true;
    });
    String? message = await apiServices.konfirmasi(id, context);
    if (message != null) {
      _isLoading = false;
      alertWidget.SuccessAlert(context, message, "Berhasil", MainMenu(selectedIndex: 2));
    } else {
      _isLoading = false;
      alertWidget.ErrorAlert(context, "Maaf, Gagal Mengirim Data!", "Terjadi Kesalahan!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalete.merah,
        appBar: AppBar(
          backgroundColor: ColorPalete.merah,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Tambahkan logika untuk tombol pengaturan
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Bagian atas dengan logo
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/img/logo-hanachik.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Konten utama
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Detail Pemesan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Nama Pemesan
                      Text(
                        "Nama Pemesan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.nama_pemesan,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Kategori Pesanan
                      Text(
                        "Kategori Pesanan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.kategori,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Menu Pesanan
                      Text(
                        "Menu Pesanan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.itemPesanan),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Tombol Konfirmasi
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _isLoading ? null : kirimId(widget.idOrder);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalete.merah,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          :Text(
                            "KONFIRMASI",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Informasi tambahan
                      Center(
                        child: Text(
                          "# Pembayaran dilakukan pada Kasir",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
