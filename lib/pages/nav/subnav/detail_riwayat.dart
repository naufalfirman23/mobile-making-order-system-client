import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/const/chelper.dart';

class DetailRiwayatPage extends StatefulWidget {
  final String namaProduk;
  final String nomorPesanan;
  final DateTime createAt;
  final int quantity;
  final int totalPrice;
  final int hargaProduk;

  const DetailRiwayatPage({super.key, required this.namaProduk, required this.nomorPesanan, required this.createAt, required this.quantity, required this.totalPrice, required this.hargaProduk});
  @override
  _DetailRiwayatPageState createState() => _DetailRiwayatPageState();
}

class _DetailRiwayatPageState extends State<DetailRiwayatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian Header
          Container(
            decoration: BoxDecoration(
              color: ColorPalete.merah,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NO INVOICE",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  widget.nomorPesanan,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Tanggal",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    DateFormat('dd MM yyyy', 'id_ID').format(widget.createAt),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    "Riwayat Pembayaran",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Bagian Tabel
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Tabel
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "#",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "KETERANGAN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Porsi",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Divider(),

                  // Data Tabel
                  Row(
                    children: [
                      Expanded(
                        child: Text("1"),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(widget.namaProduk),
                      ),
                      Expanded(
                        child: Text(
                          widget.quantity.toString(),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Divider(),

                  // Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("SUBTOTAL"),
                      Text(
                        widget.quantity.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),

                  // Detail Harga
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.namaProduk}                      ${Helper().formatRupiahNonRP(widget.hargaProduk)} x ${widget.quantity} = ${Helper().formatRupiahNonRP(widget.totalPrice)}"),
                    ],
                  ),
                  Divider(),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "INVOICE TOTAL",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Helper().formatRupiah(widget.totalPrice),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tombol Back
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              backgroundColor: ColorPalete.merah,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
