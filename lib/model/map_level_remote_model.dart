class RemoteMapLevelModel {
  MapResponse? response;

  RemoteMapLevelModel({
    this.response,
  });

  factory RemoteMapLevelModel.fromJson(Map<String, dynamic> json) =>
      RemoteMapLevelModel(
        response: json["response"] == null
            ? null
            : MapResponse.fromJson(json["response"]),
      );
}

class MapResponse {
  List<MapDatum>? data;

  MapResponse({
    this.data,
  });

  factory MapResponse.fromJson(Map<String, dynamic> json) => MapResponse(
        data: json["data"] == null
            ? []
            : List<MapDatum>.from(
                json["data"]!.map((x) => MapDatum.fromJson(x))),
      );
}

class MapDatum {
  MapFieldData? fieldData;
  MapPortalData? portalData;


  MapDatum({
    this.fieldData,
    this.portalData,
  
  });

  factory MapDatum.fromJson(Map<String, dynamic> json) => MapDatum(
        fieldData: json["fieldData"] == null
            ? null
            : MapFieldData.fromJson(json["fieldData"]),
        portalData: json["portalData"] == null
            ? null
            : MapPortalData.fromJson(json["portalData"]),
      
      );
}

class MapFieldData {
  String? id;
  String? levelKey;
  String? countryId;
  String? countryLevelId;
  String? numNextLevel;
  String? unit;

  MapFieldData({
    this.id,
    this.levelKey,
    this.countryId,
    this.countryLevelId,
    this.numNextLevel,
    this.unit,
  });

  factory MapFieldData.fromJson(Map<String, dynamic> json) => MapFieldData(
        id: json["id"],
        levelKey: json["levelKey"],
        countryId: json["countryId"],
        countryLevelId: json["countryLevelId"],
        numNextLevel: json["numNextLevel"],
        unit: json["unit"],
      );
}

class MapPortalData {
  List<Unitselfparent>? unitselfparent;

  MapPortalData({
    this.unitselfparent,
  });

  factory MapPortalData.fromJson(Map<String, dynamic> json) => MapPortalData(
        unitselfparent: json["Unitselfparent "] == null
            ? []
            : List<Unitselfparent>.from(json["Unitselfparent "]!
                .map((x) => Unitselfparent.fromJson(x))),
      );
}

class Unitselfparent {
  String? recordId;
  String? unitselfparentId;
  String? unitselfparentLevelKey;
  String? unitselfparentUnit;
  String? unitselfparentCountryLevelId;
  String? unitselfparentNumNextLevel;
  String? unitGeoJsonidGeoJson;
  String? modId;

  Unitselfparent({
    this.recordId,
    this.unitselfparentId,
    this.unitselfparentLevelKey,
    this.unitselfparentUnit,
    this.unitselfparentCountryLevelId,
    this.unitselfparentNumNextLevel,
    this.unitGeoJsonidGeoJson,
    this.modId,
  });

  factory Unitselfparent.fromJson(Map<String, dynamic> json) => Unitselfparent(
        recordId: json["recordId"],
        unitselfparentId: json["Unitselfparent ::id"],
        unitselfparentLevelKey: json["Unitselfparent ::levelKey"],
        unitselfparentUnit: json["Unitselfparent ::unit"],
        unitselfparentCountryLevelId: json["Unitselfparent ::countryLevelId"],
        unitselfparentNumNextLevel: json["Unitselfparent ::numNextLevel"],
        unitGeoJsonidGeoJson: json["unitGeoJsonid::geoJson"],
        modId: json["modId"],
      );
}
