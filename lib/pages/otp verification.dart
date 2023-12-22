import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';

import 'dashbaord.dart';
import 'editPhone.dart';
class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OTPVerificationScreen(this.phoneNumber);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String enteredOTP = '';

  Future<void> verifyOTP(BuildContext context, String enteredOTP) async {
    var url = Uri.https('api.ourgoodspace.com', '/api/d2/auth/verifyotp');

    var requestBody = {
      'number': widget.phoneNumber,
      'otp': enteredOTP,
      'inviteId': null,
      'utmTracking': null,
    };

    try {
      var response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'YOUR_AUTH_TOKEN',
          'device-id': 'YOUR_DEVICE_ID',
          'device-type': 'android',
        },
      );

      if (response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);

        // Navigate to NextScreen and pass the entire API response
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NextScreen(responseBody: jsonResponse),
          ),
        );
      } else {
        print('OTP verification failed with status: ${response.statusCode}');
        // Handle OTP verification failure - Show an error message or handle it accordingly
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      // Handle exceptions during OTP verification - Show an error message or handle it accordingly
    }
  }





  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
    );
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),onTap: (){
                        Navigator.pop(context);
                      },),
                      Row(
                        children: [
                          InkWell(
                            child: Text(
                              "Edit Phone number ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    // Remove default padding
                                    content: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: SizedBox(
                                        width: 400, // Adjust width as needed
                                        height: 400, // Adjust height as needed
                                        child: PhoneNumberAuthentication(),
                                      ),
                                    ),
                                  );

                                },
                              );
                            },
                          ),
                          Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'OTP sent to +91',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            "${widget.phoneNumber}",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        'Enter OTP to confirm your phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "You'll receive a four digit verification code",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),

                      Pinput(
                          length: 4,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                          onCompleted: (value) {
                            setState(() {
                              enteredOTP += value ?? '';
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Didn't receive OTP ?",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              " Resend",
                              style: TextStyle(color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 70,
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              if (enteredOTP.length == 4) {
                                verifyOTP(context, enteredOTP);
                              } else {
                                // Display an error message or handle incomplete OTP entry
                              }
                            },
                            child: Text(
                              'Verify Phone',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }}

// ListView.builder(
//   itemCount: apiData.length,
//   itemBuilder: (context, index) {
//     var job = apiData[index]['cardData'];
//
//     // Check if job and title are not null before displaying
//     if (job != null && job['title'] != null) {
//       return Card(
//         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: ListTile(
//           title: Text(
//             job['title'].toString(),
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       );
//     } else {
//       // Placeholder widget or message if the title is null
//       return Container(
//         // child: Text('Title Not Available'),
//       );
//     }
//   },
// ),

// class PageTwo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Page Two'),
//       ),
//       body: Center(
//         child: Text('This is Page Two'),
//       ),
//     );
//   }
// }

// Padding(
//   padding: const EdgeInsets.only(top: 38.0, left: 20, right: 20),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Icon(Icons.person),
//             Row(
//               children: [
//                 Icon(Icons.diamond_outlined, color: Colors.blue),
//                 SizedBox(width: 15),
//                 Icon(Icons.notifications),
//                 SizedBox(width: 15),
//                 Icon(Icons.sort),
//               ],
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 20),
//       Row(
//         children: [
//           Icon(Icons.diamond_outlined, color: Colors.orange),
//           Text(" Step into the future"),
//         ],
//       ),
//       SizedBox(height: 20),
//       Container(
//         height: 200.0,
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: [
//             Image.network(
//               'https://via.placeholder.com/150',
//               width: 180.0,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(width: 20),
//             // Add more images here
//           ],
//         ),
//       ),
//       SizedBox(height: 30),
//       Align(
//         alignment: Alignment.center,
//         child: Text(
//           "Jobs for you",
//           style: TextStyle(color: Colors.blue, fontSize: 16),
//         ),
//       ),
//       SizedBox(height: 16),
//       Expanded(
//         child: ListView.builder(
//           itemCount: apiData.length,
//           itemBuilder: (context, index) {
//             var job = apiData[index]['cardData'];
//
//             // Check if job and title are not null before displaying
//             if (job != null && job['title'] != null) {
//               return Card(
//                 margin:
//                 EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text(
//                     job['title'].toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               );
//             } else {
//               // Placeholder widget or message if the title is null
//               return Container();
//             }
//           },
//         ),
//       ),
//     ],
//   ),
// ),