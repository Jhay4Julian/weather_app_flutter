import 'dart:convert';

import 'package:weather_app_flutter/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseURL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    final response =
        await http.get(Uri.parse('$baseURL?q=$cityName&APPID=$apiKey'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
