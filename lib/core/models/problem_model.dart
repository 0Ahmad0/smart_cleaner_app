import 'package:cloud_firestore/cloud_firestore.dart';

import 'file_model.dart';
import 'location_model.dart';

class ProblemModel {
  String? id;
  String? description;
  String? idUser;
  DateTime? sendingTime;
  List<FileModel>? files;
  List<LocationModel>? locations;
  ProblemModel(
      {this.id,
        this.sendingTime,
        this.idUser,
        this.description,
        this.files,
        this.locations
      });
  factory ProblemModel.fromJson( json){
    var data = ['_JsonDocumentSnapshot','_JsonQueryDocumentSnapshot'].contains(json.runtimeType.toString())?json.data():json;

    List<FileModel> tempList = [];
    List<LocationModel> tempListLocations = [];
    for(var file in data["files"]){
      tempList.add(FileModel.fromJson(file));
    }
    for(var location in data["locations"]){
      tempListLocations.add(LocationModel.fromJson(location));
    }
    return ProblemModel(
      id:  data["id"],
      files:  tempList,
      locations:  tempListLocations,
      idUser:  data["idUser"],

      sendingTime:  data["sendingTime"]?.toDate(),
    );
  }
  Map<String,dynamic> toJson() {
    List<Map<String, dynamic>> tempList = [];
    List<Map<String, dynamic>> tempListLocations = [];
    for(FileModel file in files??[]){
      tempList.add(file.toJson());
    }
    for(LocationModel location in locations??[]){
      tempListLocations.add(location.toJson());
    }

    return {
      'sendingTime': sendingTime==null?null:Timestamp.fromDate(sendingTime!),
      'id': id,
      'idUser': idUser,
      'files': tempList,
      'locations': tempListLocations,
    };
  }
  factory ProblemModel.init(){
    return ProblemModel(files: [],locations: []);
  }
}
//Problems
class Problems {
  List<ProblemModel> items;



  Problems({required this.items});

  factory Problems.fromJson(json) {
    List<ProblemModel> temp = [];
    for (int i = 1; i < json.length; i++) {
      ProblemModel tempElement = ProblemModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Problems(items: temp);
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