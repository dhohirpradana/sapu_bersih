import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:sapubersih/Pages/notifikasi/pengumuman_page.dart';
import 'package:sapubersih/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatChild extends StatefulWidget {
  @override
  _ChatChildState createState() => _ChatChildState();
}

class _ChatChildState extends State<ChatChild> {
  String token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    fetchMessageData();
  }

  Future<void> sendMessage() async {
    if (msg == null) {
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: Dialog(
              child: SizedBox(),
            ),
          );
        },
      );

      final response = await http.post(
        BaseUrl.chat,
        body: {"message": msg.toString()},
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        _controller.clear();
        focusNode.unfocus();
        setState(() {
          _messageList.add(MessageWidget(
            content: msg.toString(),
            ownerType: OwnerType.receiver,
            ownerName: "Saya",
          ));
        });
      } else {
        Navigator.pop(context);
        setState(() {});
        print(response.statusCode);
      }
    }
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
      print(response.statusCode);
      Navigator.pop(context);
    } else {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      Future.delayed(Duration(seconds: 0), () {
        if (extractedData["data"].length < 1) {
          setState(() {
            isLoading = 0;
          });
        } else {
          for (var i = 0; i < extractedData["data"].length; i++) {
            _messageList.add(MessageWidget(
              content: extractedData["data"][i]["text"],
              ownerType: (extractedData["data"][i]["admin_id"] != null)
                  ? OwnerType.sender
                  : OwnerType.receiver,
              ownerName: (extractedData["data"][i]["admin_id"] != null)
                  ? "Admin"
                  : "Saya",
            ));
            setState(() {
              isLoading = 0;
            });
          }
        }
      });
    }
  }

  String msg;
  var _controller = TextEditingController();
  final focusNode = FocusNode();

  final List<MessageWidget> _messageList = [];

  int isLoading;
  @override
  void initState() {
    super.initState();
    getPref();
    isLoading = 1;
  }

  @override
  void dispose() {
    super.dispose();
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
                "INFORMASI",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.message),
            ],
          ),
          backgroundColor: Color(0xff037171),
        ),
        body: Stack(
          children: <Widget>[
            (isLoading == 1)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 9,
                        top: 19),
                    child: ChatList(children: _messageList)),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 2),
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: _controller,
                    onSaved: (e) => msg = e,
                    onChanged: (e) {
                      msg = e;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          highlightColor: Colors.blue.withOpacity(0.1),
                          icon: Icon(
                            Icons.send,
                            color: Color(0xff037171),
                            size: 30,
                          ),
                          onPressed: () {
                            if (msg == null) {
                              () {};
                            } else {
                              sendMessage();
                            }
                          },
                        ),
                        hintText: "Tulis pesan",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                        labelText: ''),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => PengumumanPage(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Center(
                    child: Material(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      elevation: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "LIHAT PENGUMUMAN ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff037171)),
                            ),
                            Icon(
                              Icons.info_outline,
                              color: Color(0xff037171),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
