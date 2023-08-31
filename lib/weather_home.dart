import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/addition_info_card.dart';
import 'package:weather_app/forcast_card.dart';
import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  //Get Current Weather from the API
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      String url =
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherApiKey';

      var response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['cod'] != '200') {
        throw 'Some Boring errors has been occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'My Weather App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ),
          ]),
      body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('Some Boring Errors has been Occured!!'),
              );
            }

            final data = snapshot.data!;
            final currentData = data['list'][0];

            final currentTemp = currentData['main']['temp'];
            final descText = currentData['weather'][0]['main'];
            final currentHumidity = currentData['main']['humidity'];
            final currentWindSpeed = currentData['wind']['speed'];
            final currentPressure = currentData['main']['pressure'];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Banner
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              '$currentTemp K',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              descText == 'Clouds' || descText == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 80,
                            ),
                            Text(
                              descText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  //weather forcast
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: ((context, index) {
                          final time = DateTime.parse(
                              data['list'][index + 1]['dt_txt'].toString());
                          final hourlyTemprature = data['list'][index + 1]
                                  ['main']['temp']
                              .toString();
                          return ForcastCard(
                              time: DateFormat.j().format(time),
                              icon: data['list'][index + 1]['weather'][0]
                                              ['main'] ==
                                          'Clouds' ||
                                      data['list'][index + 1]['weather'][0]
                                              ['main'] ==
                                          'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              temprature: hourlyTemprature);
                        })),
                  ),

                  const SizedBox(height: 15),

                  //Additional Info
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionInfoCard(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionInfoCard(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionInfoCard(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
