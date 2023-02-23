import 'package:c_for_chat/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async{
    await Future.delayed(Duration(seconds: 10),(){});
    Navigator.pushReplacement(
        context,
      MaterialPageRoute(builder: (context)=>LoginPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage("assets/icons200.png"),
              width: 160,
            ),
            Text(
              "C for Chat",
              style: TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontFamily: 'Pacifico',
              ),
            ),
            Text(
              "Beep! & you know it's Secure",
              style: TextStyle(
                color: Colors.black,
               // fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'TiltNeon',
              ),
            ),
            SizedBox(
              height: 150,
            ),
            SpinKitPouringHourGlassRefined(
              color: Colors.black,
              size: 60.0,
              //duration: Duration(microseconds: 1),
              //itemCount: 5,

            ),
          ],
        ),
      ),
    );
  }
}
