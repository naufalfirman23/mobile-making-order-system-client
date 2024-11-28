import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/const/cfont.dart';
import 'package:mobile/pages/splash.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData(
      fontFamily: FontType.interReg,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
    ),
    initialRoute: '/',
  ));
}

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return SplashScreen();
  }
}
