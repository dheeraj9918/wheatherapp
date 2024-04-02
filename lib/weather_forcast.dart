import 'package:flutter/material.dart';

class HourlyWeatherForcast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyWeatherForcast({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 115,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
