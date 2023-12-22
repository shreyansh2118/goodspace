import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'otp verification.dart';

class PhoneNumberAuthentication extends StatefulWidget {
  @override
  _PhoneNumberAuthenticationState createState() =>
      _PhoneNumberAuthenticationState();
}

class _PhoneNumberAuthenticationState extends State<PhoneNumberAuthentication> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _verificationInProgress = false;

  Future<void> requestOTP(BuildContext context) async {
    String phoneNumber = _phoneNumberController.text.trim();
    String countryCode = "+91"; // Replace with actual country code input

    if (phoneNumber.isEmpty) {
      // Handle empty phone number error
      return;
    }

    setState(() {
      _verificationInProgress = true;
    });

    var url = Uri.https('api.ourgoodspace.com', '/api/d2/auth/v2/login');
    var requestBody = {
      'number': phoneNumber,
      'countryCode': countryCode,
    };

    try {
      var response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'YOUR_AUTH_TOKEN', // Replace with actual auth token
          'device-id': 'YOUR_DEVICE_ID', // Replace with actual device ID
          'device-type': 'android', // Replace with actual device type
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Response: $jsonResponse');

        String otp = jsonResponse['otp'] ??
            '0000'; // Extract OTP value or default to empty string

        if (otp.isNotEmpty) {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(
                  phoneNumber,
                ),
              ),
            );
          } catch (error) {
            print('Navigation error: $error');
          }
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Handle API error
      }
    } catch (error) {
      print('Error during HTTP request: $error');
    } finally {
      setState(() {
        _verificationInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Correct Phone",
                style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w600),
              ),
              Text(
                "Number",
                style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 360,
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "asset/flag.jpg",
                        width: 20,
                        height: 25,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 240,
                      height: 50,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            InputDecoration(hintText: "Please enter mobile no"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Please be sure to select the correct area",
                style: TextStyle(color: Colors.grey),),
              Text(
                  "code and enter 10 digits.",
                style: TextStyle(color: Colors.grey),),
              SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 70,
                  width: 300,
                  child: ElevatedButton(
                    onPressed:
                    _verificationInProgress ? null : () => requestOTP(context),
                    child: _verificationInProgress
                        ? CircularProgressIndicator()
                        : Text('Verify Phone',style: TextStyle(fontSize: 17),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
