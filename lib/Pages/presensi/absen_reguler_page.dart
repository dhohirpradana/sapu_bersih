import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as pathF;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapubersih/api/api.dart';

import '../login_page.dart';

class AbsenPage extends StatefulWidget {
  @override
  _AbsenPage createState() => _AbsenPage();
}

class _AbsenPage extends State<AbsenPage> {
  @override
  void initState() {
    super.initState();
    lokasiku_throughfare = "Mendapatkan Lokasi...";
    getCam();
    getUserLocation();
    getPref();
  }
//Proses//

  getCam() {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          Future.delayed(Duration(milliseconds: 200), () {
            isLoading = 0;
          });
          selectedCameraIdx = 1;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
        Navigator.pop(context);
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
      Navigator.pop(context);
    });
  }

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
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
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

  Set<Marker> markers = Set();

  int id;
  String token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("id");
      token = preferences.getString("token");
    });
  }

  resetSavePref(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
    });
  }

  File imageFile;
  List<File> _imageList = [];

  //CameraOnApp
  //Camera
  void onCapturePressed() async {
    try {
      // 1
      final path = pathF.join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      _imageList.add(File(path));
      // 2
      await controller.takePicture(path);
    } catch (e) {
      print(e);
    }
  }

  signOut() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      preference.setInt("value", null);
    });
  }

  void _resetState() {
    setState(() {
      imageFile = null;
    });
  }

  Future<Null> _uploadImage() async {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
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
                new Text("Mengunggah Presensi Lembur..."),
              ],
            ),
          ),
        );
      },
    );
    if (_imageList.length != 0) {
      _imageList.forEach((f) async {
        // Find the mime type of the selected file by looking at the header bytes of the file
        final mimeTypeData =
            lookupMimeType(f.path, headerBytes: [0xFF, 0xD8]).split('/');
        // Intilize the multipart request
        final imageUploadRequest =
            http.MultipartRequest('POST', Uri.parse(BaseUrl.reguler));
        // Attach the file in the request
        Timer(Duration(seconds: 1), () async {
          final file = await http.MultipartFile.fromPath('image', f.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
          imageUploadRequest.headers['authorization'] = 'Bearer $token';
          imageUploadRequest.headers['content-type'] = 'multipart/form-data';
          imageUploadRequest.fields['ext'] = mimeTypeData[1];
          imageUploadRequest.fields['latitude'] = mylat.toString();
          imageUploadRequest.fields['longtitude'] = mylon.toString();
          imageUploadRequest.fields['lokasi'] = lokasiku_addressline.toString();
          imageUploadRequest.files.add(file);
          try {
            final streamedResponse = await imageUploadRequest.send();
            final response = await http.Response.fromStream(streamedResponse);
            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              int value = data['value'];
              if (value == 2) {
                setState(() {
                  _imageList.clear();
                });

                AudioCache player = AudioCache();
                player.play('anda-sudah-mengisi-presensi1593390220.mp3');

                Fluttertoast.showToast(
                    msg: "ANDA SUDAH MENGISI PRESENSI",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.green.withOpacity(0.9),
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
                Navigator.pop(context);
              } else if (value == 1) {
                setState(() {
                  _imageList.clear();
                });

                AudioCache player = AudioCache();
                player.play('anda-sudah-mengisi-presensi1593390220.mp3');

                Fluttertoast.showToast(
                    msg: "BERHASIL MENGISI PRESENSI",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.blue.withOpacity(0.9),
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
                Navigator.pop(context);
              } else if (value == 0) {
                AudioCache player = AudioCache();
                player.play('bukan-masanya-mengisi-presensi1593389995.mp3');

                Fluttertoast.showToast(
                    msg: "BUKAN MASANYA MENGISI PRESENSI",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red.withOpacity(0.9),
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
              } else {
                AudioCache player = AudioCache();
                player.play('your-turn.mp3');

                Fluttertoast.showToast(
                    msg: "SISTEM SEDANG MAIN TENIS",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red.withOpacity(0.9),
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pop(context);
              }
              final Map<String, dynamic> responseData =
                  json.decode(response.body);
              _resetState();
              return responseData;
            } else {
              setState(() {
                resetSavePref(0);
              });
              signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPageKu()),
                ModalRoute.withName("/LoginPage"),
              );
            }
          } catch (e) {
            print(e);
            return null;
          }
        });
      });
    } else {
      AudioCache player = AudioCache();
      player.play('anda-belum-memasukan-foto1593391851.mp3');

      Fluttertoast.showToast(
          msg: "MASUKAN FOTO",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black.withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
  }

//Builder//

//gmaps

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
                              fontSize: MediaQuery.of(context).size.width / 27),
                        ),
                        Text(" "),
                        Text(
                          bln,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 27),
                        ),
                        Text(" "),
                        Text(
                          now.year.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 27),
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

//Camera
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

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
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
        Navigator.pop(context);
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (_) {
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

//Camera
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading == 1
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Stack(
                children: <Widget>[
                  Transform.scale(
                      scale: controller.value.aspectRatio / deviceRatio,
                      child: _cameraPreviewWidget()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          onCapturePressed();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Kirim Presensi ?"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  FlatButton(
                                    child: Text("Ulangi"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Kirim"),
                                    onPressed: () {
                                      _uploadImage();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
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
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              21,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
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