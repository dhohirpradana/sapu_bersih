import 'package:flutter/material.dart';
import './View/ChatListPageView.dart';
import './Global/Colors.dart' as myColors;

void main() => runApp(MainChat());

class MainChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myColors.blue,
      ),
      home: ChatListPageView(),
    );
  }
}
