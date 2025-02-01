import 'package:flutter_project/services/weather_api_service.dart';

class FcstForecastModel {
  final String category, fcstValue, fcstTime;
  final DateTime fcstDate;

  FcstForecastModel(
      {required this.category,
      required this.fcstValue,
      required this.fcstDate,
      required this.fcstTime});

  @override
  String toString() {
    return 'FcstForecastModel{category: $category, fcstValue: $fcstValue, fcstDate: $fcstDate, fcstTime: $fcstTime}';
  }

  static Future<List<FcstForecastModel>> fetchFcstData(
      {String? nx, String? ny, String? baseTime}) async {
    final fcstData = await WeatherApiService()
        .getVilageFcst(nx: nx, ny: ny, baseTime: baseTime);

    return fcstData;
  }

  static String? getValueForCategory(
      List<FcstForecastModel> weatherData, String category) {
    try {
      final data = weatherData.firstWhere((item) => item.category == category);
      return data.fcstValue;
    } catch (e) {
      return null;
    }
  }
}
