import 'package:flutter/material.dart';

class UpdateProfile3 extends StatefulWidget {
  const UpdateProfile3({Key? key}) : super(key: key);

  @override
  _UpdateProfile3State createState() => _UpdateProfile3State();
}

class _UpdateProfile3State extends State<UpdateProfile3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(

        title: Text('Update your Profile',
          style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold// Set the text color
            //  fontWeight: FontWeight.w200,
          ),),
        backgroundColor: Colors.transparent, // Set the app bar color
        elevation: 0.0, // Remove app bar shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
      Stack(
        children:[

          Positioned.fill(
            child: Image.asset(
              'assets/img_8.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,


            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height:150,
                ),

                Image.asset(
                  "assets/img_18.png",
                  height: 200,
                  width: 280,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 100),
                Container(
                  width: 350.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    //  color: Colors.blue, // Set the background color of the container
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Set the button background color
                      // You can also customize other aspects of the button style here
                      // For example, text style, elevation, padding, etc.
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('AddEvent3');
                    },
                    child: Text(
                      "Add an event",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue, // Set the text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 350.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      //  color: Colors.blue, // Set the background color of the container
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the button background color
                        // You can also customize other aspects of the button style here
                        // For example, text style, elevation, padding, etc.
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('UpdateExistingEvent3');
                      },
                      child: Text(
                        "Update existing event",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue, // Set the text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 350.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      //  color: Colors.blue, // Set the background color of the container
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the button background color
                        // You can also customize other aspects of the button style here
                        // For example, text style, elevation, padding, etc.
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('DeleteEvent3');
                      },
                      child: Text(
                        "Delete an event",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.blue, // Set the text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 130),
              ],
            ),
          ),

        ],),
    );
  }
}
