import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:telios_admin/main.dart';
import 'package:telios_admin/settings/constants.dart';

import '../model/model.dart';

final currentToken = ValueNotifier<String?>(null);

class Repository {
  Future<void> saveToken(String token) async {
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    return prefs.getString('token');
  }

  Future<void> saveTokenExpiration(DateTime expirationTime) async {
    await prefs.setString("tokenExp", expirationTime.toIso8601String());
  }

  Future<DateTime?> getTokenExpiration() async {
    final expirationString = prefs.getString("tokenExp");
    return expirationString != null ? DateTime.parse(expirationString) : null;
  }

  Future<bool> isTokenExpired() async {
    final expiration = await getTokenExpiration();
    return expiration == null || DateTime.now().isAfter(expiration);
  }

  Future<void> initializeToken() async {
    try {
      var headers = {
        'Authorization': 'Basic $token==',
        'Content-Type': 'application/json'
      };

      final response = await Dio()
          .post(Api.initializeToken, options: Options(headers: headers));

      if (response.statusCode == 200) {
        final tokenData = response.data['response']['token'];
        if (tokenData != null) {
          await saveToken(tokenData);
          await saveTokenExpiration(
              DateTime.now().add(const Duration(minutes: 14)));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> refreshTokenIfNeeded() async {
    final token = await getToken();
    final isExpired = await isTokenExpired();
    if (token == null || token.isEmpty || isExpired) {
      await initializeToken();
    } else {
      currentToken.value = token;
    }
  }

  Future<T> executeWithTokenRefresh<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await initializeToken();
        return await apiCall();
      }
      rethrow;
    }
  }

  Future<RemoteMapLevelModel?> fetchMap(
      {required String levelId, required String token}) async {
    try {
      log('API call => ${Api.mapLevel}');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final data = json.encode({
        "query": [
          {"levelKey": "==$levelId"}
        ]
      });

      final response = await Dio().request(Api.mapLevel,
          options: Options(method: 'POST', headers: headers), data: data);

      if (response.statusCode == 200) {
        return RemoteMapLevelModel.fromJson(response.data);
      }
      return null;
    } catch (e, stackTrace) {
      log('Error occurred while fetching map levels: $e',
          stackTrace: stackTrace);
      return null;
    }
  }

  Future<HomeModel?> fetcHome(
      {required String levelId, required String token}) async {
    try {
      log('API call => ${Api.home}');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var data = json.encode({
        "query": [
          {"levelKey": "==$levelId"}
        ]
      });

      final response = await Dio().request(Api.home,
          options: Options(method: 'POST', headers: headers), data: data);

      if (response.statusCode == 200) {
        return HomeModel.fromJson(response.data);
      }
      return null;
    } catch (e, stackTrace) {
      log('Error occurred while fetching map levels: $e',
          stackTrace: stackTrace);
      return null;
    }
  }

  Future<List<MapLevel>> convertMapLevelRemoteToLocal({
    required RemoteMapLevelModel remoteData,
    required int id,
  }) async {
    final portalData =
        remoteData.response!.data!.first.portalData!.unitselfparent;

    return await Future.wait(portalData!.map((portal) async {
      return MapLevel(
        levelName: portal.unitselfparentUnit,
        levelKey: portal.unitselfparentLevelKey,
        geoJson: portal.unitGeoJsonidGeoJson,
        nextLevelCount: int.tryParse(portal.unitselfparentNumNextLevel ?? '0'),
        nextLevels:
            await convertGeojsontoSurveyLevel(portal.unitGeoJsonidGeoJson!, id),
      );
    }).toList());
  }

  Future<List<SurveyLevel>> convertGeojsontoSurveyLevel(
      String geoJson, int id) async {
    final features = geoMapModelFromJson(geoJson).features;

    if (features != null && features.isNotEmpty) {
      return features.map((feature) {
        final p = feature.properties;

        String geoJsonLevelKey = '';
        String geoJsonLevelName = '';
        String levelName = '';
        String levelKey = '';
        String assignedLevelKey = '';
        String assignedLevelName = '';

        switch (id) {
          case 1:
            geoJsonLevelKey = p?.level1Id ?? "";
            geoJsonLevelName = p?.level1 ?? "";
            levelName = p?.level2 ?? "";
            levelKey = p?.level2Id ?? "";
            assignedLevelKey = p?.level0Id ?? "";
            assignedLevelName = p?.level0 ?? "";
            break;
          case 2:
            geoJsonLevelKey = p?.level2Id ?? "";
            geoJsonLevelName = p?.level2 ?? "";
            levelName = p?.level3 ?? "";
            levelKey = p?.level3Id ?? "";
            assignedLevelKey = p?.level1Id ?? "";
            assignedLevelName = p?.level1 ?? "";
            break;
          case 3:
            geoJsonLevelKey = p?.level3Id ?? "";
            geoJsonLevelName = p?.level3 ?? "";
            levelName = p?.level4 ?? "";
            levelKey = p?.level4Id ?? "";
            assignedLevelKey = p?.level2Id ?? "";
            assignedLevelName = p?.level2 ?? "";
            break;
          // Add more cases as needed
          default:
            geoJsonLevelKey = p?.level3Id ?? "";
            geoJsonLevelName = p?.level3 ?? "";
            levelName = p?.level4 ?? "";
            levelKey = p?.level4Id ?? "";
            assignedLevelKey = p?.level2Id ?? "";
            assignedLevelName = p?.level2 ?? "";
            break;
        }

        return SurveyLevel(
          geoJsonLevelKey: geoJsonLevelKey,
          geoJsonLevelName: geoJsonLevelName,
          levelName: levelName,
          levelKey: levelKey,
          assignedLevelKey: assignedLevelKey,
          assignedLevelName: assignedLevelName,
          geoJson: '',
        );
      }).toList();
    }

    return [];
  }
}
