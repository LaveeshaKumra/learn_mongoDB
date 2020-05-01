import 'package:flutter/material.dart';
import 'dart:async';
import 'package:learningapp/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   @override
   void initState(){
     super.initState();
     _function().then(
         (status){
           _navigatetohome();
         }
     );
   }
  Future<bool> _function() async{
    await Future.delayed(Duration(milliseconds: 3000),(){});
    return true;
}
  
  void _navigatetohome() async{
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context)=>MyHomePage()
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child:new Image.asset('assets/images/splash.png',width: 200,),
        ),
      ),
    );
  }
}
