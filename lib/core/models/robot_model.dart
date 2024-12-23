import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../enums/enums.dart';
import 'file_model.dart';
import 'location_model.dart';

class RobotModel {
  String? id;
  // int? id;
  double? pressure;
  double? air_quality;
  double? temperature;
  String? name;
  LocationModel? location;
  LocationModel? startPoint;
  LocationModel? endPoint;
  bool mode=false;
  bool isCharged=false;
  bool isDumping=false;
  String?  powerCommand;
  RobotModel(
      {this.id,
        this.pressure,
        this.air_quality,
        this.temperature,
        this.name,
        this.location,
        this.endPoint,
        this.startPoint,
        this.powerCommand,
        this.mode=false,
        this.isCharged=false,
        this.isDumping=false,
      });

  PowerCommand get getState{
    return PowerCommand.values.where((element)=>powerCommand?.toLowerCase().contains(element.name.toLowerCase())??false).firstOrNull??PowerCommand.stop;
  }
  factory RobotModel.fromJson( json){
    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;
    
    return RobotModel(
      id:  data["id"],
      pressure: double.tryParse("${data["pressure"]}")  ,
      air_quality: double.tryParse("${data["air_quality"]}")  ,
      temperature: double.tryParse("${data["temperature"]}")  ,
      name:  data["name"],
      powerCommand:  data["power_command"],
      location:  data["location"]==null?null:LocationModel.fromJsonReal( data["location"]),
      startPoint:  data["startPoint"]==null?null:LocationModel.fromJsonReal( data["startPoint"]),
      endPoint:  data["endPoint"]==null?null:LocationModel.fromJsonReal( data["endPoint"]),
      mode:  data["mode"]??false,
      isCharged:  data["isCharged"]??false,
      isDumping:  data["isDumping"]??false,
    );
  }
  Map<String,dynamic> toJson() {
   

    return {
     // 'id': id,
      'pressure': pressure,
      'air_quality': air_quality,
      'temperature': temperature,
      'name': name,
      'power_command': powerCommand,
      'location': location?.toJsonReal(),
      'startPoint': startPoint?.toJsonReal(),
      'endPoint': endPoint?.toJsonReal(),
      'mode': mode,
      'isCharged': isCharged,
      'isDumping': isDumping,
    };
  }
  factory RobotModel.init(){
    return RobotModel();
  }
}
//Robots
class Robots {
  List<RobotModel> items;



  Robots({required this.items});

  factory Robots.fromJson(json) {
    List<RobotModel> temp = [];
    for (int i = 1; i < json.length; i++) {
      RobotModel tempElement = RobotModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Robots(items: temp);
  }

  factory Robots.fromJsonReal(Iterable<DataSnapshot> json) {
    List<RobotModel> tempModels = [];

    for (int i = 0; i < json.length; i++) {
      RobotModel tempUserModel =
      RobotModel.fromJson(json.elementAt(i).value);
      tempUserModel.id=json.elementAt(i).key;
      tempModels.add(tempUserModel);
    }
    return Robots(items: tempModels);
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