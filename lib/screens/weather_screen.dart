import 'dart:ui';

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
        title: Text(widget.cityName),
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 30),
                    TempCard(tempDigit: '${_weather?.temperature.round()}°'),
                  ],
                ),
        ),
      ),
    );
  }
}

class TempCard extends StatelessWidget {
  final String tempDigit;
  const TempCard({super.key, required this.tempDigit});

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
        child: Text(
          tempDigit,
          style: const TextStyle(fontSize: 50, color: Colors.white),
        ),
      ),
    );
  }
}
