import 'package:flutter/material.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/pages/menu/camilan.dart';
import 'package:mobile/pages/menu/makanan.dart';
import 'package:mobile/pages/menu/minuman.dart';
import 'package:mobile/pages/nav/subnav/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/cApiServices.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map<String, dynamic>? userData;
  late Future<List<MenuCategory>> categories;
  final ApiServices apiServices = ApiServices();

  Future<void> _fetchUserData() async {
    try {
      final response = await apiServices.getDataUser();
      final data = response?['data'];
      final id_userData = data['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id_userData', id_userData);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan: $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    categories = apiServices.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(context),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  buildInformationSection(),
                  const SizedBox(height: 10.0),
                  buildMenuSection(),
                  const SizedBox(height: 20.0),
                  buildPaymentSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Widget
  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      color: ColorPalete.utama,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30.0),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AccountPage()));
                  },
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40.0, color: ColorPalete.utama),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang,",
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  isLoading
                      ? const Text(
                          'Memuat...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          '${userData?['name'] ?? 'Tidak tersedia'}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          // Kolom pencarian
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari Kategori",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Informasi Untuk Kamu",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 0.5, color: Colors.grey),
        const SizedBox(height: 10.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset(
            'assets/img/fried_chicken.jpg',
            height: 150.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(thickness: 0.5, color: Colors.grey),
        const Text(
          "Menu",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 0.5, color: Colors.grey),
        const SizedBox(height: 10.0),
        FutureBuilder<List<MenuCategory>>(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: snapshot.data!.map((category) {
                  return menuCategory(category.nama, Icons.category, () {
                    if (category.nama == "Makanan") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MakananPage(id_category: category.id)));
                    } else if (category.nama == "Minuman") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MinumanPage(id_category: category.id)));
                    } else if (category.nama == "Camilan") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CamilanPage(id_category: category.id)));
                    }
                  });
                }).toList(),
              );
            } else {
              return const Text('Tidak ada kategori tersedia.');
            }
          },
        ),
      ],
    );
  }

  Widget buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(thickness: 0.5, color: Colors.grey),
        const Text(
          "Pembayaran",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 0.5, color: Colors.grey),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            paymentIcon("assets/img/payment/dana.png"),
            paymentIcon("assets/img/payment/qris.png"),
            paymentIcon("assets/img/payment/shopee.png"),
            paymentIcon("assets/img/payment/ovo.png"),
          ],
        ),
      ],
    );
  }

  Widget menuCategory(String title, IconData icon, Function onTap) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(40.0),
      splashColor: Colors.orange[200],
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.orange[100],
            child: Icon(icon, color: Colors.orange, size: 30.0),
          ),
          const SizedBox(height: 5.0),
          Text(
            title,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget paymentIcon(String imagePath) {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Colors.grey[200],
      child: ClipRRect(
        child: Image.asset(
          imagePath,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
