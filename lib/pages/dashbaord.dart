import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(

    home: FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return NextScreen(
              responseBody: snapshot.data as Map<String, dynamic>);
        } else {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        }
      },
    ),
  ));
}

Future<Map<String, dynamic>> fetchData() async {
  // Simulate fetching the data
  await Future.delayed(Duration(seconds: 2));
  return {
    'data': {'token': 'your_token_here'}
  }; // Replace with your actual token
}

class NextScreen extends StatefulWidget {
  final Map<String, dynamic> responseBody;

  NextScreen({required this.responseBody});

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  late String authentication;

  List<dynamic> apiData = [];

  @override
  void initState() {
    super.initState();
    authentication = widget.responseBody['data']['token'].toString();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    var apiUrl =
        Uri.https('api.ourgoodspace.com', '/api/d2/member/dashboard/feed');
    try {
      var response = await http.get(
        apiUrl,
        headers: {'Authorization': '$authentication'},
      );
      if (response.statusCode == 200) {
        setState(() {
          apiData = jsonDecode(response.body)['data'] as List<dynamic>;
        });
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageOne(apiData: apiData),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cases_sharp),
            label: 'Work',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Recruit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline),
            label: 'Message',
          ),
        ],
      ),

    );
  }
}

class PageOne extends StatelessWidget {
  final List<dynamic> apiData;
  PageOne({required this.apiData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 38.0, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                        NetworkImage('https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-PNG-Photos.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      Row(
                        children: [
                          Icon(Icons.diamond_outlined, color: Colors.blue,),
                          SizedBox(width: 15),
                          Icon(Icons.notifications),
                          SizedBox(width: 15),
                          Icon(Icons.sort),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.diamond_outlined, color: Colors.orange),
                    Text(" Step into the future",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 150.0,

                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Image.asset(
                          'asset/1.png',
                          width: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Image.asset(
                          'asset/2.png',
                          width: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Image.asset(
                          'asset/3.png',
                          width: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Image.asset(
                          'asset/4.png',
                          width: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Image.asset(
                          'asset/5.png',
                          width: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),

                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Jobs for you",
                    style: TextStyle(color: Colors.blue, fontSize: 16,fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(
                  color: Colors.blue,thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Jobs',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      // Handle search query changes here
                      print('Search query: $value');
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child:
              ListView.builder(
                itemCount: apiData.length,
                itemBuilder: (context, index) {
                  var job = apiData[index]['cardData'];

                  // Check if job and title are not null before displaying
                  if (job != null && job['title'] != null) {
                    var jobType = job['jobType'][0]['job_type'].toString(); // Fetching job type
                    var userInfo = job['userInfo']['name'].toString();
                    return Container(
                      height: 280,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    job['title'].toString(),
                                    style: TextStyle(fontWeight:FontWeight.w600,fontSize: 17),
                                  ),
                                ),
                                // SizedBox(width: 50,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(Icons.share),
                                      Text(
                                        job['relativeTime'].toString(),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text('Goodspace',style: TextStyle(color: Colors.grey),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.home,color: Colors.grey,),
                                SizedBox(width: 5,),
                                Text(
                                  job['location_city'].toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    job['monthly_compensation'].toString(),
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                SizedBox(width: 30,),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star_border_outlined,color: Colors.blue,),
                                      Text(
                                        "5-7 Year",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 30,),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    jobType,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    job['userInfo']['image_id'].toString(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      userInfo,style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      job['companyName'].toString(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 40,
                                  width: 90,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // apply logic
                                    },
                                    child: Text(
                                      'Apply',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),




                        ],
                      ),
                    );
                  } else {
                    // Placeholder widget or message if the title is null
                    return Container();
                  }
                },
              )


            ),
          ),
        ],
      ),
    );
  }
}
