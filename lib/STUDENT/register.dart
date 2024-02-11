import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRegister1 extends StatefulWidget {
  const MyRegister1({Key? key}) : super(key: key);

  @override
  _MyRegister1State createState() => _MyRegister1State();
}

class _MyRegister1State extends State<MyRegister1> {
  final formfield = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneNumberController= TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool passToggle1 = true;
  bool passToggle2 = true;
  String? nameError;
  String? passwordError;
  String? emailError;
  String? usnError;
  String? confirmPasswordError;
  String? phoneError;
  String? addressError;
  bool isLoginSuccessful = false;

  get SharedPreferences => null;

  @override
  void dispose() {
    nameController.dispose();
    usnController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }


  Future<void> _registerUser() async {

    String name = nameController.text.trim();
    String usn = usnController.text;
    String email = emailController.text;
    String password = passController.text;
    String confirmPassword = confirmPassController.text;
    String phoneNumber=phoneNumberController.text;
    String address=addressController.text;

    setState(() {
      nameError = name.isEmpty ? "Enter Name" : null;
      if (usn.isEmpty)
        usnError = "Enter USN";
      else if (!usn.toLowerCase().contains("2sd") &&
          !usn.toLowerCase().contains("2SD") &&
          !usn.toLowerCase().contains("is") &&
          !usn.toLowerCase().contains("IS")) {
        usnError = "Invalid USN";
      } else
        usnError = null;

      if (email.isEmpty)
        emailError = "Enter email";
      else if (!email.contains("@"))
        emailError = "Invalid email";
      else
        emailError = null;


      if(phoneNumber.isEmpty)
        phoneError="Enter your number";
      else if(phoneNumber.length!=10)
        phoneError="Invalid Number";
      else
        phoneError=null;

      if(address.isEmpty)
        addressError="Enter your Address";
      else
        addressError=null;

      passwordError = password.isEmpty ? "Enter Password" : null;

      confirmPasswordError = confirmPassword.isEmpty ? "Please re-enter the password once again" : null;

      if (confirmPassword != password) {
        // Password and Confirm Password do not match, set an error.
        confirmPasswordError = "Passwords do not match";
      } else {
        // Passwords match, clear the error.
        confirmPasswordError = null;
      }
    });
    if (nameError == null &&
        usnError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        phoneError==null &&
        addressError==null) {
      // Validation passed, create a user
      try {

        String dummy='$usn@gmail.com';

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email:dummy, password: password);


        // UserCredential userCredential = await FirebaseAuth.instance.signInWithCustomToken(usn);
        User? user = userCredential.user;
        if (user != null) {
          // Add user details to Firestore
          await FirebaseFirestore.instance.collection('student_account_information').doc(userCredential.user!.uid).set({
            'name': name,
            'usn': usn,
            'email': email,
            'password':password,
            'phoneNumber':phoneNumber,
            'address':address,
            // Add more fields as needed
          });
          _showSuccessSnackBar();
          // User created successfully, navigate to the next page
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushNamed(context, 'db');
          });

          nameController.clear();
          usnController.clear();
          emailController.clear();
          passController.clear();
          confirmPassController.clear();
        } else {
          print("Error");
        }
      } catch (e) {
        // Handle any errors that occurred during user creation
        print("Error: $e");
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Account created successfully!!",
          style: TextStyle(
            fontSize: 20,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: kToolbarHeight),
        backgroundColor: Colors.white70, // Adjust the duration as needed
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Create an account"),
          backgroundColor: Colors.blue, // Set the app bar color
          elevation: 0.0, // Remove app bar shadow
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(

              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Form(
                  key: formfield,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/img_4.png",
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Name",
                                prefixIcon: Icon(Icons.account_circle),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: nameError,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(

                              keyboardType: TextInputType.text,
                              controller: usnController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "USN",
                                prefixIcon: Icon(Icons.vrpano_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: usnError,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: emailError,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: phoneNumberController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Phone no",
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: phoneError,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: addressController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Address",
                                prefixIcon: Icon(Icons.place),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: addressError,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: passController,
                              obscureText: passToggle1,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: passwordError,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      passToggle1 = !passToggle1;
                                    });
                                  },
                                  child: Icon(
                                      passToggle1 ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: confirmPassController,
                              obscureText: passToggle2,
                              style: TextStyle(),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Confirm Password",
                                prefixIcon: Icon(Icons.lock_person_sharp),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: confirmPasswordError,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      passToggle2= !passToggle2;
                                    });
                                  },
                                  child: Icon(
                                      passToggle2 ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: _registerUser,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Text("Already have an account?",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context,'login1');
                                  },
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}