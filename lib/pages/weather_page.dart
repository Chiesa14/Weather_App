import 'package:flutter/material.dart';
import 'package:todo_app/models/weather_model.dart';
import 'package:todo_app/services/weather_service.dart';

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

  @override
  void initState() {
    super.initState();

    _featchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_weather?.cityName ?? "Loading City.."),
          Text("${_weather?.temperature.round()}°C")
        ],
      ),
    ));
  }

  //weather animations

//init state
}
