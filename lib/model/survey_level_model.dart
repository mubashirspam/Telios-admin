class SurveyLevel {
  String? geoJsonLevelKey;
  String? geoJsonLevelName;
  String? levelName;
  String? levelKey;
  String? assignedLevelKey;
  String? assignedLevelName;
  String? geoJson;



  SurveyLevel({
    this.levelName,
    this.levelKey,
    this.geoJsonLevelKey,
    this.geoJsonLevelName,
    this.assignedLevelKey,
    this.assignedLevelName,
    this.geoJson,
  });

  SurveyLevel copyWith({
    String? geoJsonLevelKey,
    String? geoJsonLevelName,
    String? levelName,
    String? levelKey,
    String? assignedLevelKey,
    String? assignedLevelName,
    String? geoJson,
  }) =>
      SurveyLevel(
        geoJsonLevelKey: geoJsonLevelKey ?? this.geoJsonLevelKey,
        geoJsonLevelName: geoJsonLevelName ?? this.geoJsonLevelName,
        levelName: levelName ?? this.levelName,
        levelKey: levelKey ?? this.levelKey,
        assignedLevelKey: assignedLevelKey ?? this.assignedLevelKey,
        assignedLevelName: assignedLevelName ?? this.assignedLevelName,
        geoJson: geoJson ?? this.geoJson,
      );
}
