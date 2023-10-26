import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Weather {
  String? currentTemp;
  String? currentPrecip;
  DateTime? nextSnowTime;
  String? nextSnowOdds;
  Image? icon;

  Weather(
      {this.currentTemp,
      this.currentPrecip,
      this.nextSnowTime,
      this.nextSnowOdds,
      this.icon});
}

Future<Weather> fetchWeatherData(double latitude, double longitude) async {
  final weatherApiUrl = 'https://api.weather.gov/points/$latitude,$longitude';
  final response = await http.get(Uri.parse(weatherApiUrl));
  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);
    final forecastApiUrl = decodedData['properties']['forecast'];
    final forecastResponse = await http.get(Uri.parse(forecastApiUrl));
    if (forecastResponse.statusCode == 200) {
      final List forecast =
          jsonDecode(forecastResponse.body)['properties']['periods'];
      final String currentTemp = forecast[0]['temperature'] != null
          ? forecast[0]['temperature'].toString()
          : '';
      final currentPrecip = forecast[0]['shortForecast'];
      final url = forecast[0]['icon'];
      final Image icon = Image.network(url);
      DateTime? nextSnowTime;
      String? nextSnowOdds;

      for (final item in forecast) {
        if (item['shortForecast'].toString().toLowerCase().contains('rain')) {
          nextSnowTime = DateTime.parse(item['startTime']);
          nextSnowOdds = item['probabilityOfPrecipitation']['value'] != null
              ? item['probabilityOfPrecipitation']['value'].toString()
              : '';
          break;
        }
      }
      return Weather(
          currentTemp: currentTemp,
          currentPrecip: currentPrecip,
          nextSnowTime: nextSnowTime,
          nextSnowOdds: nextSnowOdds,
          icon: icon);
    }
  }
  print('Failed to fetch weather data: $response');
  return Weather();
}

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  final TextStyle title =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
  final TextStyle body = const TextStyle(fontSize: 16);

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        weather.icon ?? const SizedBox.shrink(),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now',
              style: title,
            ),
            Text(
              weather.currentTemp != '' ? '${weather.currentTemp}°F' : '',
              style: body,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 220,
              child: Text(
                softWrap: true,
                weather.currentPrecip != null
                    ? (weather.currentPrecip!.length <= 25)
                        ? weather.currentPrecip!
                        : '${weather.currentPrecip!.substring(0, 25)}...'
                    : '',
                style: body,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Next Snow',
              style: title,
            ),
            Text(
              '${weather.nextSnowTime != null ? DateFormat('EEEE h a').format(weather.nextSnowTime!).toString() : 'Not forecasted'} ${weather.nextSnowOdds != null ? '(${weather.nextSnowOdds}% chance)' : ''}',
              style: body,
            ),
          ],
        ),
      ],
    );
  }
}

class WeatherPage extends StatefulWidget {
  final double lat;
  final double lon;

  const WeatherPage({Key? key, required this.lat, required this.lon})
      : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Weather> _futureWeather;

  @override
  void initState() {
    super.initState();
    _futureWeather = fetchWeatherData(widget.lat, widget.lon);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _futureWeather,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return WeatherDisplay(weather: snapshot.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
