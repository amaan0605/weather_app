import 'package:flutter/material.dart';

class ForcastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temprature;
  const ForcastCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temprature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    icon,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(temprature),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
