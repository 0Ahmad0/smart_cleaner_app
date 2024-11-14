import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../enums/enums.dart';
import 'file_model.dart';
import 'location_model.dart';

class WeatherModel {
  String? id;

  num? temperature;
  num? blackLineValue;
  num? distance;
  num? gasResistance;
  num? humidity;
  num? pressure;
  bool? motionDetected;
  DateTime? timestamp;
  WeatherModel(
      {this.id,
        this.temperature,
        this.blackLineValue,
        this.distance,
        this.gasResistance,
        this.humidity,
        this.pressure,
        this.motionDetected,
        this.timestamp,
      });


  factory WeatherModel.fromJson( json){
    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;
    DateTime? timestamp = json['timestamp']==null?null:DateTime.tryParse('${json['timestamp']}') ?? DateTime.now();
    return WeatherModel(
      id:  data["id"],
      temperature: double.tryParse("${data["Tempreture"]}")  ,
      blackLineValue: double.tryParse("${data["black_line_value"]}")  ,
      distance: double.tryParse("${data["distance"]}")  ,
      gasResistance: double.tryParse("${data["gas_resistance"]}")  ,
      humidity: double.tryParse("${data["humidity"]}")  ,
      pressure: double.tryParse("${data["pressure"]}")  ,
      motionDetected: data["motion_detected"]  ,
      timestamp: timestamp  ,

    );
  }
  Map<String,dynamic> toJson() {
   

    return {
     'id': id,
      'Tempreture': temperature,
      'black_line_value': blackLineValue,
      'distance': distance,
      'humidity': humidity,
      'gas_resistance': gasResistance,
      'pressure': pressure,
      'motion_detected':motionDetected ,
      'timestamp': (timestamp ?? DateTime.now()).toString(),
    };
  }
  factory WeatherModel.init(){
    return WeatherModel();
  }
}
//Weathers
class Weathers {
  List<WeatherModel> items;


  Weathers({required this.items});

  factory Weathers.fromJson(json) {
    List<WeatherModel> temp = [];
    for (int i = 1; i < json.length; i++) {
      WeatherModel tempElement = WeatherModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Weathers(items: temp);
  }

  factory Weathers.fromJsonReal(Iterable<DataSnapshot> json) {
    List<WeatherModel> tempModels = [];

    for (int i = 0; i < json.length; i++) {
      WeatherModel tempUserModel =
      WeatherModel.fromJson(json.elementAt(i).value);
      tempUserModel.id=json.elementAt(i).key;
      tempModels.add(tempUserModel);
    }
    return Weathers(items: tempModels);
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