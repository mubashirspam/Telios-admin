import 'package:telios_admin/model/model.dart';

class MapLevel {
  String? levelName;
  String? levelKey;
  int? nextLevelCount;
  String? geoJson;
  List<SurveyLevel>? nextLevels;

  MapLevel({
    this.levelName,
    this.levelKey,
    this.geoJson,
    this.nextLevelCount,
    this.nextLevels,
  });

  MapLevel copyWith({
    String? levelName,
    String? levelKey,
    String? geoJson,
    List<SurveyLevel>? nextLevels,
    int? nextLevelCount,
  }) =>
      MapLevel(
        levelName: levelName ?? this.levelName,
        levelKey: levelKey ?? this.levelKey,
        geoJson: geoJson ?? this.geoJson,
        nextLevelCount: nextLevelCount ?? this.nextLevelCount,
        nextLevels: nextLevels ?? this.nextLevels,
      );
}

