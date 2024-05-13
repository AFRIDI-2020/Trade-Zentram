class LocationsModel {
  int? statusCode;
  String? message;
  List<LocationDetails>? dataObj;

  LocationsModel({statusCode, message, dataObj});

  LocationsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['dataObj'] != null) {
      dataObj = <LocationDetails>[];
      json['dataObj'].forEach((v) {
        dataObj!.add(LocationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (dataObj != null) {
      data['dataObj'] = dataObj!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationDetails {
  int? locationId;
  String? locationName;
  String? locationThana;
  String? locationDistrict;

  LocationDetails(
      {locationId,
      locationName,
      locationThana,
      locationDistrict});

  LocationDetails.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    locationName = json['locationName'];
    locationThana = json['locationThana'];
    locationDistrict = json['locationDistrict'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['locationId'] = locationId;
    data['locationName'] = locationName;
    data['locationThana'] = locationThana;
    data['locationDistrict'] = locationDistrict;
    return data;
  }
}
