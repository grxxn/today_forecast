import 'package:flutter/material.dart';
import 'package:flutter_project/models/fine_dust_model.dart';
import 'package:flutter_project/services/address_api_service.dart';
import 'package:flutter_project/services/fine_dust_api_service.dart';

class FineDustWidget extends StatefulWidget {
  final Map<String, double> currentCoordinates;
  const FineDustWidget({super.key, required this.currentCoordinates});

  @override
  State<FineDustWidget> createState() => _FineDustWidgetState();
}

class _FineDustWidgetState extends State<FineDustWidget> {
  late Map<String, double> currentCoordinates;
  String nearestStation = "";
  int currentTabIdx = 0;
  String currentGrade = "1";
  String currentValue = "0";
  Color currentColor = const Color(0xFF1c8bf3);
  FineDustModel? fineDustInfo;

  List<Color> gradeColors = [
    const Color(0xFF1c8bf3),
    const Color(0xFF0aa953),
    const Color(0xFFf36919),
    const Color(0xFFf34545),
  ];
  List<Map<String, String>> minMaxValuebyGrade = [
    {
      "goodMaxValue": "30",
      "normalMaxValue": "80",
      "badMaxValue": "150",
      "veryBadMinValue": "151",
    },
    {
      "goodMaxValue": "15",
      "normalMaxValue": "35",
      "badMaxValue": "75",
      "veryBadMinValue": "76",
    },
    {
      "goodMaxValue": "0.030",
      "normalMaxValue": "0.090",
      "badMaxValue": "0.150",
      "veryBadMinValue": "0.151",
    },
  ];

  @override
  void initState() {
    super.initState();
    currentCoordinates = widget.currentCoordinates;

    loadNearbyMsrstnList();
  }

  void loadNearbyMsrstnList() async {
    if (currentCoordinates.isNotEmpty) {
      Map<String, String> tmCoordinates =
          await AddressApiService.getTmCoordinates(
              currentCoordinates["latitude"]!,
              currentCoordinates["longitude"]!);

      String? tmX = tmCoordinates['tmX'];
      String? tmY = tmCoordinates['tmY'];
      if (tmX != null && tmY != null) {
        Map<String, dynamic> nearestStationResponse =
            await FineDustApiService().getNearbyMsrstnList(tmX, tmY);

        nearestStation = nearestStationResponse['stationName'];
      }
    }
    // 측정소 실시간 측정정보 조회
    FineDustModel finedustInfoResponse = await FineDustApiService()
        .getMsrstnAcctoRltmMesureDnsty(nearestStation);
    fineDustInfo = finedustInfoResponse;

    // 미세먼지 지수
    currentGrade = fineDustInfo!.pm10Grade;
    currentValue = fineDustInfo!.pm10Value;
    currentColor = gradeColors[int.parse(currentGrade) + 1];

    setState(() {});
  }

  String getGradeValue() {
    if (currentGrade == "1") {
      return "좋음";
    } else if (currentGrade == "2") {
      return "보통";
    } else if (currentGrade == "3") {
      return "나쁨";
    } else {
      return "매우나쁨";
    }
  }

  void changeTab(int tabIdx) {
    if (tabIdx == 0) {
      currentGrade = fineDustInfo!.pm10Grade;
      currentValue = fineDustInfo!.pm10Value;
    } else if (tabIdx == 1) {
      currentGrade = fineDustInfo!.pm25Grade!;
      currentValue = fineDustInfo!.pm25Value!;
    } else if (tabIdx == 2) {
      currentGrade = fineDustInfo!.o3Grade;
      currentValue = fineDustInfo!.o3Value;
    }
    setState(() {
      currentTabIdx = tabIdx;
      currentColor = gradeColors[int.parse(currentGrade) + 1];
    });
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
        color: Colors.black.withAlpha(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.place,
                size: 14,
                color: Colors.grey.shade700,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                '$nearestStation 측정소',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // 대기환경정보 Tab
          Row(
            children: [
              TabButton(
                txt: "미세먼지",
                isActive: currentTabIdx == 0,
                onTap: () => changeTab(0),
              ),
              const SizedBox(
                width: 10,
              ),
              TabButton(
                txt: "초미세먼지",
                isActive: currentTabIdx == 1,
                onTap: () => changeTab(1),
              ),
              const SizedBox(
                width: 10,
              ),
              TabButton(
                txt: "오존",
                isActive: currentTabIdx == 2,
                onTap: () => changeTab(2),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            // width: currentTabIdx != 2 ? 44 : 70,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: gradeColors[int.parse(currentGrade) - 1],
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "현재",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '${getGradeValue()} ($currentValue)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DustGradeBar(
            gradeColors: gradeColors,
            minMaxValuebyGrade: minMaxValuebyGrade[currentTabIdx],
          ),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    required this.txt,
    required this.isActive,
    required this.onTap,
  });

  final String txt;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? Colors.black87 : Colors.black26,
        ),
        child: Text(
          txt,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DustGradeBar extends StatelessWidget {
  const DustGradeBar({
    super.key,
    required this.gradeColors,
    required this.minMaxValuebyGrade,
  });

  final List<Color> gradeColors;
  final Map<String, String> minMaxValuebyGrade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 2.5,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: gradeColors[0],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: gradeColors[1],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: gradeColors[2],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: gradeColors[3],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "좋음 0",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[0],
                      ),
                    ),
                    Text(
                      "~${minMaxValuebyGrade["goodMaxValue"]}",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[0],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "보통",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[1],
                      ),
                    ),
                    Text(
                      "~${minMaxValuebyGrade["normalMaxValue"]}",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[1],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "나쁨",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[2],
                      ),
                    ),
                    Text(
                      "~${minMaxValuebyGrade["badMaxValue"]}",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[2],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "매우나쁨",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[3],
                      ),
                    ),
                    Text(
                      "${minMaxValuebyGrade["veryBadMinValue"]}~",
                      style: TextStyle(
                        fontSize: 11,
                        color: gradeColors[3],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
