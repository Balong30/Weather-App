import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() =>
      _WeatherPageState();
}

class _WeatherPageState
    extends State<WeatherPage> {
  final _weatherService = WeatherService(
    '291cef864197d525c10a970bd57d4006',
  );
  Weather? _weather;

  _fetchWeather() async {
    try {
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        throw Exception("Location denied");
      }

      Position position =
          await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );

      final weather = await _weatherService
          .getWeatherByCoords(
            position.latitude,
            position.longitude,
          );

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ??
                  "loading city..",
            ),

            Text(
              '${_weather?.temperature.round()}°C',
            ),
          ],
        ),
      ),
    );
  }
}
