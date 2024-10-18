import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BaseUrl'];
final token = dotenv.env['Token'];
final version = dotenv.env['Version'];

class Api {
  static final v = '$baseUrl/$version/layouts';
  static final initializeToken = '$baseUrl/$version/sessions';
  static final mapLevel = '$v/geoJsonLevel/_find';
  static final home = '$v/countryBasedFilter/_find';
}
