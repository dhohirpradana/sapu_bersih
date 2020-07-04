import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapubersih/Pages/home_page.dart';
import 'package:sapubersih/api/api.dart';
import 'login_assets/background.dart';
import 'package:crypto/crypto.dart' as crypto;

class LoginPageKu extends StatefulWidget {
  @override
  _LoginPageKuState createState() => _LoginPageKuState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageKuState extends State<LoginPageKu> {
  LoginStatus _loginStatus = LoginStatus.signIn;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  check() {
    setState(() {
      validationText = "";
      internetStatusText = "";
    });
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  savePref(int value, int id, String token, String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setInt("id", id);
      preferences.setString("token", token);
      preferences.setString("name", name);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(_loginStatus);
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      preference.setInt("value", null);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  bool _barrierDimissable = false;

  login() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: CircularProgressIndicator()),
                new Text("Tunggu..."),
              ],
            ),
          ),
        );
      },
    );

    final response = await http.post(BaseUrl.login,
        // headers: {'Accept': 'application/json'},
        body: {"no_thl": "$usn", "password": "$pass"});

    final data = jsonDecode(response.body);
    // print(response.body);
    print(response.statusCode);

    Future.delayed(Duration(milliseconds: 0), () async {
      int value = data['value'];
      int id = data['uid'];
      String token = data['token'];
      String name = data['name'];
      print(value);
      if (value == 1) {
        setState(() {
          savePref(value, id, token, name);
          _loginStatus = LoginStatus.signIn;
        });
        Navigator.pop(context);
        validationText = "";
        setState(() {
          validationText = "";
          internetStatusText = "";
        });
      } else if (value == 0) {
        Navigator.pop(context);
        setState(() {
          internetStatusText = "";
          validationText = "No THL atau password salah";
        });
        print("No THL atau password salah");
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Background(),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 7),
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 7,
                      right: MediaQuery.of(context).size.width / 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _title(),
                      _emailPasswordWidget(),
                    ],
                  ),
                ),
              ],
            ));
        break;
      case LoginStatus.signIn:
        // return HomePage(signOut);
        return HalamanUtama(signOut);
        break;
    }
  }

  Widget _validation() {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(validationText,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 25,
                  color: Colors.red,
                  fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  final _key = new GlobalKey<FormState>();
  String id;
  String pass;
  String usn;
  String name;
  String token;
  bool _secure = true;

  String validationText = "";
  String internetStatusText = "";

  final nipController = TextEditingController();
  final passController = TextEditingController();
  final FocusNode _nipFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'S',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff00b9ae),
          ),
          children: [
            TextSpan(
              text: 'APU',
              style: TextStyle(color: Color(0xff037171), fontSize: 30),
            ),
            TextSpan(
              text: ' BERS',
              style: TextStyle(color: Color(0xff00b9ae), fontSize: 30),
            ),
            TextSpan(
              text: 'IH',
              style: TextStyle(color: Color(0xff037171), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _key,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "No THL",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    inputFormatters: [
                      new BlacklistingTextInputFormatter(
                          new RegExp('[\\.|\\,]')),
                    ],
                    keyboardType: TextInputType.number,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "username tidak boleh kosong";
                      }
                    },
                    focusNode: _nipFocus,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _nipFocus, _passFocus);
                    },
                    textInputAction: TextInputAction.next,
                    onSaved: (e) => usn = e,
                    onChanged: (e) {
                      setState(() {
                        validationText = "";
                      });
                    },
                    controller: nipController,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 3.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        fillColor: Colors.white,
                        filled: true))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    enableInteractiveSelection: false,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "password tidak boleh kosong";
                      }
                    },
                    focusNode: _passFocus,
                    onFieldSubmitted: (value) {
                      _passFocus.unfocus();
                      setState(() {
                        validationText = "";
                        internetStatusText = "";
                      });
                    },
                    textInputAction: TextInputAction.done,
                    onSaved: (e) => pass = e,
                    onChanged: (e) {
                      setState(() {
                        validationText = "";
                      });
                    },
                    controller: passController,
                    obscureText: _secure,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          autofocus: false,
                          onPressed: showHide,
                          icon: Icon(_secure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: _secure ? Colors.green : Colors.red[400],
                        ),
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 3.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        fillColor: Colors.white,
                        filled: true))
              ],
            ),
          ),
          _validation(),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff00b9ae), Color(0xff037171)])),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          splashColor: Colors.purple.withOpacity(0.5),
          onTap: () {
            check();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              'MASUK',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  showHide() {
    setState(() {
      _secure = !_secure;
    });
  }
}
