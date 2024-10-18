class HomeModel {
  Response? response;

  HomeModel({
    this.response,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
      );
}

class Response {
  List<Datum>? data;

  Response({
    this.data,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  PortalData? portalData;

  Datum({
    this.portalData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        portalData: json["portalData"] == null
            ? null
            : PortalData.fromJson(json["portalData"]),
      );
}

class PortalData {
  List<SelfVsUnitparentId>? selfVsUnitparentId;

  PortalData({
    this.selfVsUnitparentId,
  });

  factory PortalData.fromJson(Map<String, dynamic> json) => PortalData(
        selfVsUnitparentId: json["SelfVsUnitparentId"] == null
            ? []
            : List<SelfVsUnitparentId>.from(json["SelfVsUnitparentId"]!
                .map((x) => SelfVsUnitparentId.fromJson(x))),
      );
}

class SelfVsUnitparentId {
  String? recordId;
  String? selfVsUnitparentIdUnit;
  String? selfVsUnitparentIdLevelKey;
  String? selfVsUnitparentIdNumNextLevel;
  String? modId;

  SelfVsUnitparentId({
    this.recordId,
    this.selfVsUnitparentIdUnit,
    this.selfVsUnitparentIdLevelKey,
    this.selfVsUnitparentIdNumNextLevel,
    this.modId,
  });

  factory SelfVsUnitparentId.fromJson(Map<String, dynamic> json) =>
      SelfVsUnitparentId(
        recordId: json["recordId"],
        selfVsUnitparentIdUnit: json["SelfVsUnitparentId::unit"],
        selfVsUnitparentIdLevelKey: json["SelfVsUnitparentId::levelKey"],
        selfVsUnitparentIdNumNextLevel:
            json["SelfVsUnitparentId::numNextLevel"],
        modId: json["modId"],
      );
}
