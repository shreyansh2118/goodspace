import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:untitled2/pages/dashbaord.dart';
import 'package:untitled2/pages/phone%20number%20entering.dart';
import 'package:untitled2/pages/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Phone Number Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      // home: PhoneNumberAuthentication(),
      home: splashScreen1(),
    );
  }
}





