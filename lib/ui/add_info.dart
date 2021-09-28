import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fruit_disease/helpers/constants.dart';
import 'package:fruit_disease/helpers/utils.dart';
import 'package:fruit_disease/model/disease_info.dart';
import 'package:fruit_disease/ui/home.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AddInfoController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxDouble satisfactionRating = 0.5.obs;
  RxString selectedChosenTreatment = "".obs;
  LocationData? currentLocation;

  @override
  void onInit() {
    getUserCurrentLocation().then((value) {
      currentLocation = value;
      print(value);
    });
    super.onInit();
  }
}

class AddInfo extends StatelessWidget {
  AddInfo({Key? key}) : super(key: key);

  final fruitNameController = TextEditingController();
  final detectedDiseaseController = TextEditingController();

  // final AddInfoController? controller;
  // final AddInfoController controller = Get.put(AddInfoController());
  final AddInfoController controller = Get.find();

  //TODO: Store latlng, datetime, and device id i.e. farmerID on runtime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Entry"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: fruitNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Fruit Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: detectedDiseaseController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Detected Disease",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              items: <String>['Pesticide', 'Insecticide'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Chosen Treatment",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              onChanged: (selectedVal) {
                controller.selectedChosenTreatment.value = selectedVal!;
              },
            ),
            SizedBox(
              height: 20,
            ),
            _buildDisplaySelectedDate(context),
            SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              initialRating: controller.satisfactionRating.value,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                controller.satisfactionRating.value = rating;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (fruitNameController.text.trim().isNotEmpty &&
                    detectedDiseaseController.text.trim().isNotEmpty &&
                    controller.selectedChosenTreatment.value.isNotEmpty) {
                  database
                      .child("info")
                      // .child(await getDeviceUID())
                      .child(fruitNameController.text.trim())
                      .child(detectedDiseaseController.text.trim())
                      .child(controller.selectedChosenTreatment.value)
                      .push()
                      .set(DiseaseInfo(
                              farmerID: await getDeviceUID(),
                              fruitName: fruitNameController.text.trim(),
                              chosenTreatment:
                                  controller.selectedChosenTreatment.value,
                              dateTime: DateTime.now(),
                              detectedDisease:
                                  detectedDiseaseController.text.trim(),
                              latitude: controller.currentLocation!.latitude,
                              longitude: controller.currentLocation!.longitude,
                              treatmentDate: controller.selectedDate.value,
                              treatmentSatisfactionRating:
                                  controller.satisfactionRating.value)
                          .toJson())
                      .then((value) => Get.offAll(() => HomePage()));
                } else {
                  Get.defaultDialog(
                      title: "Error", middleText: "All fields are required");
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDisplaySelectedDate(BuildContext context) {
    // DOB as a date picker with format dd-mm-yyyy
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('dd-MM-yyyy').format(controller.selectedDate.value)),
          SizedBox(
            width: 20.0,
          ),
          ElevatedButton(
            child: Text("Set Treatment Date"),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // date selection function

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != controller.selectedDate.value)
      controller.selectedDate.value = picked;
  }
}
