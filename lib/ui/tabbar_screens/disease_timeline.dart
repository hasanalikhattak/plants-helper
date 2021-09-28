import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fruit_disease/helpers/constants.dart';
import 'package:fruit_disease/model/disease_info.dart';
import 'package:fruit_disease/widgets/line_chart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class DiseaseTimelineController extends GetxController {
  RxMap<String, int> cityWiseCasesCount = <String, int>{}.obs;

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

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  diseaseInfo.latitude!, diseaseInfo.longitude!);

              // print(placemarks[0]);

              cityWiseCasesCount[placemarks[0].locality!] =
                  (cityWiseCasesCount[placemarks[0].locality] ?? 0) + 1;
            }
          }
        }
      }
    }
  }
}

class DiseaseTimeline extends StatelessWidget {
  DiseaseTimeline({Key? key}) : super(key: key);

  final DiseaseTimelineController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        elevation: 5.0,
        margin: EdgeInsets.all(15.0),
        child: LineChart(
          lineChartDataList: controller.cityWiseCasesCount.value.entries
              .map((entry) => LineChartData(entry.key, entry.value.toDouble(),))
              .toList(),
        ),
      ),
    );
  }
}
