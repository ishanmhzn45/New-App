import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement
      (context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
     });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/splash_pic.jpg',
          fit: BoxFit.cover,
          height: height * .5,
          ),
          SizedBox(height: height * 0.04,),
          Text('TOP HEADLINES',
          style: GoogleFonts.anton(
            letterSpacing: .6, 
            color: Colors.grey.shade700
            ),
          ),
          SizedBox(height: height * 0.04,),
          const SpinKitChasingDots(
            color: Colors.blue,
            size: 40,
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(244, 245, 250, 1),
    );
  }
}