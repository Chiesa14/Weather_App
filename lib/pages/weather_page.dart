import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('bed156d3a4468e807a206469aa923767');
  Weather? _weather;
  //fetch weather
  _featchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
    print(cityName);
    //get the weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      rethrow;
    }
  }

  String getTHeWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "dust":
      case "fog":
      case "haze":
        return 'assets/cloud.json';
      case "rain":
      case "drizzle":
      case "shower rain":
        return 'assets/rain.json';
      case "thunderstorm":
        return 'assets/thunder.json';
      case "clear":
      case "sunny":
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  _stylings() {
    return const TextStyle(
        color: Color(0xB3FFFFFF), fontSize: 50, fontWeight: FontWeight.bold);
  }

  @override
  void initState() {
    super.initState();

    _featchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset('assets/location.json', width: 50, height: 50),
              Text(_weather?.cityName ?? "Loading City..", style: _stylings()),
              Lottie.asset(getTHeWeatherAnimation(_weather?.mainCondition)),
              Text(
                "${_weather?.temperature.round()}°",
                style: _stylings(),
              ),
            ],
          ),
        ));
  }

  //weather animations

//init state
}
