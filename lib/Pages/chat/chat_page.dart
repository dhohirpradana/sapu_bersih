import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:sapubersih/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatList Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatChild(),
    );
  }
}

class ChatChild extends StatefulWidget {
  @override
  _ChatChildState createState() => _ChatChildState();
}

class _ChatChildState extends State<ChatChild> {
  String name, token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
      token = preferences.getString("token");
    });
  }

  Future<void> fetchMessageData() async {
    final response = await http.get(
      BaseUrl.chat,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        "Content-Type": "Application/json"
      },
    );
    if (response.statusCode != 200) {
      print("Failed ");
      print(token);
      print(response.body);
    } else {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((id, messageData) {
        _messageList.add(MessageWidget(
          content: "halo bos",
          ownerType: OwnerType.sender,
          ownerName: "Saya",
        ));
      });
      print(json.decode(response.body));
    }
  }

  final List<MessageWidget> _messageList = [];

  addList() {
    _messageList.add(MessageWidget(
      content:
          "Assalamualailkum Wr Wb, \nPak hari iki saya ijin dikarenakan bla3x",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Oiya pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content: "Terimakasih pak",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Sama-sama pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content:
          "Assalamualailkum Wr Wb, \nPak hari iki saya ijin dikarenakan bla3x",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Oiya pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content: "Terimakasih pak",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Sama-sama pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content:
          "Assalamualailkum Wr Wb, \nPak hari iki saya ijin dikarenakan bla3x",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Oiya pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content: "Terimakasih pak",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Sama-sama pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content:
          "Assalamualailkum Wr Wb, \nPak hari iki saya ijin dikarenakan bla3x",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Oiya pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
    _messageList.add(MessageWidget(
      content: "Terimakasih pak",
      ownerType: OwnerType.receiver,
      ownerName: "Saya",
    ));
    _messageList.add(MessageWidget(
      content: "Sama-sama pak",
      ownerType: OwnerType.sender,
      ownerName: "Admin",
    ));
  }

  @override
  void initState() {
    super.initState();
    getPref();
    fetchMessageData();
    addList();
  }

  int flex1 = 1;
  int flex2 = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "CHATTING",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.message),
            ],
          ),
          backgroundColor: Color(0xff037171),
        ),
        body: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 9),
                child: ChatList(children: _messageList)),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Tulis pesan",
                        suffixIcon: Icon(Icons.send),
                        border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        labelText: ''),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
