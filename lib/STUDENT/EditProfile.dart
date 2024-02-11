import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ise_hub_mp1/DatabaseService.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

class ProfileEditScreen extends StatefulWidget {
  final Profile initialProfile;


  ProfileEditScreen({required this.initialProfile, Key? key}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String imageUrl='';
  late File? _photo=null;
  late String name;
  late String usn;
  late String phone;
  late String email;
  late String address;
  late DatabaseService _databaseService;
  late String profilepic;
  //=AssetImage('assets/ProfilePage.png');
  bool isUpdating = false;


  @override
  void initState() {
    super.initState();
    print('hello');
    _databaseService = DatabaseService();
    name = widget.initialProfile.name;
    usn = widget.initialProfile.usn;
    phone = widget.initialProfile.phoneNumber;
    email = widget.initialProfile.email;
    address = widget.initialProfile.address;
print(widget.initialProfile.photoUrl);
    profilepic = widget.initialProfile.photoUrl
.isNotEmpty
        ? widget.initialProfile.photoUrl
        : 'assets/ProfilePage.png';
  }

  Future<void> _updateUserProfile() async {


    try {

      String userId = FirebaseAuth.instance.currentUser!.uid;
    //    String photoUrl = await taskSnapshot.ref.getDownloadURL();
      // Update user details in the database
      await _databaseService.updateStudentProfile(
        userId,
        name,
        usn,
        phone,
        email,
        address,
        imageUrl
      );

      _showSuccessSnackBar("Profile Edited");
    } catch (e) {
      print('Error updating user profile: $e');
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }


  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: kToolbarHeight),
        backgroundColor: Colors.white, // Adjust the duration as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              CupertinoButton(
                onPressed: () async {
                 // print("hi");
                 // late File? photo=null;
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                  print('${file?.path}');
                  if (file == null) return;
                  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('STUDENT').child('profile_photos');
                  Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                  try {
                    // setState(() {
                    //   isUpdating = true;
                    // });
                    final Uint8List imageBytes = await file.readAsBytes();
                    final String mimeType = 'profile_photo/${file.name.split('.').last}';


                    // Upload the image with specific content type
                    await referenceImageToUpload.putData(imageBytes, SettableMetadata(contentType: mimeType));

                    imageUrl = await referenceImageToUpload.getDownloadURL();
                    print(imageUrl);
                    setState(() {
                      _photo= File(file.path);
                    });
                    print('Image uploaded successfully. Download URL: $imageUrl');
                  } catch (e) {
                    print('Error uploading image: $e');
                  }


                },
                padding: EdgeInsets.zero,
                child:  CircleAvatar(
                  radius: 75,
                  backgroundImage: _photo != null ? FileImage(_photo!) as ImageProvider: NetworkImage(profilepic),
//AssetImage('assets/ProfilePage.png'),
                ),

              ),
              const SizedBox(height: 20),
              _buildTextField('Name', name, (value) {
                setState(() {
                  name = value;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField('USN', usn, (value) {
                setState(() {
                  usn = value;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField('Phone', phone, (value) {
                setState(() {
                  phone = value;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField('Email', email, (value) {
                setState(() {
                  email = value;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField('Address', address, (value) {
                setState(() {
                  address = value;
                });
              }),
              const SizedBox(height: 30),

              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: isUpdating ? null : _updateUserProfile,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String initialValue, ValueChanged<String> onChanged) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }
}

class Profile {
  String name;
  String phoneNumber;
  String email;
  String address;
  String usn;
  String photoUrl;

  Profile({
  this.name = '',
  this.usn = '',
  this.phoneNumber = '',
  this.email = '',
  this.address = '',
  this.photoUrl='',
  });
}