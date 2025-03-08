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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.grey.shade700,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
