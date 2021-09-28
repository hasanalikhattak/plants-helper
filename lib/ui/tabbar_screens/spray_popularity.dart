import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fruit_disease/helpers/constants.dart';
import 'package:fruit_disease/model/disease_info.dart';
import 'package:fruit_disease/model/spray_popularity_model.dart';
import 'package:fruit_disease/widgets/bar_chart.dart';
import 'package:get/get.dart';

class SprayPopularityController extends GetxController {
  RxList<SprayPopularityModel> sprayPopularityList =
      <SprayPopularityModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    DataSnapshot snapshot = await database.child("info").once();

    if (snapshot.exists) {
      for (var key in snapshot.value.entries) {
        for (var key2 in key.value.entries) {
          print("diseaseName: ${key2.key}");

          SprayPopularityModel sprayPopularityModel = SprayPopularityModel();
          sprayPopularityModel.diseaseName = key2.key;

          List<double> insecticideRatings = [];
          List<double> pesticideRatings = [];

          for (var key3 in key2.value.entries) {
            if (key3.key.toLowerCase().contains("insect")) {
              for (var key4 in key3.value.entries) {
                DiseaseInfo diseaseInfo = DiseaseInfo.fromJson(key4.value);
                insecticideRatings
                    .add(diseaseInfo.treatmentSatisfactionRating!);
              }
            } else {
              for (var key4 in key3.value.entries) {
                DiseaseInfo diseaseInfo = DiseaseInfo.fromJson(key4.value);
                pesticideRatings.add(diseaseInfo.treatmentSatisfactionRating!);
              }
            }
          }

          sprayPopularityModel.insecticideAvg =
              insecticideRatings.reduce((a, b) => a + b) /
                  insecticideRatings.length;
          sprayPopularityModel.pesticideAvg =
              pesticideRatings.reduce((a, b) => a + b) /
                  pesticideRatings.length;

          sprayPopularityList.add(sprayPopularityModel);
        }
      }
    }
  }
}

class SprayPopularity extends StatelessWidget {
  SprayPopularity({Key? key}) : super(key: key);

  final SprayPopularityController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return _buildDiseaseList();
  }

  Widget _buildDiseaseList() {
    return Obx(
      () => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.sprayPopularityList.length,
          itemBuilder: (context, index) {
            List<ChartModel> chartModelList = [];
            chartModelList.add(ChartModel("Pesticide",
                controller.sprayPopularityList.value[index].pesticideAvg));
            chartModelList.add(ChartModel("Insecticide",
                controller.sprayPopularityList.value[index].insecticideAvg));

            return Card(
              elevation: 5.0,
              margin: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    controller.sprayPopularityList.value[index].diseaseName!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      chartModelList: chartModelList,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
