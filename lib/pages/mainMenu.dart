import 'package:flutter/material.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/pages/nav/home.dart';
import 'package:mobile/pages/nav/info_pesanan.dart';
import 'package:mobile/pages/nav/riwayat.dart';

class MainMenu extends StatefulWidget {
  final int selectedIndex;
  MainMenu({this.selectedIndex = 1});
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int myIndex = 1;
  List<Widget> widgetList = [InfoPesananPage(), HomePage(), RiwayatPage()];
  List<String> title = ["Pesanan", "", "Riwayat"];
  @override
  void initState() {
    super.initState();
    myIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0),
        child: AppBar(
          title: Text(title[myIndex]),
          automaticallyImplyLeading: false,
          backgroundColor: ColorPalete.utama,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.propane_outlined), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: 'Riwayat'),
        ],
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: ColorPalete.utama,
        unselectedItemColor: Colors.black,
      ),
      body: widgetList[myIndex],
    );
  }
}
