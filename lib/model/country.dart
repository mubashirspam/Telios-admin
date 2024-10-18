
List<Country> countries = [
  Country(
    id: 'IND',
    name: 'India',
    url: 'assets/states/ind.geojson',
    levels: {
      'State/Union Territory': 36,
      'District': 748,
      'Sub-district/Taluk': 6104,
      'Village/Ward': 649481,
      'Hamlet': 2000000,
    },
  ),
  Country(
    id: 'IDN',
    name: 'Indonesia',
    url: 'assets/states/Prakasam.geojson',
    levels: {
      'Province': 34,
      'Regency/City': 514,
      'District': 7183,
      'Village': 83471,
      'Hamlet': 100000,
    },
  ),

    Country(
    id: 'NGA',
    name: 'Nigeria',
    url: 'assets/states/Prakasam.geojson',
    levels: {
      'Province': 34,
      'Regency/City': 514,
      'District': 7183,
      'Village': 83471,
      'Hamlet': 100000,
    },
  ),


];

class Country {
  final String name;
  final String url;
  final String id;
  final Map<String, int> levels;

  Country({
    required this.name,
    required this.url,
    required this.levels,
    required this.id,
  });
}