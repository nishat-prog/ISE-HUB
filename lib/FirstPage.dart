import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:ise_hub_mp1/STUDENT/login.dart';
import 'package:ise_hub_mp1/STAFF/login2.dart';
import 'package:ise_hub_mp1/ALUMNI/login3.dart';




class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<String> imgData = [
    "assets/img_2.png",
    "assets/img_5.png",
    "assets/img7-1.png",
  ];

  List<String> titles = ["STUDENT", "STAFF", "ALUMNI"];

  List<Widget> pages = [MyLogin1(), MyLogin2(), MyLogin3()];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),

          ),
          //color: Colors.blue, // Set the page color to lavender
          width: width,
          child: Column(
            children: [
              Container(
                height: height * 0.38,
                width: width,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to",
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,fontFamily: 'Agabalumo'
                            ),
                          ),
                          Text(
                            "ISE-HUB!!",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2),
                    Image.asset(
                      "assets/graduate-with-an-award-standing-on-books-HNY.png", // Replace with the image path
                      width: 195, // Adjust the width as needed
                      height: 250, // Adjust the height as needed
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                width: width,
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "Choose your role",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blueAccent, // Change text color as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var i = 0; i < titles.length; i++)
                      Column(
                        children: [
                          SizedBox(height: 30),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => pages[i]),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 260,
                                    height: 260,
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          imgData[i],
                                          fit: BoxFit.fill,
                                        ),
                                        Align(
                                          alignment: Alignment(0, 0.9),
                                          child: Text(
                                            titles[i],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (i < titles.length - 1)
                            SizedBox(height: 16), // Add spacing between boxes
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
