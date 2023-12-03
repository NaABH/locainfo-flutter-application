import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<String> fetchWeatherData() async {
  Position currentLocation = await Geolocator.getCurrentPosition();
  final response = await http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}&appid=f3165e965ea00a5735720ac0b606312a&units=metric'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    String condition = json['weather'][0]['main'];
    double temperature = json['main']['temp'];
    int tempInt = temperature.round();
    return '$condition, $tempInt°C';
  } else {
    return 'Unknown, ? °C';
  }
}
