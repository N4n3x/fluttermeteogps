import 'package:flutter/material.dart';
import 'package:fluttermeteogps/models/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:fluttermeteogps/models/apiWeather.dart';
import 'package:fluttermeteogps/models/city.dart';
import 'package:fluttermeteogps/models/my_flutter_app_icons.dart';

class HomePage extends StatefulWidget {
  LocationData location;
  HomePage({this.location});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> villes = [];
  String villeChoisie;
  List<City> cities;
  Weather weather;
  String wpPath = "img/wait.png";
  String iconPath = "img/wait.png";

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    wallpaperFromWeather();
    obtenir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text("Météo GPS"),
        ),
        body: (weather != null)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(wpPath), fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      villeChoisie,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(weather.main.temp.toInt().toString() + " °C",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 70)),
                            Text(weather.weather.first.description,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50)),
                          ],
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: Image.asset(iconPath, fit: BoxFit.fill))
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Icon(MyFlutterApp.water),
                            Text(weather.main.humidity.toString())
                          ],
                        ),
                        Column(
                          children: [
                            Icon(MyFlutterApp.gauge),
                            Text(weather.main.pressure.toString())
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      child: Text("${widget.location.longitude}"),
                      onPressed: () {
                        ajouter("Rouen");
                      },
                    ),
                    ElevatedButton(
                      child: Text("Delete"),
                      onPressed: () {
                        supprimer("Rouen");
                      },
                    )
                  ],
                ),
              )
            : Center());
  }

  Future<String> addCurrentCity() async {
    ApiWeather api = ApiWeather();
    Map<String, dynamic> city = await api.getReverse(widget.location);
    if (city["code"] == 0) {
      List<City> res = City.cityFromApi(city);
      setState(() {
        cities = res;
        villes.add(cities[0].name);
        villeChoisie = cities[0].name;
        print(cities[0].name);
      });
      return res[0].name;
    }
    return "";
  }

  Future<void> getWeather() async {
    if (villeChoisie == null) await addCurrentCity();
    ApiWeather api = ApiWeather();
    Map<String, dynamic> city = await api.getWeather(villeChoisie);
    print(city);
    if (city["code"] == 0) {
      setState(() {
        weather = Weather.fromJson(city["body"]);
        print(weather);
      });
    }
  }

  String iconFromWeather() {}

  wallpaperFromWeather() async {
    if (weather == null) await getWeather();
    String path = "img/";
    if (weather.weather[0].icon.contains("d")) {
      if (weather.weather[0].icon.contains(RegExp(r'[1-3]'), 1)) {
        path = path + "d1.jpg";
      } else {
        path = path + "d2.jpg";
      }
    } else {
      path = path + "n.jpg";
    }
    setState(() {
      iconPath =
          "img/${weather.weather[0].icon.replaceAll("d", "").replaceAll("n", "")}.png";
      wpPath = path;
    });
  }

  void obtenir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> liste = prefs.getStringList("villes");
    if (liste != null) {
      setState(() {
        villes = liste;
      });
    }
  }

  void ajouter(String v) async {
    if (villes.contains(v)) {
      return;
    }
    villes.add(v);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("villes", villes);
    obtenir();
  }

  void supprimer(String value) async {
    villes.remove(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("villes", villes);
    obtenir();
  }
}
