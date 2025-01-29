import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_project/models/obsr_forecast_model.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  // 날씨 데이터 조회
  static Future<List<ObsrForecastModel>> getWeatherData({
    required String baseDate,
    required String baseTime,
    required String nx,
    required String ny,
  }) async {
    String weatherApiKey = dotenv.env["WEATHER_API_KEY"]!;
    const String url =
        "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst";

    final queryParameters = {
      'serviceKey': weatherApiKey,
      'base_date': baseDate,
      'base_time': baseTime,
      'nx': nx,
      'ny': ny,
      'dataType': 'JSON',
    };

    final fetchUri = Uri.parse(url).replace(queryParameters: queryParameters);
    try {
      final response = await http.get(fetchUri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
        throw Exception("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (e) {
      throw Error();
    }
  }
}
