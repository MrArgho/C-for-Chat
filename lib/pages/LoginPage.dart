import 'package:c_for_chat/models/UserModel.dart';
import 'package:c_for_chat/pages/SignUpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_for_chat/pages/HomePage.dart';

import '../models/UIHelper.dart';

//66@gmail.com 123456

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == ""){
      UIHelper.showAlertDialog(context, "Error404...!", "Please fill all the fields :)");  //showing Alert_Dialog
      //print("Please fill all the fields :)");
    }
    else{
      logIn(email,password);
    }
  }

  void logIn(String email,String password) async {

    UIHelper.showLoadingDialog(context,"Loggin In...");

    UserCredential? credential;
    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(ex){
      Navigator.pop(context); //for closing/not showing the Loading dialog
      UIHelper.showAlertDialog(context, "Error404...!", ex.message.toString());  //showing Alert_Dialog

      //print(ex.message.toString());
    }

    if(credential!=null){
      String uid=credential.user!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

      print("LOGIN successful");
      Navigator.popUntil(context, (route) => route.isFirst);  //appbar er backButton remove korar jnno
      //go to homePage()
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context){
                return HomePage(userModel:userModel, firebaseUser: credential!.user!);
              }
          )
      );
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
                      //color: Theme.of(context).colorScheme.secondary,
                        color: Colors.blueGrey[900],
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
                  SizedBox(height: 30,),
                  CupertinoButton(
                    onPressed: (){
                      checkValues();
                    },
                    //color: Theme.of(context).colorScheme.secondary,
                    color: Colors.blueGrey[900],
                    child: Text("LOGIN"),
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
              "Don't have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context){
                      return SignUpPage();
                    }
                  )
                );
              },
              child: Text(
                "Register Now",
                style: TextStyle(
                  fontSize: 16,
                  //color: Colors.blueGrey[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
