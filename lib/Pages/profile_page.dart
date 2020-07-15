import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapubersih/Pages/login_page.dart';
import 'package:sapubersih/api/api.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getPref();
  }

  int id;
  String token;
  String no_thl,
      nama,
      tmt_pengangkatan_pertama,
      tempat_lahir,
      tanggal_lahir,
      tingkat_pendidikan_terakhir,
      jurusan_pendidikan_terakhir,
      jabatan,
      status_tenaga,
      unit_kerja,
      tahun,
      bulan,
      tanggal,
      namab,
      tahun1,
      bulan1,
      tanggal1,
      namab1;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("id");
      token = preferences.getString("token");
    });
    getProfile();
  }

  resetSavePref(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
    });
  }

  int isLoading = 1;
  getProfile() async {
    var response = await http.get(Uri.encodeFull(BaseUrl.profile), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      'Content-Type': 'application-json'
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        no_thl = data['no_thl'];
        nama = data['name'];
        tmt_pengangkatan_pertama = data['tmt_pengangkatan_pertama'];
        tempat_lahir = data['tempat_lahir'];
        tanggal_lahir = data['tanggal_lahir'];
        tingkat_pendidikan_terakhir = data['tingkat_pendidikan_terakhir'];
        jurusan_pendidikan_terakhir = data['jurusan_pendidikan_terakhir'];
        jabatan = data['jabatan'];
        status_tenaga = data['status_tenaga'];
        unit_kerja = data['unit_kerja'];
        isLoading = 0;

        if (tanggal_lahir != null) {
          tahun = tanggal_lahir.substring(0, 4);
          bulan = tanggal_lahir.substring(5, 7);
          tanggal = tanggal_lahir.substring(8, 10);
        } else {
          tahun = " ";
          bulan = " ";
          tanggal = " ";
        }

        if (tmt_pengangkatan_pertama != null) {
          tahun1 = tmt_pengangkatan_pertama.substring(0, 4);
          bulan1 = tmt_pengangkatan_pertama.substring(5, 7);
          tanggal1 = tmt_pengangkatan_pertama.substring(8, 10);
        } else {
          tahun1 = " ";
          bulan1 = " ";
          tanggal1 = " ";
        }

        namab = (bulan == "01")
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
                                                : (bulan == "11")
                                                    ? "November"
                                                    : (bulan == "11")
                                                        ? "Desember"
                                                        : " ";
        namab1 = (bulan1 == "01")
            ? "Januari"
            : (bulan1 == "02")
                ? "Februari"
                : (bulan1 == "03")
                    ? "Maret"
                    : (bulan1 == "04")
                        ? "April"
                        : (bulan1 == "05")
                            ? "Mei"
                            : (bulan1 == "06")
                                ? "Juni"
                                : (bulan1 == "07")
                                    ? "Juli"
                                    : (bulan1 == "08")
                                        ? "Agustus"
                                        : (bulan1 == "09")
                                            ? "September"
                                            : (bulan1 == "10")
                                                ? "Oktober"
                                                : (bulan1 == "11")
                                                    ? "November"
                                                    : (bulan1 == "11")
                                                        ? "Desember"
                                                        : " ";
      });
    } else {
      setState(() {
        resetSavePref(0);
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPageKu()),
        ModalRoute.withName("/LoginPage"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "PROFIL PENGGUNA",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.person),
            ],
          ),
          backgroundColor: Color(0xff037171),
        ),
        body: (isLoading == 0)
            ? body()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget body() {
    return Material(
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 9.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("NAMA"),
            Row(
              children: <Widget>[
                Text(
                  nama.toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("NO THL"),
            Row(
              children: <Widget>[
                Text(
                  no_thl,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("TANGGAL PENGANGKATAN"),
            Row(
              children: <Widget>[
                Text(
                  "$tanggal1 $namab1 $tahun1".toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("TEMPAT/ TANGGAL LAHIR"),
            Row(
              children: <Widget>[
                Text(
                  "$tempat_lahir $tanggal $namab $tahun".toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("TINGKAT PENDIDIKAN TERAKHIR"),
            Row(
              children: <Widget>[
                Text(
                  tingkat_pendidikan_terakhir.toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("JURUSAN PENDIDIKAN TERAKHIR"),
            Row(
              children: <Widget>[
                Text(
                  jurusan_pendidikan_terakhir.toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("JABATAN"),
            Row(
              children: <Widget>[
                Text(
                  jabatan.toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("STATUS"),
            Row(
              children: <Widget>[
                Text(
                  status_tenaga.toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
            Text("UNIT KERJA"),
            Row(
              children: <Widget>[
                Text(
                  unit_kerja.toUpperCase(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 1, bottom: 3),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.lightBlue, width: 2.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
