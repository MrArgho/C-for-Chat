import 'dart:io';
import 'dart:math';
import 'dart:developer' as devlog;
import 'package:c_for_chat/models/UserModel.dart';
import 'package:c_for_chat/pages/SignUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_for_chat/pages/HomePage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../models/UIHelper.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile({super.key, required this.userModel, required this.firebaseUser});


  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  File? imageFile;
  TextEditingController fullNameController=TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if(pickedFile!=null){
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 10,
    );
    //CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: file.path);
    //File(croppedImage);
    //File imageFile = File(croppedFile.path);
    if(croppedImage!=null){
      setState(() {
        imageFile=croppedImage;
      });
    }

  }

  void showPhotoOptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo_album),
              title: Text("Select from Gallery"),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt_rounded),
              title: Text("Take a Photo"),
            ),
          ],
        ),
      );
    });
  }

  void checkValues(){
    String fullname  = fullNameController.text.trim();
    if(fullname=="" || imageFile==null){
      UIHelper.showAlertDialog(context, "Error404...!", "Please Submit all requirements :)");  //showing Alert_Dialog
      print("Please Submit all requirements :)");
    }
    else{
      devlog.log("uploading..... :)",name:'MyLog');
      uploadData();
    }
  }

  void uploadData() async{
    UIHelper.showLoadingDialog(context,"Uploading Data...");

    UploadTask uploadTask = FirebaseStorage.instance.ref("profilepictures").child(widget.userModel.uid.toString()).putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value) {
      devlog.log("pic uploaded ...  :)",name:'MyLog');
      //go to homePage()
      Navigator.popUntil(context,(route)=> route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context){
                return HomePage(userModel:widget.userModel, firebaseUser: widget.firebaseUser);
              }
          )
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("CompleteProfile"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              SizedBox(height: 25,),
              CupertinoButton(
                onPressed: (){
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: (imageFile != null ) ? FileImage(imageFile!) : null,
                  child: (imageFile == null ) ? Icon(Icons.person_4, size: 60,): null,
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              SizedBox(height: 20,),
              CupertinoButton(
                onPressed: (){
                  checkValues();
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Update"),
              )
            ],
          ),
        ),
      )

    );
  }
}

