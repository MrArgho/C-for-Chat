import 'package:c_for_chat/models/FirebaseHelper.dart';
import 'package:c_for_chat/models/UserModel.dart';
import 'package:c_for_chat/pages/CompleteProfile.dart';
import 'package:c_for_chat/pages/LoginPage.dart';
import 'package:c_for_chat/pages/SignUpPage.dart';
import 'package:c_for_chat/pages/Splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:c_for_chat/pages/HomePage.dart';
import 'package:uuid/uuid.dart';
//66@gmail.com 123456
//59@gmail.com 123456
//athoy@gmail.com 123456
//flutter build apk --split-per-abi
//Built build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk (9.1MB).


var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser = FirebaseAuth.instance.currentUser;

  if(currentUser!=null){
    //already logged in
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel!=null){
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    }
    else{
      runApp(MyApp());
    }
  }
  else{
    //not loggedIn
    runApp(MyApp());
  }

}

//not logged in? then open LoginPage()
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

//already loggedIn? then open HomePage()
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({super.key, required this.userModel, required this.firebaseUser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}


