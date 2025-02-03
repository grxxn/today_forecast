import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AddressApiService {
  /// 경도/위도 정보를 위치 정보로 convert
  static Future<Map<String, dynamic>> getAddressFromLatLng(
      double latitude, double longitude) async {
    final String url =
        "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$longitude&y=$latitude";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization":
            "KakaoAK ${dotenv.env["KAKAO_API_KEY"]}", // API 키를 Authorization 헤더로 추가
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final addressData = data['documents'][0]['address'];

      return addressData;
    } else {
      throw Error();
    }
  }

  static Future<Map<String, String>> getTmCoordinates(
      double latitude, double longitude) async {
    final String url =
        "https://dapi.kakao.com/v2/local/geo/transcoord.json?x=$longitude&y=$latitude&input_coord=WGS84&output_coord=TM";
    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': "KakaoAK ${dotenv.env["KAKAO_API_KEY"]}"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tmX = data['documents'][0]['x'].toString();
      final tmY = data['documents'][0]['y'].toString();

      return {'tmX': tmX, 'tmY': tmY};
    } else {
      return {'tmX': '', 'tmY': ''};
    }
  }
}
