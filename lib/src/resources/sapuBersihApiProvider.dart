import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:sapubersih/src/models/riwayatPekerjaanModel.dart';
import 'dart:async';

class SapuBersihApiProvider {
  Client client = Client();
  final _apiUrl = "http://167.99.70.194/api";
  //  =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiMjY5ZWZhMzk1NTg4MzEzMzc5ZjJiNjQ5ZjQzYzFjNzdhYThiMjJlNGM5YWExNzJjZjNlNDQ5ODI5NzA5YmJlY2FkZTdmYjRjNDdlYzcxZWMiLCJpYXQiOjE1OTQzNDU3MTksIm5iZiI6MTU5NDM0NTcxOSwiZXhwIjoxNjI1ODgxNzE5LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.t-FVI3cxUABgGzpXd9FbrptpQz3DGcjD1PP8zfQKWqgnhJKVoJT-phgok8lg71IWTfJXSFEsfvy0rwyRFMhS-HYVDF_zuaXES1pvIhz1FnA5z2xnTWqFZ_qvtj8mAtDjZ_QzfTt_1NayheRJkgmk72PkXTsOi5sevLrSEcuKtU8OaB8fN8Phy8jVUk-Q_tBfGmwTMf1g8fF-jisk2DegXYx3Qpz-SrMGuXp7JEGzilhsz5sL6Cz0hpMYozNhT84zy1bSs1-Ivd0_l0uOnB-_lewd-3D4g70fcI09626QQCDeLNXmbzCe1Tq9ALmvArvoDLmsCY8jhqO9z3j88PZh_P7OQmunt41CBRHoctvne5A-NVtAIj-7bCKH4RlTqmbvKPVc6PsxUxasC8GfwYkxSrOVTcONfPuObdDDlkSRH9ZD3aN2f6iVMUV50P0_m9G-xM3YXfMNFMizGwKZM-RzZu9EHfXUoyx52DBmO0bn2EkQmSVO9SS0m-wtQT5bg5HsqT6a0UyA2kvkWCK0ymyfATSJmnOGv1dL7qjn_Vt3V-IIwjY7fHGI98ROfkMSahVmWCP-nyX0GpQTeipIAo8TfwYic3Kx_yTDDTDb6WrOqErJTnLnZvQjj82Q-EdkLc059XOGa0BGuS8Y7h8333q0U5P41OMK5CgnvKP_tGLx0Uw';

  Future<List<RiwayatPekerjaan>> fetchRiwayatPekerjaanList() async {
    final response = await client.get(
      Uri.encodeFull('$_apiUrl/lokasi_terkini'),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiMjY5ZWZhMzk1NTg4MzEzMzc5ZjJiNjQ5ZjQzYzFjNzdhYThiMjJlNGM5YWExNzJjZjNlNDQ5ODI5NzA5YmJlY2FkZTdmYjRjNDdlYzcxZWMiLCJpYXQiOjE1OTQzNDU3MTksIm5iZiI6MTU5NDM0NTcxOSwiZXhwIjoxNjI1ODgxNzE5LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.t-FVI3cxUABgGzpXd9FbrptpQz3DGcjD1PP8zfQKWqgnhJKVoJT-phgok8lg71IWTfJXSFEsfvy0rwyRFMhS-HYVDF_zuaXES1pvIhz1FnA5z2xnTWqFZ_qvtj8mAtDjZ_QzfTt_1NayheRJkgmk72PkXTsOi5sevLrSEcuKtU8OaB8fN8Phy8jVUk-Q_tBfGmwTMf1g8fF-jisk2DegXYx3Qpz-SrMGuXp7JEGzilhsz5sL6Cz0hpMYozNhT84zy1bSs1-Ivd0_l0uOnB-_lewd-3D4g70fcI09626QQCDeLNXmbzCe1Tq9ALmvArvoDLmsCY8jhqO9z3j88PZh_P7OQmunt41CBRHoctvne5A-NVtAIj-7bCKH4RlTqmbvKPVc6PsxUxasC8GfwYkxSrOVTcONfPuObdDDlkSRH9ZD3aN2f6iVMUV50P0_m9G-xM3YXfMNFMizGwKZM-RzZu9EHfXUoyx52DBmO0bn2EkQmSVO9SS0m-wtQT5bg5HsqT6a0UyA2kvkWCK0ymyfATSJmnOGv1dL7qjn_Vt3V-IIwjY7fHGI98ROfkMSahVmWCP-nyX0GpQTeipIAo8TfwYic3Kx_yTDDTDb6WrOqErJTnLnZvQjj82Q-EdkLc059XOGa0BGuS8Y7h8333q0U5P41OMK5CgnvKP_tGLx0Uw',
        'Accept': 'application-json'
      },
    );

    final res = response.body;
    final aa = '[$res]';

    if (response.statusCode == 200) {
      final List<RiwayatPekerjaan> riwayatPekerjaan =
          riwayatPekerjaanFromJson(aa);
      return riwayatPekerjaan;
    } else {
      throw Exception('Failed To Load Data');
    }
  }
}
