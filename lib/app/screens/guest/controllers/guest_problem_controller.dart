

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cleaner_app/core/models/file_model.dart';
import 'package:smart_cleaner_app/core/models/location_model.dart';
import 'package:smart_cleaner_app/core/models/problem_model.dart';

import '../../../../core/widgets/constants_widgets.dart';
import '../../../controllers/firebase/firebase_constants.dart';
import '../../../controllers/firebase/firebase_fun.dart';
import '../../../controllers/profile_controller.dart';


class GuestProblemController extends GetxController{
  final formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController ;


  String? uid;
  ProblemModel? problem;
  int currentProgress=0;
  int fullProgress=0;

  @override
  void onInit() {
    problem=ProblemModel.init();
    ProfileController profileController=Get.put(ProfileController());
    uid= profileController.currentUser.value?.uid;

    descriptionController=TextEditingController( );
    // descriptionController=TextEditingController(text:person?.description );
    super.onInit();
    }


  addProblem(context,{bool withUserId=true}) async {
    // ConstantsWidgets.showProgress(progress);
    _calculateProgress(problem?.files?.length??0);
    Get.dialog(
      GetBuilder<GuestProblemController>(
          builder: (GuestProblemController controller) =>
              ConstantsWidgets.showProgress(controller.currentProgress/controller.fullProgress)
      ),
      barrierDismissible: false,
    );

    String description=descriptionController.value.text;
    String id= '${description}00000'.substring(0,5)+'${Timestamp.now().microsecondsSinceEpoch}';
    List<FileModel> files=[];
    for(FileModel fileModel in problem?.files??[]){
      if(fileModel.localUrl?.isNotEmpty??false){
        fileModel.url=await FirebaseFun.uploadImage(image:XFile(fileModel.localUrl??''),folder: FirebaseConstants.collectionProblem+'/$id');
        if(fileModel.url!=null){
          files.add(fileModel);
        }
      }
      _plusProgress();
    }
    // String? imagePath;
    // if(image!=null){
    //   imagePath=await FirebaseFun.uploadImage(image:image,folder: FirebaseConstants.collectionPerson+'/$name');
    // }
    ProblemModel problemModel=ProblemModel(
      id: id,
      description: descriptionController.value.text,
      files: files??[],
      locations: problem?.locations??[],
      sendingTime: DateTime.now(),
      idUser: withUserId?uid:null,

    );
    var result=await FirebaseFun.addProblem(problem:problemModel);

    ConstantsWidgets.closeDialog();
    if(result['status']){
      Get.back();
    }
    ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);
    return result;
  }
  addFile(XFile file,{PlatformFile? platformFile,String type=""}) async {
    problem?.files?.add(FileModel(
      name: file.name,
      localUrl: file.path,
      size:platformFile?.size?? await file.length(),
      type: type,
      subType:platformFile?.extension?? file.path.split('/').last.split('.').last
    ));
    update();
  }
  addLocation({required double longitude,required double latitude,String? address}) async {
    problem?.locations?.add(LocationModel(
      latitude:latitude ,
      longitude: longitude,
      address: address,
      dateTime: DateTime.now()
    ));


    update();
  }
  removeFile(FileModel file) async {
    problem?.files?.remove(file);
    update();
  }
  removeLocation(LocationModel location) async {
    problem?.locations?.remove(location);
    update();
  }

  _calculateProgress(int length){
    currentProgress=0;
    fullProgress=1;
    fullProgress+=length;
    update();
  }
  _plusProgress(){
    currentProgress++;
    if(currentProgress>fullProgress)
      currentProgress=fullProgress;
    update();
  }
  // updatePerson(context,{ XFile? image}) async {
  //   ConstantsWidgets.showLoading();
  //
  //   String name=nameController.value.text;
  //
  //   String? imagePath;
  //   if(image!=null){
  //     imagePath=await FirebaseFun.uploadImage(image:image,folder: FirebaseConstants.collectionPerson+'/$name');
  //   }
  //
  //   person?.name=name;
  //   person?.description= descriptionController.value.text;
  //  person?.imagePath=imagePath??person?.imagePath;
  //   person?.phoneNumber=phoneNumberController.value.text;
  //   person?.email=emailController.value.text;
  //   var
  //   result=await FirebaseFun.updatePerson(person:person!);
  //   ConstantsWidgets.closeDialog();
  //   // if(result['status'])
  //   //   Get.back();
  //   ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);
  //   return result;
  // }
  //


  // updateClassRoom(context,{required ClassRoomModel classRoom}) async {
  //   ConstantsWidgets.showLoading();
  //   var
  //   result=await FirebaseFun.updateClassRoom(classRoom:classRoom);
  //   Get.back();
  //   ConstantsWidgets.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()),state: result['status']);
  //   return result;
  // }




  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }


}
