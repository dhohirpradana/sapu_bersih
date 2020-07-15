import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sapubersih/Pages/presensi/absen_lembur_page.dart';
import 'package:sapubersih/Pages/presensi/absen_lembur_pulang_page.dart';
import 'package:sapubersih/Pages/presensi/absen_reguler_page.dart';
import '../login_page.dart';
import 'absen_reguler_pulang_page.dart';

class MainPresensiPage1 extends StatefulWidget {
  @override
  _MainAbsenPageState1 createState() => _MainAbsenPageState1();
}

class _MainAbsenPageState1 extends State<MainPresensiPage1> {
  @override
  void initState() {
    super.initState();
    getCam();
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
    return Container(
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
    );
  }
}
