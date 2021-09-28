import 'package:flutter/material.dart';
import 'package:fruit_disease/ui/add_info.dart';
import 'package:fruit_disease/ui/tabbar_screens/disease_map.dart';
import 'package:fruit_disease/ui/tabbar_screens/disease_timeline.dart';
import 'package:fruit_disease/ui/tabbar_screens/orchards_map.dart';
import 'package:fruit_disease/ui/tabbar_screens/spray_popularity.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () => Get.to(() => AddInfo()), icon: Icon(Icons.add)),
        ],
      ),
      body: DefaultTabController(
        length: 4,

        child: Scaffold(
          appBar: AppBar(
            title: Text('Plant Disease Analysis App'),
            bottom: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.black87,
              tabs: [
                Tab(
                    icon: Icon(Icons.shopping_basket_outlined),
                    text: "Orchards"),
                Tab(
                    icon: Icon(Icons.health_and_safety_outlined),
                    text: "Disease Spread"),
                Tab(
                    icon: Icon(Icons.info_outline_rounded),
                    text: "Spray Popularity"),
                Tab(
                    icon: Icon(Icons.timeline_outlined),
                    text: "Disease Timeline"),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              OrchardsMap(),
              DiseaseMap(),
              SprayPopularity(),
              DiseaseTimeline(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AddInfoController>(AddInfoController());
    Get.put<OrchardsMapController>(OrchardsMapController());
    Get.put<DiseaseMapController>(DiseaseMapController());
    Get.put<SprayPopularityController>(SprayPopularityController());
    Get.put<DiseaseTimelineController>(DiseaseTimelineController());
  }
}
