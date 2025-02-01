import 'package:flutter_project/services/weather_api_service.dart';

class ObsrForecastModel {
  final String category, obsrValue;

  ObsrForecastModel({required this.category, required this.obsrValue});

  static Future<List<ObsrForecastModel>> fetchObsrData() async {
    final weatherData = await WeatherApiService().getUltraSrtNcst();

    return weatherData;
  }

  static String? getValueForCategory(
      List<ObsrForecastModel> weatherData, String category) {
    try {
      final data = weatherData.firstWhere((item) => item.category == category);
      return data.obsrValue;
    } catch (e) {
      return null;
    }
  }
}
