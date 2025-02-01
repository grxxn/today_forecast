import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/models/fcst_forecast_model.dart';
import 'package:flutter_project/models/obsr_forecast_model.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static String weatherApiKey = dotenv.env["WEATHER_API_KEY"]!;
  static const String baseUrl =
      "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0";

  static final now = DateTime.now();
  static final baseDate =
      "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
  static const baseTime = "0600";
  static const nx = "60";
  static const ny = "126";
  final Map<String, dynamic> commonParameter = {
    'numOfRows': '1000',
    'pageNo': '1',
    'serviceKey': weatherApiKey,
    'base_date': baseDate,
    'base_time': baseTime,
    'nx': nx,
    'ny': ny,
    'dataType': 'JSON',
  };

  // 초단기실황 조회
  Future<List<ObsrForecastModel>> getUltraSrtNcst({
    String? nx,
    String? ny,
  }) async {
    String url = "$baseUrl/getUltraSrtNcst";

    final queryPrarmeters = {...commonParameter};
    if (nx != null) queryPrarmeters['nx'] = nx;
    if (ny != null) queryPrarmeters['ny'] = ny;
    final fetchUri = Uri.parse(url).replace(queryParameters: queryPrarmeters);

    try {
      final response = await http.get(fetchUri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final forecast = data['response']['body']['items']['item'];

        List<ObsrForecastModel> extractedForecast =
            List<ObsrForecastModel>.from(forecast.map((item) {
          return ObsrForecastModel(
            category: item['category'],
            obsrValue: item['obsrValue'],
          );
        }));

        return extractedForecast;
      } else {
        throw Exception("Failed to fetch UltraSrtNcst: ${response.statusCode}");
      }
    } catch (e) {
      throw Error();
    }
  }

  // 단기예보 조회
  Future<List<FcstForecastModel>> getVilageFcst({
    String? nx,
    String? ny,
    String? baseTime,
  }) async {
    String url = '$baseUrl/getVilageFcst';

    final queryPrarmeters = {...commonParameter};
    queryPrarmeters['base_time'] = '0200';

    if (nx != null) queryPrarmeters['nx'] = nx;
    if (ny != null) queryPrarmeters['ny'] = ny;
    if (baseTime != null) queryPrarmeters['base_time'] = baseTime;
    final fetchUri = Uri.parse(url).replace(queryParameters: queryPrarmeters);

    try {
      final response = await http.get(fetchUri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final forecast = data['response']['body']['items']['item'];

        List<FcstForecastModel> extractedForecast =
            List<FcstForecastModel>.from(
          forecast.map(
            (item) {
              return FcstForecastModel(
                category: item['category'],
                fcstValue: item['fcstValue'],
                fcstDate: DateTime.parse(item['fcstDate']),
                fcstTime: item['fcstTime'],
              );
            },
          ),
        );

        return extractedForecast;
      } else {
        throw Exception("Failed to fetch VilageFcst: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch VilageFcst: $e");
    }
  }
}
