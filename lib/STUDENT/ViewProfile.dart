import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ise_hub_mp1/DatabaseService.dart';
import 'EditProfile.dart';
import 'package:ise_hub_mp1/FullScreenImage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name = '';
  late String usn = '';
  late String phone = '';
  late String email = '';
  late String address = '';
  late String photoUrl='' ;
  late DatabaseService _databaseService;
  static const double profilePictureRadius = 60;
  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
    fetchStudentData(userId);
  }


  Future<void> fetchStudentData(String userId) async {
    try {
      final userData = await _databaseService.fetchStudentData(userId);
      print('User Data: $userData'); // Add this line
      setState(() {
        name = userData['name'];
        usn = userData['usn'];
        phone = userData['phoneNumber'];
        email = userData['email'];
        address = userData['address'];
        photoUrl = userData['photoUrl'] ?? 'assets/ProfilePage.png';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("My Account",style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width:double.infinity,
        height:double.infinity,

        child:SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
            GestureDetector(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => FullScreenImagePage(imageUrl: photoUrl),
                   ),
                 );
               },
                child:ClipOval(
                  child: Container(
                    width: profilePictureRadius * 3,
                    height: profilePictureRadius * 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: photoUrl.startsWith('assets/')
                            ? AssetImage(photoUrl)
                            : NetworkImage(photoUrl) as ImageProvider,
                        fit: BoxFit.cover,

                      ),
                    ),
                  ),
                ),),
                const SizedBox(height: 20),
                itemProfile('Name', name, CupertinoIcons.person),
                const SizedBox(height: 10),
                itemProfile('USN', usn, CupertinoIcons.person_crop_circle),
                const SizedBox(height: 10),
                itemProfile('Phone', phone, CupertinoIcons.phone),
                const SizedBox(height: 10),
                itemProfile('Email', email, CupertinoIcons.mail),
                const SizedBox(height: 10),
                itemProfile('Address', address, CupertinoIcons.location),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  child:
                  ElevatedButton(

                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileEditScreen(
                            initialProfile: Profile(
                              name: name,
                              usn: usn,
                              phoneNumber: phone,
                              email: email,
                              address: address,
                              photoUrl: photoUrl,
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),),
    );
  }

  Widget itemProfile(String title, String? subtitle, IconData iconData) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              color: Colors.blueAccent.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 10,
            )
          ],
        ),
        child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle ?? 'Not Available'),
            leading: Icon(iconData),
            tileColor: Colors.white,
            ),
        );
    }
}