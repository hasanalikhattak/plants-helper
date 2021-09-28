import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fruit_disease/helpers/constants.dart';
import 'package:fruit_disease/helpers/utils.dart';
import 'package:fruit_disease/model/disease_info.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrchardsMapController extends GetxController {
  StreamSubscription<Event>? _orchardsSubscription;

  RxSet<Marker> orchardMarkersSet = Set<Marker>().obs;

  // var orchardMarkersSet = [].obs;

  @override
  void onInit() async {
    super.onInit();

    DataSnapshot snapshot = await database.child("info").once();

    if (snapshot.exists) {
      for (var key in snapshot.value.entries) {
        for (var key2 in key.value.entries) {
          for (var key3 in key2.value.entries) {
            for (var key4 in key3.value.entries) {
              print(key4.value);
              DiseaseInfo diseaseInfo = DiseaseInfo.fromJson(key4.value);
              orchardMarkersSet.add(Marker(
                  markerId: MarkerId(
                      DateTime.now().microsecondsSinceEpoch.toString()),
                  position:
                      LatLng(diseaseInfo.latitude!, diseaseInfo.longitude!),
                  infoWindow: InfoWindow(title: diseaseInfo.fruitName!)));
            }
          }
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    _orchardsSubscription?.cancel();
  }
}

class OrchardsMap extends StatelessWidget {
  OrchardsMap({Key? key}) : super(key: key);

  final OrchardsMapController controller = Get.find();

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(33.6424888, 72.993001),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: initialLocation,
          onMapCreated: (GoogleMapController controller) {
            mapController.complete(controller);
          },
          markers: controller.orchardMarkersSet.value,
        ),
      ),
    );
  }
}
