import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  String? id;
  String? address;
  double? latitude;
  double? longitude;

  DateTime? dateTime;

  LocationModel(
      {
        this.id,
         this.address,
        this.latitude,
        this.longitude,
        this.dateTime,
      });

  factory LocationModel.fromJsonReal( json){


    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;
    DateTime? timestamp =json['timestamp']==null?null: DateTime.tryParse('${json['timestamp']}') ?? DateTime.now();
    return LocationModel(
      address: data["address"],
      latitude: double.tryParse("${json["Latitude"]??json["latitude"]}"),
      longitude: double.tryParse("${json["Longitude"]??json["longitude"]}"),
      dateTime: timestamp,

    );
  }
  LatLng get getPoint=>LatLng(latitude??0,longitude??0);
  factory LocationModel.fromJson( json){
    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;

    return LocationModel(
      address: data["address"],
      latitude: double.tryParse("${json["Latitude"]}"),
      longitude: double.tryParse("${json["Longitude"]}"),
      dateTime: data["timestamp"]?.toDate(),

    );
  }
  Map<String,dynamic> toJsonReal() {
    return {
      'id': id,
      'Latitude': latitude,
      'Longitude': longitude,
      'timestamp': (dateTime ?? DateTime.now()).toString(),
      // 'timestamp': dateTime==null?null:Timestamp.fromDate(dateTime!),
    };
  }
  Map<String,dynamic> toJson() {
    return {
      'id': id,
      'Latitude': latitude,
      'Longitude': longitude,
      'timestamp': dateTime==null?null:Timestamp.fromDate(dateTime!),
    };
  }
  factory LocationModel.init(){
    return LocationModel();
  }
}
//Locations
class Locations {
  List<LocationModel> items;



  Locations({required this.items});

  factory Locations.fromJson(json) {
    List<LocationModel> temp = [];
    for (int i = 1; i < json.length; i++) {
      LocationModel tempElement = LocationModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Locations(items: temp);
  }

  factory Locations.fromJsonReal(Iterable<DataSnapshot> json) {
    List<LocationModel> tempModels = [];

    for (int i = 0; i < json.length; i++) {
      LocationModel tempUserModel =
      LocationModel.fromJsonReal(json.elementAt(i).value);
      tempUserModel.id=json.elementAt(i).key;
      tempModels.add(tempUserModel);
    }
    return Locations(items: tempModels);
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


//Files
class Files {
  List<LocationModel> items;



  Files({required this.items});

  factory Files.fromJson(json) {
    List<LocationModel> temp = [];
    for (int i = 1; i < json.length; i++) {
      LocationModel tempElement = LocationModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Files(items: temp);
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