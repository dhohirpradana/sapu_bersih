import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sapubersih/Pages/boot/boot_screen.dart';
import 'package:sapubersih/Pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginPageKu(),
      routes: {
        "/": (context) => BootScreen(),
      },
    );
  }
}
