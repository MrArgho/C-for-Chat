import 'package:c_for_chat/models/UserModel.dart';
import 'package:c_for_chat/pages/CompleteProfile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_for_chat/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/UIHelper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController cPasswordController=TextEditingController();

  void checkValues(){
    String email=emailController.text.trim();
    String password= passwordController.text.trim();
    String cPassword=cPasswordController.text.trim();

    if(email=="" || password=="" || cPassword==""){
      UIHelper.showAlertDialog(context, "Error404...!", "Please fill all the fields :)");  //showing Alert_Dialog
      //print("Please fill all the fields :)");
    }
    else if(password!=cPassword){
      UIHelper.showAlertDialog(context, "Error404...!", "Passwords did not match  :)");  //showing Alert_Dialog
      //print("Passwords donot match :)");
    }
    else{
      signUp(email, password);
    }

  }

  void signUp(String email, String password) async {
    UIHelper.showLoadingDialog(context,"Creating new account...");
    UserCredential? credential;

    try{
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex){
      Navigator.pop(context);   //ei pop diye Loading dialog off hbe
      UIHelper.showAlertDialog(context, "Error404...!", ex.code.toString());  //showing Alert_Dialog
      //print(ex.code.toString());
    }

    if(credential != null){
      String uid = credential.user!.uid;
      UserModel newUser=UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        print("new user created :D");
        Navigator.popUntil(context,(route)=> route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context){
              return CompleteProfile(userModel:newUser, firebaseUser: credential!.user!);
            }
          )
        );
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "C for Chat",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText:"Email Address"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText:"Password"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText:" Confirm Password"
                    ),
                  ),
                  SizedBox(height: 30,),
                  CupertinoButton(
                    onPressed: (){
                      checkValues();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text("SIGNUP"),
                  )


                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
