import 'dart:convert';
import 'dart:developer';

import 'package:cuaca/models/weather_model.dart';
import 'package:cuaca/models/weather_response_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _baseUrl = "api.openweathermap.org";
  final String _path = "/data/2.5/weather";
  final String _apiKey = "f8d2bb787ce88af52d9805523cec8ab1";

  Future<WeatherModel> fetchWeather() async {
    final queryParam = {
      'q': 'denpasar',
      // 'lat': '33.44',
      // 'lon': '-94.04',
      'exclude': 'minutely',
      'units': 'metric',
      'appid': _apiKey
    };
    final uri = Uri.https(_baseUrl, _path, queryParam);
    log(uri.toString());
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
