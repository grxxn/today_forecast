import 'package:flutter/material.dart';
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

        setState(() {
          nearestStation = nearestStationResponse['stationName'];
        });
      }
    }
    // await FineDustApiService().getNearbyMsrstnList(tmX, tmY)
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
                size: 16,
                color: Colors.grey.shade700,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                '$nearestStation 측정소',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
