import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage2 extends StatefulWidget {
  const DashboardPage2({Key? key}) : super(key: key);

  @override
  _DashboardPage2State createState() => _DashboardPage2State();
}

class _DashboardPage2State extends State<DashboardPage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                IconButton(
                  icon: Icon(Icons.menu,color:Colors.white),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                ),
                SizedBox(width: 23),
                Image.asset(
                  "assets/img_15.png",
                  height: 222,
                  width: 150,
                  fit: BoxFit.cover,

                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Padding(
              padding: EdgeInsets.only(top:15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0),
                ),

                child: Container(
                  padding: EdgeInsets. only(top: 30, bottom: 25),
                  child:


                  Container(
                    child:SingleChildScrollView(
                      padding:EdgeInsets.only(),
                      child:Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical:16,horizontal:16),
                            child: Container(
                              width: 500.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10.10),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('DisplayUserEvents2');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/img_14.png",
                                      height: 100,
                                      width: 106,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "View your profile",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: 500.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('UpdateProfile2');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/img_11.png",
                                        height: 150,
                                        width: 106,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Update your profile",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: 500.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('StaffRecordsScreen');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/img_16.png",
                                        height: 120,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 50),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "View Staff",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Records",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: 500.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('StudentRecords');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/img_13.png",
                                        height: 130,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "View Students",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Records",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),), ),
              ),
            ),),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: kToolbarHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.deepPurpleAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),

              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,color:Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_rounded),
              title: Text(
                'Account details',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('ViewProfile2');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('FirstPage');
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(
                'Delete account',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Account?'),
                      content: Text('Are you sure you want to delete your account?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // TODO: Handle delete account action
                            // Add your code to delete the account here
                            User? user = _auth.currentUser;

                            // Delete the user's account
                            await user?.delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Account deleted successfully'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              'FirstPage', // Replace with the route name of your first page
                                  (Route<dynamic> route) => false, // Clear all routes from the stack
                            );// Close the dialog
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
