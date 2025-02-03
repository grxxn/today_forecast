import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FineDustApiService {
  static String apiKey = dotenv.env["WEATHER_API_KEY"]!;
  static String baseUrl = "http://apis.data.go.kr/B552584";
  // static String fineDustBaseUrl =
  //     "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc";

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
        // debugPrint(response.body);
        final data = jsonDecode(response.body);
        final List<dynamic> items = data['response']['body']['items'];

        final List<Map<String, dynamic>> fineDustResponse =
            items.cast<Map<String, dynamic>>();

        final Map<String, dynamic> minTmItem =
            fineDustResponse.reduce((curr, next) {
          return curr['tm'] < next['tm'] ? curr : next;
        });

        return minTmItem;

        // List<ObsrForecastModel> extractedForecast =
        //     List<ObsrForecastModel>.from(forecast.map((item) {
        //   return ObsrForecastModel(
        //     category: item['category'],
        //     obsrValue: item['obsrValue'],
        //   );
        // }));

        // return extractedForecast;
      } else {
        throw Exception(
            "Failed to fetch NearbyMsrstnList: ${response.statusCode}");
      }
    } catch (e) {
      throw Error();
    }
  }
}
