import 'dart:convert';

class City {
  final String name;
  final Object localNames;
  final double lat;
  final double lon;
  final String country;

  City({this.name, this.localNames, this.lat, this.lon, this.country});

  static List<City> cityFromApi(Map<String, dynamic> body) {
    List<City> l = [];
    // Le body API nous retourne 4 noeud dont un qui est intéressant : results
    List<dynamic> results = body["body"];
    results.forEach((value) {
      City city = City(
        name: value["name"],
        localNames: value["local_names"],
        lat: value["lat"],
        lon: value["lon"],
        country: value["country"],
      );

      l.add(city);
    });
    return l;
  }
}
