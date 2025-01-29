import 'package:flutter/material.dart';
import 'package:flutter_project/models/obsr_forecast_model.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String temperature = "";

  @override
  void initState() {
    super.initState();

    loadWeatherData();
  }

  void loadWeatherData() async {
    final weatherData = await ObsrForecastModel.fetchWeatherData();
    setState(() {
      temperature =
          ObsrForecastModel.getObsrValueForCategory(weatherData, "T1H")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "오늘의 날씨",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF252525),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "$temperature °C",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                // Icons.cloud_outlined,
                // Icons.sunny,
                Icons.cloudy_snowing,
                size: 70,
                color: Colors.blue.shade600,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // Text("Current Weather: Sunny"),
          // Text("Temperature: 25°C"),
          // Text("Humidity: 80%"),
          // Text("Wind Speed: 5 mph"),
          // Text("Wind Direction: N"),
        ],
      ),
    );
  }
}
