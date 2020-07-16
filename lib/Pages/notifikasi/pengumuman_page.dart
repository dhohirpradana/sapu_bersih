import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sapubersih/Pages/chat/chat_page.dart';
import 'package:sapubersih/api/api.dart';
import 'package:http/http.dart' as http;

class PengumumanPage extends StatefulWidget {
  final title, body;

  const PengumumanPage({Key key, this.title, this.body}) : super(key: key);
  @override
  _PengumumanPageState createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final ScrollController _scrollController = ScrollController();

  String title = "";
  String content = "";
  String smallIcon;
  @override
  void initState() {
    super.initState();
    fetchAnnouncementData();
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      setState(() {
        title = notification.payload.title;
        content = notification.payload.body;
        smallIcon = notification.payload.smallIcon;
      });
      if (smallIcon == "chat") {
        OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);
      } else {
        OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);
        fetchAnnouncementData();
      }
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      (smallIcon != "chat")
          ? () {}
          : Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => ChatChild(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 100),
              ),
            );
    });
  }

  int isLoading = 1;
  int length;
  Map<String, dynamic> announcementData;
  Future<void> fetchAnnouncementData() async {
    final response = await http.get(BaseUrl.announcement);
    if (response.statusCode != 200) {
      print(response.statusCode);
      Navigator.pop(context);
    } else {
      setState(() {
        announcementData = json.decode(response.body);
        length = announcementData["data"]["data"].length;
        isLoading = 0;
      });
    }
  }

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
              "PENGUMUMAN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.info),
          ],
        ),
        backgroundColor: Color(0xff037171),
      ),
      body: (isLoading == 1)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Material(
              child: (length < 1)
                  ? Center(
                      child: Text(
                        "Belum Ada Data",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 23,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    )
                  : Scrollbar(
                      isAlwaysShown: false,
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: length,
                        itemBuilder: (BuildContext context, int index) {
                          final waktu = announcementData["data"]["data"][index]
                                  ["updated_at"]
                              .toString();
                          final tahun = waktu.substring(0, 4);
                          final bulan = waktu.substring(5, 7);
                          final tanggal = waktu.substring(8, 10);
                          final jam = waktu.substring(11, 16);
                          final namab = (bulan == "01")
                              ? "Januari"
                              : (bulan == "02")
                                  ? "Februari"
                                  : (bulan == "03")
                                      ? "Maret"
                                      : (bulan == "04")
                                          ? "April"
                                          : (bulan == "05")
                                              ? "Mei"
                                              : (bulan == "06")
                                                  ? "Juni"
                                                  : (bulan == "07")
                                                      ? "Juli"
                                                      : (bulan == "08")
                                                          ? "Agustus"
                                                          : (bulan == "09")
                                                              ? "September"
                                                              : (bulan == "10")
                                                                  ? "Oktober"
                                                                  : (bulan ==
                                                                          "11")
                                                                      ? "November"
                                                                      : "Dessember";

                          final title = announcementData["data"]["data"][index]
                                  ["title"]
                              .toString();
                          final body = announcementData["data"]["data"][index]
                                  ["text"]
                              .toString();
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 3),
                                        child: Text(
                                          "$tanggal $namab $tahun, $jam",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  29),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.only(
                                      top: 1, bottom: 10, right: 3, left: 3),
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  elevation: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  29),
                                        ),
                                        Container(
                                            child: Divider(
                                                color: Colors.blueGrey)),
                                        Text(
                                          body,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  23),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}
