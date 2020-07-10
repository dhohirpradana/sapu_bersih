import 'package:sapubersih/src/models/riwayatPekerjaanModel.dart';
import 'package:sapubersih/src/resources/sapuBersihApiProvider.dart';
import 'dart:async';

class Repository {
  final sapuBersihApiProvider = SapuBersihApiProvider();

  Future<List<RiwayatPekerjaan>> fetchAllRiwayatPekerjaan() =>
      sapuBersihApiProvider.fetchRiwayatPekerjaanList();
}
