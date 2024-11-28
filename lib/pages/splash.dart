import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/const/ccolor.dart';
import 'package:mobile/const/cfont.dart';
import 'package:mobile/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _counter = 5; // Set waktu hitungan mundur

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Timer untuk hitungan mundur
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_counter == 1) {
        timer.cancel();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: ColorPalete.utama,
    body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo-hanachik.png',
                width: 300,
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 20, 
          left: 50,
          right: 50,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.black.withOpacity(0.1), 
            ),
            child: Text(
              "Hana Chicks Mobile App Version",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontType.interMedium,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
