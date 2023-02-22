
import 'package:flutter/material.dart';

class UIHelper{
  static showLoadingDialog(BuildContext context, String title){
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize:MainAxisSize.min,
        children: [
          SizedBox(height: 10,),
          CircularProgressIndicator(),
          SizedBox(height: 15,),
          Text(title),
        ],
      ),
    );
    showDialog(context: context,barrierDismissible: false, builder: (context){
      return loadingDialog;
    });
  }

  static void showAlertDialog(BuildContext context, String title, String content){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    );
    showDialog(context: context, builder: (context){
    return alertDialog;
    });
  }

}