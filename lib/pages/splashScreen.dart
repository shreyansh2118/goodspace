
import 'package:flutter/material.dart';
import 'phone number entering.dart';


class splashScreen1 extends StatefulWidget {
  const splashScreen1({super.key});

  @override
  State<splashScreen1> createState() => _splashScreen1State();
}

class _splashScreen1State extends State<splashScreen1> {
  int splashtime = 2;
  // duration of splash screen on second

  @override
  void initState() {
    Future.delayed(Duration(seconds: splashtime), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          //pushReplacement = replacing the route so that
          //splash screen won't show on back button press
          //navigation to Home page.
          builder: (context) {
        return splashScreen2();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("asset/splashscreen1.png"),
            fit: BoxFit.cover
        ) ,
      ),
    );
  }
}



class splashScreen2 extends StatefulWidget {
  const splashScreen2({super.key});

  @override
  State<splashScreen2> createState() => _splashScreen2State();
}

class _splashScreen2State extends State<splashScreen2> {
  int splashtime = 3;
  // duration of splash screen on second

  @override
  void initState() {
    Future.delayed(Duration(seconds: splashtime), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
        //pushReplacement = replacing the route so that
        //splash screen won't show on back button press
        //navigation to Home page.
          builder: (context) {
            return PhoneNumberAuthentication();
          }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("asset/screen2.png"),
            fit: BoxFit.cover
        ) ,
      ),
    );
  }
}