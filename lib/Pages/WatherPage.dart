import 'package:flutter/material.dart';
import 'package:weather_app/Service/WeatherService.dart';
import 'package:weather_app/Models/WatherModel.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _WeatherService = WeatherService("Your api key");
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
          Text(_weather?.cityName ?? "Loading city..."),
          Text('${_weather?.temperature}st C')
        ]),
      ),
    );
  }
}
