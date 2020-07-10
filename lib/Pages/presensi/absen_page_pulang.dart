import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AbsenPulangPage extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<AbsenPulangPage> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  String lokasiku_locality,
      lokasiku_admin_area,
      lokasiku_sublokal,
      lokasiku_subadmin,
      lokasiku_addressline = "",
      lokasiku_featurename,
      lokasiku_throughfare = "Mendapatkan Lokasi...",
      lokasiku_subthroughfare = "";
  int isLoading = 1;

  double mylat, mylon;
  getUserLocation() async {
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
        // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
        // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
      myLocation = null;
    }

    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      lokasiku_locality = ' ${first.locality}';
      lokasiku_admin_area = '${first.adminArea}';
      lokasiku_sublokal = '${first.subLocality}';
      lokasiku_subadmin = '${first.subAdminArea}';
      lokasiku_addressline = '${first.addressLine}';
      lokasiku_featurename = '${first.featureName}';
      lokasiku_throughfare = '${first.thoroughfare}';
      lokasiku_subthroughfare = '${first.subThoroughfare}';
      mylat = myLocation.latitude;
      mylon = myLocation.longitude;
    });
    return first;
  }

  @override
  void initState() {
    super.initState();
    getUserLocation();
    // 1
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 1;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {
          isLoading = 0;
        });
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  void onCapturePressed(context) async {
    try {
      // 1
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      // 2
      await controller.takePicture(path);
      imageFile = File(path);
    } catch (e) {
      print(e);
    }
  }

  File imageFile;

  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    Widget gmaps() {
      markers.addAll([
        Marker(markerId: MarkerId('Lokasiku'), position: LatLng(mylat, mylon)),
      ]);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('d').format(now).toUpperCase();
      String formattedMonth = DateFormat('MMM').format(now).toUpperCase();
      String bln;
      if (formattedMonth == "JAN") {
        bln = "JANUARI";
      } else if (formattedMonth == "FEB") {
        bln = "FEBRUARI";
      } else if (formattedMonth == "MAR") {
        bln = "MARET";
      } else if (formattedMonth == "APR") {
        bln = "APRIL";
      } else if (formattedMonth == "MAY") {
        bln = "MEI";
      } else if (formattedMonth == "JUN") {
        bln = "JUNI";
      } else if (formattedMonth == "JUL") {
        bln = "JULI";
      } else if (formattedMonth == "AUG") {
        bln = "AGUSTUS";
      } else if (formattedMonth == "SEP") {
        bln = "SEPTEMBER";
      } else if (formattedMonth == "OKT") {
        bln = "OKTOBER";
      } else if (formattedMonth == "NOV") {
        bln = "NOVEMBER";
      } else {
        bln = "DESEMBER";
      }
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    child: GoogleMap(
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(mylat, mylon),
                        zoom: 16.0,
                      ),
                      markers: markers,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$lokasiku_sublokal".toUpperCase(),
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "$lokasiku_addressline",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 29,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            formattedDate,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 27),
                          ),
                          Text(" "),
                          Text(
                            bln,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 27),
                          ),
                          Text(" "),
                          Text(
                            now.year.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 27),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _cameraPreviewWidget(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 17,
                  width: (MediaQuery.of(context).size.width),
                  color: Color(0xff037171),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "KIRIM",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 21,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                gmaps()
              ],
            )
          ],
        ),
      ),
    );
  }
}
