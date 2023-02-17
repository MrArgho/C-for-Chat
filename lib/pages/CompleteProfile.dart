import 'package:c_for_chat/pages/SignUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_for_chat/pages/HomePage.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
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
                onPressed: (){},
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person_4, size: 60,),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              SizedBox(height: 20,),
              CupertinoButton(
                onPressed: (){},
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

