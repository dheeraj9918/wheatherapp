import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whether_app/additional_info_item.dart';
import 'package:whether_app/secrets.dart';
import 'package:whether_app/weather_forcast.dart';
import 'package:http/http.dart' as http;

class WetherScreen extends StatefulWidget {
  const WetherScreen({super.key});

  @override
  State<WetherScreen> createState() => _WetherScreenState();
}

class _WetherScreenState extends State<WetherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'India';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$weatherAPIkey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "An unexpected Error occured";
      }
      return data;
      // data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentWeather = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main containrer
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Icon(
                                  currentWeather == 'Clouds' ||
                                          currentWeather == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 75),
                              const SizedBox(height: 20),
                              Text(
                                currentWeather,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hourly Forecasts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 6; i++)
                //         HourlyWeatherForcast(
                //           time: data['list'][i + 1]['dt_txt'],
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds'
                //               ? Icons.cloudy_snowing
                //               : Icons.sunny,
                //           temperature:
                //               data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final hourlyWhethre = hourlyForcast['weather'][0]['main'];
                      final time = DateTime.parse(
                        hourlyForcast['dt_txt'],
                      );
                      return HourlyWeatherForcast(
                        // time: DateFormat('Hm').format(time),
                        time: DateFormat.j().format(time),
                        icon:
                            hourlyWhethre == 'Rain' || hourlyWhethre == 'Clouds'
                                ? Icons.cloud
                                : Icons.sunny,
                        temperature: hourlyForcast['main']['temp'].toString(),
                      );
                    },
                  ),
                ),

                //additional informations
                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$currentHumidity',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind speed',
                      value: '$currentWindSpeed',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$currentPressure',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
