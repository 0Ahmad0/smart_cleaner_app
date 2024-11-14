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
  bool mode=false;
  RobotModel(
      {this.id,
        this.pressure,
        this.air_quality,
        this.temperature,
        this.name,
        this.location,
        this.mode=false,
      });


  factory RobotModel.fromJson( json){
    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;
    
    return RobotModel(
      id:  data["id"],
      pressure: double.tryParse("${data["pressure"]}")  ,
      air_quality: double.tryParse("${data["air_quality"]}")  ,
      temperature: double.tryParse("${data["temperature"]}")  ,
      name:  data["name"],
      location:  data["location"]==null?null:LocationModel.fromJson( data["location"]),
      mode:  data["mode"]??false,
    );
  }
  Map<String,dynamic> toJson() {
   

    return {
     'id': id,
      'pressure': pressure,
      'air_quality': air_quality,
      'temperature': temperature,
      'name': name,
      'location': location?.toJson(),
      'mode': mode,
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