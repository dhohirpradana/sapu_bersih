import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapubersih/api/api.dart';

import '../login_page.dart';

class PerekamanLemburPage extends StatefulWidget {
  @override
  _PerekamanPageState createState() => _PerekamanPageState();
}

class _PerekamanPageState extends State<PerekamanLemburPage> {
  @override
  void initState() {
    super.initState();
    lokasiku_throughfare = "Mendapatkan Lokasi...";
    getUserLocation();
    getPref();
  }

  int id;
  String token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt("id");
      token = preferences.getString("token");
    });
    print("$id, $token");
  }

  resetSavePref(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
    });
  }

  uploadData() async {
    String base64Image = base64Encode(_imageFile.readAsBytesSync());
    var response = await http.post(Uri.encodeFull(BaseUrl.rekamlembur), body: {
      'image': base64Image,
      'latitude': '100',
      'longtitude': '200',
      'lokasi': 'kudus'
    }, headers: {
      HttpHeaders.authorizationHeader: "bearer $token",
      'Content-Type': 'multipart/form-data'
    });
    // final data = jsonDecode(response.body);
    print(response.body);
    setState(() {});
  }

  File _imageFile;
  List<File> _imageList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "PRESENSI LEMBUR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.assignment),
          ],
        ),
        backgroundColor: Color(0xff037171),
      ),
      body: isLoading == 1
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: <Widget>[
                Container(color: Colors.transparent, child: _formInputan()),
                Container(
                  height: MediaQuery.of(context).size.height / 4.7,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          // UploadData();
                          _uploadImage();
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
                                SizedBox(
                                  width: 9,
                                ),
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      gmaps(),
                      // Container(
                      //   height: MediaQuery.of(context).size.height / 8,
                      //   color: Colors.blue,
                      // ),
                      // Expanded(),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Container(),
                // ),
              ],
            ),
    );
  }

  final _key = new GlobalKey<FormState>();

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
    //call this async method from whereever you need

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
    var currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
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
      isLoading = 0;
    });
    return first;
  }

  Set<Marker> markers = Set();

  Widget gmaps() {
    markers.addAll([
      Marker(markerId: MarkerId('Lokasiku'), position: LatLng(mylat, mylon)),
    ]);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM').format(now).toUpperCase();
    return Container(
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
                    // Text(
                    //     "$lokasiku_sublokal, $lokasiku_locality, $lokasiku_subadmin"),
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
                    Text(
                      formattedDate,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 27),
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

  Widget _formInputan() {
    return Form(
        key: _key,
        child: Column(children: <Widget>[
          _dataUploadFoto(),
        ]));
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pilih sebuah gambar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Kamera'),
                  onPressed: () {
                    // _getImage(context, ImageSource.camera);
                    getImageCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

  File _image1;

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
      _imageList.add(_imageFile);
    });
  }

  Future<Null> _uploadImage() async {
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
                new Text("Mengunggah Absensi..."),
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
            http.MultipartRequest('POST', Uri.parse(BaseUrl.rekamlembur));
        // Attach the file in the request
        Timer(Duration(seconds: 1), () async {
          final file = await http.MultipartFile.fromPath('image', f.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
          imageUploadRequest.headers['authorization'] = 'bearer $token';
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
              print(value);
              if (value == 2) {
                setState(() {
                  _imageList.clear();
                });
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

              // Fluttertoast.showToast(
              //     msg: "SISTEM SEDANG MAIN TENIS",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIos: 1,
              //     backgroundColor: Colors.red.withOpacity(0.9),
              //     textColor: Colors.white,
              //     fontSize: 16.0);
              // Navigator.pop(context);
              final Map<String, dynamic> responseData =
                  json.decode(response.body);
              _resetState();
              return responseData;
            } else {
              setState(() {
                resetSavePref(0);
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPageKu()));
            }
          } catch (e) {
            print(e);
            return null;
          }
        });
      });
    } else {
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

  void _resetState() {
    setState(() {
      _imageFile = null;
    });
  }

  Future getImageCamera() async {
    Random rand = new Random();
    int random = rand.nextInt(1000000) + 1000;

    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    final title = random.toString();

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 1000);

    var compressImage = await File("$path/FromCamera_$title.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 95));
    _image1 = compressImage;
    setState(() {
      _imageList.add(_image1);
    });
  }

  simpan() async {
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
                new Text("Menyimpan data pengajuan"),
              ],
            ),
          ),
        );
      },
    );
  }

  // DateTime now = DateTime.now();
  // String formattedDate = DateFormat('kkmmssEEEdMMM').format(now);

  Widget _dataUploadFoto() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 0.0, right: 0.0),
                          child: _imageList.length > 0
                              ? Stack(
                                  children: <Widget>[
                                    Image.file(
                                      _imageList[0],
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context)
                                              .size
                                              .height -
                                          MediaQuery.of(context).size.height /
                                              3,
                                      // alignment: Alignment.topCenter,
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.delete_forever,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                13,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _imageList.removeAt(0);
                                          });
                                        })
                                  ],
                                )
                              : OutlineButton(
                                onPressed: (){},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.09,
                                    height: MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).size.height / 3,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                5,
                                      ),
                                      onPressed: () => _getImage(
                                          context, ImageSource.camera),
                                    ),
                                  ),
                                )),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
