import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../Models/WatherModel.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  /*Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$BASE_URL?lat=33.44&lon=-94.04&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJason(jsonDecode(response.body));
    } else {
      var error = response.statusCode;
      throw Exception("Problem with load weather data. Error $error");
    }
  }*/

  Future<Weather> getWeatherForLocation(List location) async {
    String city = location[0];
    num latitude = location[1];
    num longitude = location[2];

    print(latitude);
    print(longitude);

    final response = await http.get(Uri.parse(
        '$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJason(jsonDecode(response.body));
    } else {
      var error = response.statusCode;
      throw Exception("Problem with load weather data. Error $error");
    }
  }

  Future<List> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert location to list of placemarks
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    num latitude = position.latitude;
    num longitude = position.longitude;

    print(position.latitude);
    print(position.longitude);

    //extract the city name from firs placemark
    String? city = placemarks[0].locality;
    print('City: $city');
    print("Pobieranie lokalizacji zakończone");

    return [city ?? "", latitude, longitude];
  }

  /*Future<String> getCurrentCity() async {
    //Permision for use location
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert location to list of placemarks
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    print(position.latitude);
    print(position.longitude);

    //extract the city name from firs placemark
    String? city = placemarks[0].locality;
    print('City: $city');

    return city ?? "";
  }*/
}
