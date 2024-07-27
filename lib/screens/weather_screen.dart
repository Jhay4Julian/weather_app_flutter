import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cityName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 100],
            colors: [
              Color(0xFF5936B4),
              Color(0xFF362A84),
            ],
          )),
        ),
      ),
      backgroundColor: const Color(0xFF45278B),

      /// TEST
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.red),
                        const SizedBox(height: 5),
                        Text(
                          _weather?.cityName ?? 'Loading data...',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    TempCard(
                      temperature: '${_weather?.temperature.round()}°',
                      feelslike: 'feels like ${_weather?.feelsLike}°',
                    ),
                    const SizedBox(height: 30),
                    PropTile(title: 'Humidity', value: '${_weather?.humidity}'),
                    PropTile(
                        title: 'Visibility', value: '${_weather?.humidity}'),
                    PropTile(
                        title: 'Wind Speed', value: '${_weather?.windSpeed}'),
                    PropTile(
                        title: 'Wind Degree', value: '${_weather?.windDeg}'),
                  ],
                ),
        ),
      ),
    );
  }
}

class TempCard extends StatelessWidget {
  final String temperature;
  final String feelslike;
  const TempCard(
      {super.key, required this.temperature, required this.feelslike});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5936B4),
              Color(0xFF362A84),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Text(
              temperature,
              style: const TextStyle(fontSize: 50, color: Colors.white),
            ),
            Text(
              feelslike,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// For the other weather properties

class PropTile extends StatelessWidget {
  final String title;
  final String value;
  const PropTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5936B4),
              Color(0xFF362A84),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 15, color: Colors.white)),
          const Text('-', style: TextStyle(fontSize: 18, color: Colors.white)),
          Text(
            value,
            style: const TextStyle(fontSize: 17, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
