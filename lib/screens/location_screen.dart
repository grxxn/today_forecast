import 'package:flutter/material.dart';
import 'package:flutter_project/services/address_api_service.dart';
import 'package:flutter_project/widgets/fine_dust_widget.dart';
import 'package:flutter_project/widgets/weather_widget.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _address = "위치를 가져오는 중 ...";
  Map<String, double> currentCoordinates = {};

  @override
  void initState() {
    super.initState();

    getCurrentLocation().then((position) async {
      Map<String, dynamic> addressData =
          await AddressApiService.getAddressFromLatLng(
              position.latitude, position.longitude);

      setState(() {
        _address =
            "${addressData['region_1depth_name']} ${addressData['region_2depth_name']} ${addressData['region_3depth_name']}";
        currentCoordinates = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
      });
    }).catchError((e) {
      setState(() {
        _address = e.toString();
      });
    });
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('위치 서비스가 비활성화되어 있습니다.');

    // 위치 권환 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error("위치 권한이 거부되었습니다.");
      }
    }

    // 현재 위치 가져오기
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.black54,
                  size: 20,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  _address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const WeatherWidget(),
            currentCoordinates.isNotEmpty
                ? FineDustWidget(currentCoordinates: currentCoordinates)
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
