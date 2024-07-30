import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_flutter/models/weather_model.dart';
import 'package:weather_app_flutter/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;
  const WeatherScreen({super.key, required this.cityName});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // api key
  final _weatherService =
      WeatherService(apiKey: 'f0ffae9c194a92c0bd9d77be441b8013');
  Weather? _weather;
  bool _isLoading = true;

  _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeather(widget.cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  // weather animation function
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/animations/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'dust':
      case 'fog':
      case 'haze':
      case 'mist':
      case 'smoke':
        return 'assets/animations/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/animations/rain.json';
      case 'thunderstorm':
        return 'assets/animations/storm.json';
      case 'clear':
        return 'assets/animations/sunny.json';
      default:
        return 'assets/animations/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  bool _isCelsius = true;

  void convertTemp() {
    setState(() {
      _isCelsius = !_isCelsius;
    });
  }

  @override
  Widget build(BuildContext context) {
    final celsius = _weather?.temperature.round() ?? 0;
    final feelsCelsius = _weather?.feelsLike.round() ?? 0;
    double fahrenheit = (celsius * 9 / 5) + 32;
    double feelsFahrenheit = (feelsCelsius * 9 / 5) + 32;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.location_pin,
                              color: Colors.red, size: 30),
                          const SizedBox(height: 5),
                          Text(
                            _weather?.cityName ?? 'Error: Incorrect input...',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      // Weather Card
                      Stack(
                        children: [
                          TempCard(
                            animation:
                                getWeatherAnimation(_weather?.mainCondition),
                            description: _weather?.description == null
                                ? 'Error'
                                : '${_weather?.description}',
                            temperature:
                                _isCelsius ? '$celsius°C' : '$fahrenheit°F',
                            feelslike: _isCelsius
                                ? 'feels like $feelsCelsius°'
                                : 'feels like $feelsFahrenheit°',
                          ),
                          Positioned(
                            right: 30,
                            top: 10,
                            child: ElevatedButton(
                              onPressed: convertTemp,
                              child: Text(
                                _isCelsius ? '°F' : '°C',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Other Weather Properties
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PropCard(
                                  title: 'Humidity',
                                  value: _weather?.humidity == null
                                      ? 'Error'
                                      : '${_weather?.humidity}%'),
                              PropCard(
                                title: 'Visibility',
                                value: _weather?.visibility == null
                                    ? 'Error'
                                    : '${_weather?.visibility} m',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PropCard(
                                title: 'Wind Speed',
                                value: _weather?.windSpeed == null
                                    ? 'Error'
                                    : '${_weather?.windSpeed} m/s',
                              ),
                              PropCard(
                                title: 'Wind Degree',
                                value: _weather?.windDeg == null
                                    ? 'Error'
                                    : '${_weather?.windDeg}',
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class TempCard extends StatelessWidget {
  final String temperature;
  final String feelslike;
  final String animation;
  final String description;
  const TempCard({
    super.key,
    required this.temperature,
    required this.feelslike,
    required this.animation,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5936B4),
              Color(0xFF362A84),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Lottie.asset(
                  animation,
                  height: 100,
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  temperature,
                  style: const TextStyle(fontSize: 50, color: Colors.white),
                ),
                Text(
                  feelslike,
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// For the other weather properties
class PropCard extends StatelessWidget {
  final String title;
  final String value;
  const PropCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: 140,
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF5936B4),
            Color(0xFF362A84),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
