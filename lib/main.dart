import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fruit_disease/helpers/constants.dart';
import 'package:fruit_disease/ui/add_info.dart';
import 'package:fruit_disease/ui/home.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  final FirebaseApp firebaseApp = await Firebase.initializeApp();
  database = FirebaseDatabase(
          app: firebaseApp,
          databaseURL:
              "https://fruitdisease-490ae-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .reference();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fruit Disease',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      initialRoute: "/",
      initialBinding: HomeBinding(),
    );
  }
}
