import 'package:flutter/material.dart';
import 'package:flutter_project/models/fcst_forecast_model.dart';
import 'package:flutter_project/models/obsr_forecast_model.dart';
import 'package:flutter_project/widgets/weather_info_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String temperature = "";
  List<FcstForecastModel> fcstList = [];

  @override
  void initState() {
    super.initState();

    loadForecastData();
  }

  void loadForecastData() async {
    // 초단기실황 조회
    final obsrData = await ObsrForecastModel.fetchObsrData();

    // 단기예보 조회
    String? minTemp, maxTemp;
    String baseTime = '0200';

    List<FcstForecastModel> fcstResponseList = [];

    do {
      fcstResponseList =
          await FcstForecastModel.fetchFcstData(baseTime: baseTime);

      minTemp = FcstForecastModel.getValueForCategory(fcstResponseList, 'TMN');
      maxTemp = FcstForecastModel.getValueForCategory(fcstResponseList, 'TMX');

      if (minTemp == null || maxTemp == null) {
        baseTime = getNextBaseTime(baseTime);
      }
      if (minTemp != null && maxTemp != null) {
        minTemp = (double.parse(minTemp)).toStringAsFixed(0);
        maxTemp = (double.parse(maxTemp)).toStringAsFixed(0);
      }
    } while (minTemp == null || maxTemp == null);

    setState(() {
      temperature = ObsrForecastModel.getValueForCategory(obsrData, "T1H")!;
      fcstList = fcstResponseList;
    });
  }

  String getNextBaseTime(String currentBaseTime) {
    int currentTime = int.parse(currentBaseTime);
    currentTime += 300; // 3시간 더해줌

    if (currentTime >= 2400) currentTime = 200;

    return currentTime.toString().padLeft(4, '0');
  }

  Icon getWeatherIcon(String sky, String pty) {
    IconData icon = MdiIcons.weatherCloudy;
    Color iconColor = Colors.blueGrey.shade400;

    if (pty == "1") {
      icon = MdiIcons.weatherPouring;
      iconColor = Colors.blue.shade400;
    }
    if (pty == "2") {
      icon = MdiIcons.weatherSnowyRainy;
      iconColor = Colors.blue.shade200;
    }
    if (pty == "3") {
      icon = MdiIcons.weatherSnowyHeavy;
      iconColor = Colors.blue.shade200;
    }
    if (sky == "1") {
      icon = Icons.wb_sunny_outlined;
      iconColor = Colors.amber.shade400;
    }
    if (sky == "3") icon = MdiIcons.weatherCloudy;

    return Icon(
      icon,
      color: iconColor,
      size: 100,
    );
  }

  String getWindDirection(String degree) {
    double doubleDegree = double.parse(degree);
    if (doubleDegree >= 0 && doubleDegree < 45) return "북";
    if (doubleDegree >= 45 && doubleDegree < 135) return "북";
    if (doubleDegree >= 135 && doubleDegree < 225) return "북";
    if (doubleDegree >= 225 && doubleDegree < 315) return "북";
    return "북";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 22,
      ),
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withAlpha(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "오늘의 날씨",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF252525),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$temperature°',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
              getWeatherIcon(
                FcstForecastModel.getValueForCategory(fcstList, "SKY") ?? "1",
                FcstForecastModel.getValueForCategory(fcstList, "PTY") ?? "0",
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    WeatherInfoWidget(
                      icon: Icons.device_thermostat_outlined,
                      title: "최고 / 최저",
                      value:
                          "${FcstForecastModel.getValueForCategory(fcstList, "TMN") ?? ""} / ${FcstForecastModel.getValueForCategory(fcstList, "TMX") ?? ""}",
                    ),
                    WeatherInfoWidget(
                      icon: MdiIcons.waterOutline,
                      title: "습도",
                      value:
                          "${FcstForecastModel.getValueForCategory(fcstList, "REH") ?? ""} %",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    WeatherInfoWidget(
                      icon: MdiIcons.weatherRainy,
                      title: "강수",
                      value:
                          "${FcstForecastModel.getValueForCategory(fcstList, "POP") ?? ""} %",
                    ),
                    WeatherInfoWidget(
                      icon: MdiIcons.weatherWindy,
                      title: "바람",
                      value:
                          "${getWindDirection(FcstForecastModel.getValueForCategory(fcstList, "VEC") ?? "0")} ${FcstForecastModel.getValueForCategory(fcstList, "WSD") ?? ""} m/s",
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
