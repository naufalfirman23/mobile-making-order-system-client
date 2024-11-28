import 'package:flutter/material.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/pages/menu/detail_produk.dart';

import '../../const/cApiServices.dart';

class CamilanPage extends StatefulWidget {
  final int? id_category;
  CamilanPage({required this.id_category});
  @override
  _CamilanPageState createState() => _CamilanPageState();
}

class _CamilanPageState extends State<CamilanPage> {
  final ApiServices apiServices = ApiServices();
  late Future<List<Produk>> produkList;
  @override
  void initState() {
    super.initState();
    produkList = apiServices.fetchProdukByCategory(
        widget.id_category!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: ColorPalete.utama,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: ColorPalete.utama,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/img/logo-hanachik.png'), 
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Camilan",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Mau Camilan ..... ? Disini Banyak Pilihan!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: FutureBuilder<List<Produk>>(
              future: produkList,
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

                List<Produk> produk = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: produk.length,
                    itemBuilder: (context, index) {
                      return camilanCard(produk[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget camilanCard(Produk produk) {
    int hargaInt = double.parse(produk.harga).toInt();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFoodPage(foodName: produk.nama, imagePath: produk.gambar, harga: hargaInt, produkId: produk.id,),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.network(
                produk.gambar,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              produk.nama,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
