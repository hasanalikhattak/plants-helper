import 'package:location/location.dart';

class DiseaseInfo {
  final String? farmerID;
  final String? fruitName;
  final String? detectedDisease;
  final String? chosenTreatment;
  final DateTime? treatmentDate;
  final double? treatmentSatisfactionRating;

  // final LocationData? geoLocation;
  final double? latitude;
  final double? longitude;
  final DateTime? dateTime;

  DiseaseInfo(
      {this.farmerID,
      this.fruitName,
      this.detectedDisease,
      this.chosenTreatment,
      this.treatmentDate,
      this.treatmentSatisfactionRating,
      this.latitude,
      this.longitude,
      this.dateTime});

  factory DiseaseInfo.fromJson(Map<dynamic, dynamic> parsedJson) {
    return DiseaseInfo(
      farmerID: parsedJson['farmerID'],
      fruitName: parsedJson['fruitName'],
      detectedDisease: parsedJson['detectedDisease'],
      chosenTreatment: parsedJson['chosenTreatment'],
      treatmentDate: DateTime.fromMillisecondsSinceEpoch(
          parsedJson['treatmentDate'] * 1000),
      treatmentSatisfactionRating:
          parsedJson['treatmentSatisfactionRating'].toDouble(),
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      dateTime:
          DateTime.fromMillisecondsSinceEpoch(parsedJson['dateTime'] * 1000),
    );
  }

  Map<String, dynamic> toJson() => {
        'farmerID': farmerID,
        'fruitName': fruitName,
        'detectedDisease': detectedDisease,
        'chosenTreatment': chosenTreatment,
        'treatmentDate': treatmentDate!.millisecondsSinceEpoch,
        'treatmentSatisfactionRating': treatmentSatisfactionRating,
        'latitude': latitude,
        'longitude': longitude,
        'dateTime': dateTime!.millisecondsSinceEpoch,
      };
}
