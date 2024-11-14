//Notification
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String id;
  String? idUser;
  String? nameUser;
  DateTime? dateTime;
  String? subtitle;
  String title;
  bool checkSend;
  bool checkRec;
  ActivityModel({
    this.id="",
     this.idUser,
     this.nameUser,
    required this.subtitle,
    required this.dateTime,
    required this.title,
    this.checkSend=false,
    this.checkRec=false,
  });

  factory ActivityModel.fromJson(json) {
    return ActivityModel(
      id: json['id'],
      idUser: json['idUser'],
      nameUser: json['nameUser'],
      subtitle: json['subtitle'],
      title: json['title'],
      checkSend: json['checkSend'],
      checkRec: json['checkRec'],
      dateTime: json['dateTime']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUser': idUser,
      'subtitle': subtitle,
      'title': title,
      'nameUser': nameUser,
      'checkSend': checkSend,
      'checkRec': checkRec,
      'dateTime': dateTime==null?null:Timestamp.fromDate(dateTime!),
    };
  }
  factory ActivityModel.init(){
    return ActivityModel( subtitle: '', dateTime: DateTime.now(), title: '',);
  }
}

//Activities
class Activities {

  List<ActivityModel> items;

  //DateTime date;
  Activities({
    required this.items});

  factory Activities.fromJson(json) {
    List<ActivityModel> temp = [];
    for (int i = 0; i < json.length; i++) {
      ActivityModel tempElement = ActivityModel.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Activities(
        items: temp);
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
  factory Activities.init()=>Activities(items: []);
}
