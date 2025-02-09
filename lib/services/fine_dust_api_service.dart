import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/models/fine_dust_model.dart';
import 'package:http/http.dart' as http;

class FineDustApiService {
  static String apiKey = dotenv.env["WEATHER_API_KEY"]!;
  static String baseUrl = "http://apis.data.go.kr/B552584";

  final Map<String, dynamic> commonParameter = {
    'serviceKey': apiKey,
    'returnType': 'json',
  };

  // 근접측정소 목록 조회
  Future<Map<String, dynamic>> getNearbyMsrstnList(
      String tmX, String tmY) async {
    final String url = '$baseUrl/MsrstnInfoInqireSvc/getNearbyMsrstnList';

    final queryPrarmeters = {...commonParameter};
    queryPrarmeters['tmX'] = tmX;
    queryPrarmeters['tmY'] = tmY;

    final fetchUri = Uri.parse(url).replace(queryParameters: queryPrarmeters);
    try {
      final response = await http.get(fetchUri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> items = data['response']['body']['items'];

        final List<Map<String, dynamic>> fineDustResponse =
            items.cast<Map<String, dynamic>>();

        final Map<String, dynamic> minTmItem =
            fineDustResponse.reduce((curr, next) {
          return curr['tm'] < next['tm'] ? curr : next;
        });

        return minTmItem;
      } else {
        throw Exception(
            "Failed to fetch NearbyMsrstnList: ${response.statusCode}");
      }
    } catch (e) {
      throw Error();
    }
  }

  // 측정소 별 대기환경 정보 조회
  Future<FineDustModel> getMsrstnAcctoRltmMesureDnsty(
      String stationName) async {
    final String url =
        '$baseUrl/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty';

    final queryPrarmeters = {...commonParameter};
    queryPrarmeters['stationName'] = stationName;
    queryPrarmeters['dataTerm'] = "DAILY";
    queryPrarmeters['ver'] = "1.0";

    final fetchUri = Uri.parse(url).replace(queryParameters: queryPrarmeters);
    try {
      final response = await http.get(fetchUri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['response']['body']['items'];

        final fineDustResponse = FineDustModel.fromJson(items[0]);

        return fineDustResponse;
      } else {
        throw Exception(
            "Failed to fetch MsrstnAcctoRltmMesureDnsty: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      debugPrint('e: $e, stackTrace: $stackTrace');
      throw Error();
    }
  }
}
