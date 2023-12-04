import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// weather class for display weather data in the home page
// use openWeatherAPI
class Weather {
  final String? condition;
  final int? temperature;
  final String? iconUrl;

  Weather(
      {required this.condition,
      required this.temperature,
      required this.iconUrl});
}

Future<Weather> fetchWeatherData() async {
  const String apiKey = 'f3165e965ea00a5735720ac0b606312a'; // api key
  Position currentLocation = await Geolocator.getCurrentPosition();
  final response = await http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&appid=$apiKey&units=metric'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    String condition = json['weather'][0]['main'];
    double temperature = json['main']['temp'];
    int tempInt = temperature.round();
    String iconCode = json['weather'][0]['icon'];
    String iconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';
    return Weather(
        condition: condition, temperature: tempInt, iconUrl: iconUrl);
  } else {
    return Weather(condition: null, temperature: null, iconUrl: null);
  }
}
