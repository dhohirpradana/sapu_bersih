import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sapubersih/Pages/boot/boot_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.shared
      .init("26d64a69-c6e6-4347-908c-61006bd62c35", iOSSettings: null);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    OneSignal.shared.setExternalUserId(token);
    checkCameraPermissions();
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      print('notif masuk');
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("di Tap");
    });
  }

  static Future<bool> checkCameraPermissions() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isUndetermined || status.isDenied) {
      print('cam is denied or undetermined'); //Prints
      PermissionStatus newStatus = await Permission.camera.request();
      print(await Permission.camera.isDenied); //Prints 'true' immediately
      if (newStatus.isDenied) return false;
      print('cam is approved!'); //Nope QQ
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
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
