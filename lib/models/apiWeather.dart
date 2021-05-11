import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';

class ApiWeather {
  final String UrlReverse = "http://api.openweathermap.org/geo/1.0";
  final String UrlWeather = "http://api.openweathermap.org/data/2.5/";
  final String Key = "694609c3b4f1d4ec7d6a366375b5b1f6";
  final String Lang = "fr";

  Future<Map<String, dynamic>> getReverse(LocationData location) async {
    http.Response response;
    String completeUrl = UrlReverse +
        "/reverse?lat=${location.latitude}&lon=${location.longitude}&limit=5&appid=${Key}";
    response = await http.get(Uri.parse(completeUrl));
    Map<String, dynamic> map = {"code": 1, "body": ""};
    if (response.statusCode == 200) {
      //todo tester les # cas de figure retournée par l'API
      map["code"] = 0;
      map["body"] = jsonDecode(response.body);
    } else {
      map["code"] = 1;
      map["body"] = "Error http etc.";
    }
    return map;
  }

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    http.Response response;
    String completeUrl =
        UrlWeather + "weather?q=${cityName}&appid=${Key}&units=metric&lang=fr";
    print(completeUrl);
    response = await http.get(Uri.parse(completeUrl));
    Map<String, dynamic> map = {"code": 1, "body": ""};
    if (response.statusCode == 200) {
      //todo tester les # cas de figure retournée par l'API
      map["code"] = 0;
      map["body"] = jsonDecode(response.body);
    } else {
      map["code"] = 1;
      map["body"] = "Error http etc.";
    }
    return map;
  }
}
