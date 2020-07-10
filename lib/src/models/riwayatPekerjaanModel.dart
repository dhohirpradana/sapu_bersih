// To parse this JSON data, do
//
//     final riwayatPekerjaan = riwayatPekerjaanFromJson(jsonString);

import 'dart:convert';

List<RiwayatPekerjaan> riwayatPekerjaanFromJson(String str) =>
    List<RiwayatPekerjaan>.from(
        json.decode(str).map((x) => RiwayatPekerjaan.fromJson(x)));

String riwayatPekerjaanToJson(List<RiwayatPekerjaan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RiwayatPekerjaan {
  RiwayatPekerjaan({
    this.value,
    this.data,
    this.message,
  });

  final int value;
  final List<Datum> data;
  final String message;

  factory RiwayatPekerjaan.fromJson(Map<String, dynamic> json) =>
      RiwayatPekerjaan(
        value: json["value"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    this.id,
    this.image,
    this.latitude,
    this.longtitude,
    this.time,
    this.lokasi,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String image;
  final String latitude;
  final String longtitude;
  final DateTime time;
  final String lokasi;
  final int status;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        image: json["image"],
        latitude: json["latitude"],
        longtitude: json["longtitude"],
        time: DateTime.parse(json["time"]),
        lokasi: json["lokasi"],
        status: json["status"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "latitude": latitude,
        "longtitude": longtitude,
        "time": time.toIso8601String(),
        "lokasi": lokasi,
        "status": status,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

// import 'dart:convert';

// // List<RiwayatPekerjaan> riwayatPekerjaanFromJson(String str) {
// // final jsonData = jsonDecode(str);
// // return new List<RiwayatPekerjaan>.from(jsonData.map(x)=>Data.fromJson(x));
// // }

// class RiwayatPekerjaan {
//   final int value;
//   final List<Data> data;
//   final String message;

//   RiwayatPekerjaan({this.value, this.data, this.message});
//   RiwayatPekerjaan riwayatPekerjaanFromJson(String str) =>
//       RiwayatPekerjaan.fromJson(json.decode(str));

//   factory RiwayatPekerjaan.fromJson(Map<String, dynamic> json) {
//     return RiwayatPekerjaan(
//         value: json['value'], message: json['message'], data: parseData(json));
//   }

//   static List<Data> parseData(dataJson) {
//     var list = dataJson['data'] as List;
//     List<Data> dataList = list.map((data) => Data.fromJson(data)).toList();
//     return dataList;
//   }
// }

// class Data {
//   int id;
//   String image;
//   String latitude;
//   String longtitude;
//   DateTime time;
//   String lokasi;
//   int status;
//   int userId;
//   DateTime createdAt;
//   DateTime updatedAt;

//   Data({
//     this.id,
//     this.image,
//     this.latitude,
//     this.longtitude,
//     this.time,
//     this.lokasi,
//     this.status,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Data.fromJson(Map<String, dynamic> parsedJson) {
//     return Data(
//         id: parsedJson["id"],
//         image: parsedJson["image"],
//         latitude: parsedJson["latitude"],
//         longtitude: parsedJson["longtitude"],
//         time: DateTime.parse(parsedJson["time"]),
//         lokasi: parsedJson["lokasi"],
//         status: parsedJson["status"],
//         userId: parsedJson["user_id"],
//         createdAt: DateTime.parse(parsedJson["created_at"]),
//         updatedAt: DateTime.parse(parsedJson["updated_at"]));
//   }
// }
