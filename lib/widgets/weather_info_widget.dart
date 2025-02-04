import 'package:flutter/material.dart';

class WeatherInfoWidget extends StatelessWidget {
  const WeatherInfoWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(20, 0, 0, 0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
