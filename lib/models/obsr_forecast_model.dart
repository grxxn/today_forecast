import 'package:flutter_project/services/weather_api_service.dart';

class ObsrForecastModel {
  final String category, obsrValue;

  ObsrForecastModel({required this.category, required this.obsrValue});

  // ObsrForecastModel.fromJson(Map<String, dynamic> json)
  //     : category = json['category'],
  //       obsrValue = json['obsrValue'];

  static Future<List<ObsrForecastModel>> fetchWeatherData() async {
    final now = DateTime.now();
    final baseDate =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    const baseTime = "0600";
    const nx = "60";
    const ny = "126";

    final weatherData = await WeatherApiService.getWeatherData(
        baseDate: baseDate, baseTime: baseTime, nx: nx, ny: ny);

    return weatherData;
  }

  static String? getObsrValueForCategory(
      List<ObsrForecastModel> weatherData, String category) {
    try {
      final data = weatherData.firstWhere((item) => item.category == category);
      return data.obsrValue;
    } catch (e) {
      return null;
    }
  }
}
