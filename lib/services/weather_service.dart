import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather data');
    }
  }

  Future<String> getCurrentCity() async {
    try {
      //get permissions from the users
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Future.error("Permission partially denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Future.error("Permission permenently denied");
      }

      //fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      //convent the location into a list of placemark objects
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      //Extracting the city from the first placemarks
      String? city;
      for (var element in placemarks) {
        if (element.locality != "") {
          city = element.locality;
          break;
        }
      }
      String? defaultCity = "kigali";
      return city ?? defaultCity;
    } catch (e) {
      print(e);
      return "";
    }
  }
}
