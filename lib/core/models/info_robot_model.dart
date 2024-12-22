import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../enums/enums.dart';
import 'file_model.dart';
import 'location_model.dart';

class InfoRobotModel {
  String? id;

  num? batteryLevel;
  num? remainingDistanceKm;
  num? remainingTimeHours;
  DateTime? timestamp;
  InfoRobotModel(
      {this.id,
        this.batteryLevel,
        this.remainingDistanceKm,
        this.remainingTimeHours,
        this.timestamp,
      });


  factory InfoRobotModel.fromJson( json){
    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;
    DateTime? timestamp = json['timestamp']==null?null:DateTime.tryParse('${json['timestamp']}') ?? DateTime.now();
    return InfoRobotModel(
      id:  data["id"],
      remainingTimeHours: num.tryParse("${data["remaining_time_hours"]}")  ,
      remainingDistanceKm: num.tryParse("${data["remaining_distance_km"]}")  ,
      batteryLevel: num.tryParse("${data["battery_level"]}")  ,

      timestamp: timestamp  ,

    );
  }
  Map<String,dynamic> toJson() {
   

    return {
     'id': id,
      'battery_level': batteryLevel,
      'remaining_distance_km': remainingDistanceKm,
      'remaining_time_hours':remainingTimeHours ,
      'timestamp': (timestamp ?? DateTime.now()).toString(),
    };
  }
  factory InfoRobotModel.init(){
    return InfoRobotModel();
  }
}
//InfoRobots
class InfoRobots {
  List<InfoRobotModel> items;


  InfoRobots({required this.items});

  factory InfoRobots.fromJson(json) {
    List<InfoRobotModel> temp = [];
    for (int i = 1; i < json.length; i++) {
      InfoRobotModel tempElement = InfoRobotModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return InfoRobots(items: temp);
  }

  factory InfoRobots.fromJsonReal(Iterable<DataSnapshot> json) {
    List<InfoRobotModel> tempModels = [];

    for (int i = 0; i < json.length; i++) {
      InfoRobotModel tempUserModel =
      InfoRobotModel.fromJson(json.elementAt(i).value);
      tempUserModel.id=json.elementAt(i).key;
      tempModels.add(tempUserModel);
    }
    return InfoRobots(items: tempModels);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> temp = [];
    for (var element in items) {
      temp.add(element.toJson());
    }
    return {
      'items': temp,
    };
  }
}