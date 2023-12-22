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
  bool isPhoneNumberValid = true;
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
            children: [
              Container(
                height: 550,
                child: Image.asset('asset/img1.png'),
              ),
              Row(
                children: [
                  Text(
                    "Please enter your phone number to sign in",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "GoodSpace ",
                    style: TextStyle(color: Colors.blue),
                  ),
                  Text(
                    "account",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the message outside the container


                        // Container with input field
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isPhoneNumberValid
                                    ? Colors.black
                                    : Colors.red),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 340,
                            height: 60,
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
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: "Please enter mobile no",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        isPhoneNumberValid =
                                            value.trim().length <= 10;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isPhoneNumberValid)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Enter correct phone number',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Container(
                  child: Row(
                    children: [
                      Text("you will receive a "),
                      Text(
                        "4 digit OTP",
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              Container(
                height: 70,
                width: 340,
                child: ElevatedButton(
                  onPressed:
                  _verificationInProgress ? null : () => requestOTP(context),
                  child: _verificationInProgress
                      ? CircularProgressIndicator()
                      : Text('GET OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
