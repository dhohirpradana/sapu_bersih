import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sapubersih/Pages/presensi/absen_lembur_page.dart';
import 'package:sapubersih/Pages/presensi/absen_lembur_pulang_page.dart';
import 'package:sapubersih/Pages/presensi/absen_reguler_page.dart';
import 'package:sapubersih/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';
import 'absen_reguler_pulang_page.dart';
import 'package:http/http.dart' as http;

class MainPresensiPage1 extends StatefulWidget {
  @override
  _MainAbsenPageState1 createState() => _MainAbsenPageState1();
}

class _MainAbsenPageState1 extends State<MainPresensiPage1> {
  @override
  void initState() {
    super.initState();
    getPref();
    getCam();
  }

  bool isLoading = true;
  String token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
    getJadwal();
  }

  Map<String, dynamic> jadwal;
  getJadwal() async {
    var response = await http.get(Uri.encodeFull(BaseUrl.jadwal), headers: {
      HttpHeaders.authorizationHeader:
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMGU3NjJiMzE4NzRhOTNkNWYzMWJiNjQwODc4MWVhMzBiMmEwMTZhZGY4YTZjNTlkOWZjZmYyYTFmOTIwOTQ3YmI4YTY0ZWI1MGUxY2I1M2QiLCJpYXQiOjE1OTUyNTA1MjIsIm5iZiI6MTU5NTI1MDUyMiwiZXhwIjoxNjI2Nzg2NTIyLCJzdWIiOiI5Iiwic2NvcGVzIjpbXX0.bT-4cYph2d0dsD3gbErZw04YjJ1xjJ-Yqy2M-bDugUbzW0fLOhvts4bbDQwtERVXjPwIdAcAL4tDLGCCf5LRfgN2zuX6TUT07cojfATLMs6X265oNKnuD3hQNcyDh88y-XXYy6twMucBSdjaRZ_RmpRutTtYupH8zj3LdIeU---Mr2xFSSkEB3tIluy2mBjPZ3XVFGXYgyE5eVVrdNpr2Jh50KY7fb2WsTBI1DE9e809nKk0N3Io4t_sLz3aQPMuQARE2H-eG0_48-QZEi2VEPvE4YAX04zkF73Q4LrYeGQ-kuVZQF2Wt35wHeze7haozReh_lySrk4Oa4NRKiC3bz1Pr17zahX-Iztz047zY-J1WF1tudNY4h6tFVpod5ey5BMLkJ4qmHN8CBjKy7cFLEdBqwteQN5mAvYvovqQ_xMBGPJuaH3mowFs9HjKFV38v-WO2cZj9zJoCjPcaBqGH8ESJwwNj0PSbWXTbIvfeJVJOwmWclySkC8xJ2tr15QzCgJQHmkkTDiMLgjhCH6D032u5-e_OiEGSslfI8A-2nGR2-hjqYEQfLpsDCxcZOU0dbPVSe-uzw3kFMfcEWoB1JbRdSaPhmKYKwREjfIdmKQKYGoYqOy7NiwrBzLIj8LtR9BNx2IPOrqtocT9ZeV5mr4L-P2E-ik8kkZE2uWGBGo",
      'Accept': 'application-json'
    });
    print(response.statusCode);
    if (response.statusCode != 200) {
      Navigator.pop(context);
    } else {
      setState(() {
        jadwal = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  //proses
  getCam() {
    availableCameras().then((availableCameras) {
      if (availableCameras.length > 0) {
      } else {
        print("No camera available");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPageKu()),
          ModalRoute.withName("/Home"),
        );
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
      print("No camera available");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPageKu()),
        ModalRoute.withName("/Home"),
      );
    });
  }

  bool _isVisible = true;
  Color colorToggle = Colors.white;
  String textToogle = "Jadwal hari ini";

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
      (_isVisible)
          ? textToogle = "Jadwal hari ini"
          : textToogle = "Sembunyikan";
      (_isVisible) ? colorToggle = Colors.white : colorToggle = Colors.red[100];
    });
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
              "PRESENSI",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.assignment),
          ],
        ),
        backgroundColor: Color(0xff037171),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blueGrey.withOpacity(0.1),
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            textColor: Colors.black,
            textTheme: ButtonTextTheme.primary,
            elevation: 5,
            color: colorToggle,
            highlightColor: Colors.greenAccent[100],
            child: Text(
              textToogle,
            ),
            onPressed: showToast,
          ),
        ),
        Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(15),
                  elevation: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => AbsenPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    splashColor: Colors.lightBlueAccent,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 6.1,
                      width: MediaQuery.of(context).size.width / 1.5,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "REGULER",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Material(
                  borderRadius: BorderRadius.circular(15),
                  elevation: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => AbsenPulangPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    splashColor: Colors.lightBlueAccent,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 6.1,
                      width: MediaQuery.of(context).size.width / 1.5,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "REGULER PULANG",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Material(
                  borderRadius: BorderRadius.circular(15),
                  elevation: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => PerekamanLemburPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    splashColor: Colors.lightGreenAccent,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 6.1,
                      width: MediaQuery.of(context).size.width / 1.5,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "LEMBUR",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Material(
                  borderRadius: BorderRadius.circular(15),
                  elevation: 10,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => AbsenLemburPulangPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    splashColor: Colors.lightGreenAccent,
                    child: Container(
                      height: MediaQuery.of(context).size.width / 6.1,
                      width: MediaQuery.of(context).size.width / 1.5,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "LEMBUR PULANG",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        (!isLoading)
            ? Visibility(
                visible: !_isVisible,
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(
                              jadwal["data"]["nama_hari"]
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                Column(),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text("BUKA",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text("TUTUP",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)))
                                  ],
                                )
                              ]),
                              TableRow(children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Text("REGULER",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("MULAI",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]["jam_mulai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]["jam_mulai_sampai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                )
                              ]),
                              TableRow(children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Text("REGULER",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("PULANG",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]["jam_selesai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]["jam_selesai_sampai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                )
                              ]),
                              TableRow(children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Text("LEMBUR",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("MULAI",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]["lembur_mulai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]
                                                    ["lembur_mulai_sampai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                )
                              ]),
                              TableRow(children: [
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: <Widget>[
                                            Text("LEMBUR",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text("PULANG",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]["lembur_selesai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(25),
                                        child: Text(
                                            jadwal["data"]
                                                    ["lembur_selesai_sampai"]
                                                .toString()
                                                .substring(0, 5),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ],
                                )
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                replacement: Center(),
              )
            : Center(),
      ],
    );
  }
}
