import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Service/WeatherService.dart';
import 'package:weather_app/Models/WatherModel.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _WeatherService = WeatherService("ba9cf0093bf6cd633fc14d965d8b11e8");
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city
    //String cityName = await _WeatherService.getCurrentCity();
    List listOfLocation = await _WeatherService.getCurrentLocation();

    //get weather for city
    try {
      //final weather = await _WeatherService.getWeather(cityName);
      final weather =
          await _WeatherService.getWeatherForLocation(listOfLocation);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animations
  String getAnimationForWeather(String? condition) {
    if (condition == null) return 'assets/wait.json';

    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/wait.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_weather?.cityName ?? "Loading city...",
              style: TextStyle(fontSize: 25)),
          Lottie.asset(getAnimationForWeather(_weather?.mainCondition)),
          Text(
            '${_weather?.temperature.round() ?? "-"} °C',
            style: TextStyle(fontSize: 20),
          ),
        ]),
      ),
    );
  }
}
