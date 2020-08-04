import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as loc;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sapubersih/Pages/boot/boot_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/chat/chat_page.dart';
import 'Pages/notifikasi/pengumuman_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.shared
      .init("26d64a69-c6e6-4347-908c-61006bd62c35", iOSSettings: null);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String title = "";
  String content = "";
  String smallIcon;
  @override
  void initState() {
    super.initState();
    getLoc();
    _checkForCameraPermission();
    getPref();
  }

  loc.Location location = loc.Location();
  bool _serviceEnabled;

  getLoc() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        SystemNavigator.pop();
      }
    }
  }

  int id;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("uid");
    });
    oneSignal();
  }

  oneSignal() {
    if (id != null) {
      OneSignal.shared
          .setNotificationReceivedHandler((OSNotification notification) {
        OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);
        setState(() {
          title = notification.payload.title;
          content = notification.payload.body;
          smallIcon = notification.payload.smallIcon;
        });
      });

      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        if (title == "pesan dari admin") {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ChatChild(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 100),
            ),
          );
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => PengumumanPage(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 100),
            ),
          );
        }
      });
    } else {}
  }

  _checkForCameraPermission() async {
    var cameraPermission = await Permission.camera.status;
    print("camera permissions is $cameraPermission");
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus == PermissionStatus.granted) {
      // navigate to Xyz screen.

    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jepara Bersih',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: LoginPageKu(),
      routes: {
        "/": (context) => BootScreen(),
      },
    );
  }
}
