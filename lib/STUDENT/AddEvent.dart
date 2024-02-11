import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Add an event',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight:FontWeight.bold// Set the text color
            //  fontWeight: FontWeight.w200,
          ),),
        backgroundColor: Colors.transparent, // Set the app bar color
        elevation: 0.0, // Remove app bar shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
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
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150),
            Image.asset(
                "assets/young-woman-studying.png",
                height: 230,
                width: 220,
                fit: BoxFit.cover,
              ),

            SizedBox(height: 100),
            Container(
              width: 350.0,
              height: 80.0,
              decoration: BoxDecoration(
             //   color: Colors.white,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Set the background color of the button
                  // You can also customize other aspects of the button style here
                  // For example, text style, elevation, padding, etc.
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('AcademicsProfile');
                },
                child: Text("Academic Events",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
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
               //   color: Colors.white,
                ),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Set the background color of the button
                    // You can also customize other aspects of the button style here
                    // For example, text style, elevation, padding, etc.
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('ExtraCurricularProfile');
                  },
                  child: Text("Extra-curricular Events",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 200),

          ],
        ),
      ),
    ],  ),  );
  }
}
