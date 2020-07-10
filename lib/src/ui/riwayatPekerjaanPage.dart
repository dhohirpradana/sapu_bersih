import 'package:flutter/material.dart';
import 'package:sapubersih/src/blocs/riwayatPekerjaanBloc.dart';
import 'package:sapubersih/src/models/riwayatPekerjaanModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewRiwayatPekerjaanPage extends StatefulWidget {
  @override
  _NewRiwayatPekerjaanPageState createState() =>
      _NewRiwayatPekerjaanPageState();
}

class _NewRiwayatPekerjaanPageState extends State<NewRiwayatPekerjaanPage> {
  @override
  void initState() {
    blocRiwayatPekerjaan.fetchAllRiwayatPekerjaan();
    super.initState();
  }

  @override
  void dispose() {
    blocRiwayatPekerjaan.dispose();
    super.dispose();
  }

  String token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
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
                "RIWAYAT PEKERJAAN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.directions_run),
            ],
          ),
          backgroundColor: Color(0xff037171),
        ),
        body: StreamBuilder(
          stream: blocRiwayatPekerjaan.allRiwayatPekerjaan,
          builder: (context, AsyncSnapshot<List<RiwayatPekerjaan>> snapshot) {
            debugPrint(snapshot.data.toString());
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget buildList(AsyncSnapshot<List<RiwayatPekerjaan>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(snapshot.data[index].data[0].lokasi.toString()),
          );
        });
  }
}
