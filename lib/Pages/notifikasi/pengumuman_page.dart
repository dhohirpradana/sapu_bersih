import 'package:flutter/material.dart';

class PengumumanPage extends StatefulWidget {
  final title, body;

  const PengumumanPage({Key key, this.title, this.body}) : super(key: key);
  @override
  _PengumumanPageState createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: (widget.title == null)
          ? Container()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.body,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
    );
  }
}
