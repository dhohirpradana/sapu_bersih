import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sapubersih/api/api.dart';

import 'package:http/http.dart' show Client;

import 'model/riwayat_pekerjaan_model.dart';

part 'riwayat_pekerjaan_event.dart';
part 'riwayat_pekerjaan_state.dart';

class RiwayatPekerjaanBloc
    extends Bloc<RiwayatPekerjaanEvent, RiwayatPekerjaanState> {
  RiwayatPekerjaanBloc(RiwayatPekerjaanState initialState)
      : super(initialState);

  Client client = Client();
  @override
  Stream<RiwayatPekerjaanState> mapEventToState(
    RiwayatPekerjaanEvent event,
  ) async* {
    if (event is GetDataRP) {
      final value = state.token;
      final response = await client.get(
        Uri.encodeFull(BaseUrl.riwayat),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $value',
          'Accept': 'application-json'
        },
      );
      final res = response.body;
      final aa = '[$res]';
      if (response.statusCode == 200) {
        final List<RiwayatPekerjaan> riwayatPekerjaan =
            riwayatPekerjaanFromJson(aa);
        print(riwayatPekerjaan);
        yield RiwayatPekerjaanState("1");
      } else {
        yield RiwayatPekerjaanState("1");
        throw Exception('Failed To Load Data');
      }
    } else {}
  }
}
