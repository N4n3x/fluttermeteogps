import 'package:flutter/material.dart';
import 'package:fluttermeteogps/pages/home.dart';
import 'package:location/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Location location = new Location();
  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  PermissionStatus _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  LocationData _locationData = await location.getLocation();
  print("${_locationData.latitude} ${_locationData.longitude}");

  runApp(MyApp(location: _locationData));
}

class MyApp extends StatelessWidget {
  final LocationData location;
  MyApp({this.location});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteo GPS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(location: location),
    );
  }
}
