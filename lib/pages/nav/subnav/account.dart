import 'package:flutter/material.dart';
import 'package:mobile/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatelessWidget {

  // Fungsi logout
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // Menghapus token yang disimpan
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Keluar Akun',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 226, 35, 35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                child: TextButton(
                  onPressed: () {
                    _logout(context); 
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Keluar Akun',
                      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
