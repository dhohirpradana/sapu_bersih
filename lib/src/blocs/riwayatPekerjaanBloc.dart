import 'package:rxdart/subjects.dart';
import 'package:sapubersih/src/models/riwayatPekerjaanModel.dart';
import 'package:sapubersih/src/resources/repository.dart';

class RiwayatPekerjaanBloc {
  final _repository = Repository();
  final _riwayatPekerjaanFetcher = PublishSubject<List<RiwayatPekerjaan>>();

  Stream<List<RiwayatPekerjaan>> get allRiwayatPekerjaan =>
      _riwayatPekerjaanFetcher.stream;
  fetchAllRiwayatPekerjaan() async {
    List<RiwayatPekerjaan> riwayatPekerjaan =
        await _repository.fetchAllRiwayatPekerjaan();
    _riwayatPekerjaanFetcher.sink.add(riwayatPekerjaan);
  }

  dispose() {
    _riwayatPekerjaanFetcher.close();
  }
}
final blocRiwayatPekerjaan = RiwayatPekerjaanBloc();
