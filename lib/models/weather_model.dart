class Weather {
  final String cityName;
  final String mainCondition;
  final String description;
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double visibility;
  final double windSpeed;
  final double windDeg;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      visibility: json['visibility'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'].toDouble(),
    );
  }
}
