import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fruit_disease/helpers/constants.dart';
import 'package:fruit_disease/model/disease_info.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

class DiseaseMapController extends GetxController {
  StreamSubscription<Event>? _diseaseSubscription;

  RxSet<Marker> diseaseMarkersSet = Set<Marker>().obs;
  RxSet<Polygon> heatMapsSet = Set<Polygon>().obs;

  @override
  void onInit() async {
    super.onInit();

    DataSnapshot snapshot = await database.child("info").once();

    if (snapshot.exists) {
      for (var key in snapshot.value.entries) {
        List<LatLng> heatMapLatLng = [];

        for (var key2 in key.value.entries) {
          for (var key3 in key2.value.entries) {
            for (var key4 in key3.value.entries) {
              print(key4.value);
              DiseaseInfo diseaseInfo = DiseaseInfo.fromJson(key4.value);

              heatMapLatLng
                  .add(LatLng(diseaseInfo.latitude!, diseaseInfo.longitude!));
            }

            heatMapsSet.add(
              Polygon(
                polygonId:
                    PolygonId(DateTime.now().microsecondsSinceEpoch.toString()),
                points: heatMapLatLng,
                geodesic: true,
                strokeWidth: 2,
                strokeColor: Colors.red.withOpacity(0.35),
                fillColor: Colors.red.withOpacity(0.35),
                visible: true,
              ),
            );
          }
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    _diseaseSubscription?.cancel();
  }
}

class DiseaseMap extends StatelessWidget {
  DiseaseMap({Key? key}) : super(key: key);
  final DiseaseMapController controller = Get.find();

  final CameraPosition initialLocation = CameraPosition(
    // target: LatLng(33.6424888, 72.993001),
    target: LatLng(28.422842, 70.320663),
    zoom: 14.0,
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
          // markers: controller.diseaseMarkersSet.value,
          polygons: controller.heatMapsSet.value,
        ),
      ),
    );
  }
}
