
import 'package:flutter/material.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/const/cfont.dart';
import 'package:mobile/core.dart';

import '../../const/chelper.dart';

class DetailFoodPage extends StatefulWidget {
  final String foodName;
  final String imagePath;
  final int harga;
  final int produkId;
  DetailFoodPage({required this.produkId, required this.foodName, required this.imagePath, required this.harga});
  @override
  _DetailFoodPageState createState() => _DetailFoodPageState();
}

class _DetailFoodPageState extends State<DetailFoodPage> {
  final List<Map<String, String>> reviews = [
    {
      "name": "John Doe",
      "review": "Makanannya sangat enak! Akan pesan lagi.",
      "date": "20 Nov 2024",
    },
    {
      "name": "Jane Smith",
      "review": "Ayam gepreknya pedas dan lezat!",
      "date": "19 Nov 2024",
    },
    {
      "name": "Robert Brown",
      "review": "Harga terjangkau, kualitas luar biasa.",
      "date": "18 Nov 2024",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalete.merah,
      appBar: AppBar(
        title: Text(
          "Detail Produk",
          style: TextStyle(
            fontFamily: FontType.interSemiBold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              // Tambahkan logika untuk tombol pengaturan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian gambar
            Container(
              decoration: BoxDecoration(
                color: ColorPalete.utama,
              ),
              child: ClipRRect(
                child: Image.network(
                  widget.imagePath, 
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            Transform.translate(
              offset: Offset(0, -20), 
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: ColorPalete.merah,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.foodName,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: FontType.interBold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: List.generate(3, (index) {
                            return Icon(Icons.star, color: Colors.white);
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      Helper().formatRupiah(widget.harga as int),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => OrderPage(foodName: widget.foodName, priceProduk: widget.harga, id_produk: widget.produkId,),
                          ),
                        );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Pesan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // List Ulasan
                    Text(
                      "Ulasan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: reviews.map((review) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    review['date']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                review['review']!,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
