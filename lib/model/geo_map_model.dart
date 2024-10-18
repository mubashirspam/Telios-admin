// To parse this JSON data, do
//
//     final assetMapModel = assetMapModelFromJson(jsonString);

import 'dart:convert';

GeoMapModel geoMapModelFromJson(String str) => GeoMapModel.fromJson(json.decode(str));

String geoMapModelToJson(GeoMapModel data) => json.encode(data.toJson());

class GeoMapModel {
    String? type;
    String? name;
    Crs? crs;
    List<Feature>? features;

    GeoMapModel({
        this.type,
        this.name,
        this.crs,
        this.features,
    });

    factory GeoMapModel.fromJson(Map<String, dynamic> json) => GeoMapModel(
        type: json["type"],
        name: json["name"],
        crs: json["crs"] == null ? null : Crs.fromJson(json["crs"]),
        features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "crs": crs?.toJson(),
        "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
    };
}

class Crs {
    String? type;
    CrsProperties? properties;

    Crs({
        this.type,
        this.properties,
    });

    factory Crs.fromJson(Map<String, dynamic> json) => Crs(
        type: json["type"],
        properties: json["properties"] == null ? null : CrsProperties.fromJson(json["properties"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties?.toJson(),
    };
}

class CrsProperties {
    String? name;

    CrsProperties({
        this.name,
    });

    factory CrsProperties.fromJson(Map<String, dynamic> json) => CrsProperties(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Feature {
    String? type;
    FeatureProperties? properties;
    Geometry? geometry;

    Feature({
        this.type,
        this.properties,
        this.geometry,
    });

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        properties: json["properties"] == null ? null : FeatureProperties.fromJson(json["properties"]),
        geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties?.toJson(),
        "geometry": geometry?.toJson(),
    };
}

class Geometry {
    String? type;
    List<List<List<List<double>>>>? coordinates;

    Geometry({
        this.type,
        this.coordinates,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: json["coordinates"] == null ? [] : List<List<List<List<double>>>>.from(json["coordinates"]!.map((x) => List<List<List<double>>>.from(x.map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x?.toDouble())))))))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))))),
    };
}

class FeatureProperties {
    int? fid;
    String? level0Id;
    String? level0;
    String? level1;
    String? level2;
    String? level3;
    String? level4;
    String? level1Id;
    String? level2Id;
    String? level3Id;
    String? level4Id;
    String? labal;

    FeatureProperties({
        this.fid,
        this.level0Id,
        this.level0,
        this.level1,
        this.level2,
        this.level3,
        this.level4,
        this.level1Id,
        this.level2Id,
        this.level3Id,
        this.level4Id,
        this.labal,
    });

    factory FeatureProperties.fromJson(Map<String, dynamic> json) => FeatureProperties(
        fid: json["fid"],
        level0Id: json["Level0_id"],
        level0: json["Level0"],
        level1: json["Level1"],
        level2: json["Level2"],
        level3: json["Level3"],
        level4: json["Level4"],
        level1Id: json["Level1_id"],
        level2Id: json["Level2_id"],
        level3Id: json["Level3_id"],
        level4Id: json["Level4_id"],
        labal: json["Labal"],
    );

    Map<String, dynamic> toJson() => {
        "fid": fid,
        "Level0_id": level0Id,
        "Level0": level0,
        "Level1": level1,
        "Level2": level2,
        "Level3": level3,
        "Level4": level4,
        "Level1_id": level1Id,
        "Level2_id": level2Id,
        "Level3_id": level3Id,
        "Level4_id": level4Id,
        "Labal": labal,
    };
}
