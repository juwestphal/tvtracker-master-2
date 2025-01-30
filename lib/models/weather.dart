class Weather {
  final String temperature;
  final String humidity;

  Weather({required this.temperature, required this.humidity});

  // Factory method to create a Weather instance from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['temperature'] as String,
      humidity: json['humidity'] as String,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}
