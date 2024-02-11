import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MyLogin1 extends StatefulWidget {
  const MyLogin1({Key? key}) : super(key: key);

  @override
  _MyLogin1State createState() => _MyLogin1State();
}

class _MyLogin1State extends State<MyLogin1> {
  final formfield = GlobalKey<FormState>();
  final usncontroller = TextEditingController();
  final passcontroller = TextEditingController();

  bool passToggle = true;
  String? usnError;
  String? passwordError;

  @override
  void dispose() {
    usncontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  Future<void> validateFields() async {
    String usn = usncontroller.text;
    String password = passcontroller.text;

    if (usn.isEmpty && password.isNotEmpty) {
      setState(() {
        usnError = "Enter USN";
        passwordError = null;
      });
    }
    else if ((!usn.toLowerCase().contains("2sd") && !usn.toLowerCase().contains("2SD")) ||
        (!usn.toLowerCase().contains("is") && !usn.toLowerCase().contains("IS"))) {
      setState(() {
        usnError = "Invalid usn";
      });
    } else if (password.isEmpty && usn.isNotEmpty) {
      setState(() {
        usnError = null;
        passwordError = "Enter password";
      });
    } else if (usn.isEmpty && password.isEmpty) {
      setState(() {
        usnError = "Enter USN";
        passwordError = "Enter password";
      });
    } else {
      try {
        String dummy='$usn@gmail.com';
        print(dummy);
        UserCredential login = await FirebaseAuth.instance.signInWithEmailAndPassword(email:dummy,password:password);
        print(dummy);
        if (login.user != null) {
          _showSuccessSnackBar("Login successful");
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushNamed(context, 'db');
          });
          usncontroller.clear();
          passcontroller.clear();
          setState(() {
            usnError = null;
            passwordError = null;
          });
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException: ${e.message}");
        print(e.code);
        _showErrorSnackBar("Invalid USN or Password");

      } catch (e) {
        print("Error: $e");
      }
    }
    showForgotPasswordDialog(context);
  }
  void showForgotPasswordDialog(BuildContext context) {
    String email = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  Navigator.pop(context);
                  _showSuccessSnackBar('Password reset email sent to $email');
                  // After sending the reset email, show OTP dialog for verification
                  showOtpDialog(context, email);
                } catch (e) {
                  _showErrorSnackBar('Error: $e');
                }
              },
              child: Text('Send Reset Email'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showOtpDialog(BuildContext context, String email) {
    String otp = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  otp = value;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Verify the OTP and reset the password
                  await FirebaseAuth.instance.confirmPasswordReset(verificationId: otp, newPassword: 'newPassword');
                  Navigator.pop(context);
                  _showSuccessSnackBar('Password reset successful');
                } catch (e) {
                  _showErrorSnackBar('Error: $e');
                }
              },
              child: Text('Verify OTP'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(top: kToolbarHeight),
        backgroundColor: Colors.white,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Student Login",style:TextStyle(color:Colors.white)),
          // backgroundColor: Colors.blue,

            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          elevation: 0.0, // Remove app bar shadow
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color:Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/login_bg.png',
            //     fit: BoxFit.contain,
            //   ),
            // ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                color: Colors.white,
                child: Form(
                  key: formfield,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/img_6.png",
                          height: 250,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: usncontroller,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "USN",
                                prefixIcon: Icon(Icons.account_circle),
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
                              keyboardType: TextInputType.text,
                              controller: passcontroller,
                              obscureText: passToggle,
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
                                      passToggle = !passToggle;
                                    });
                                  },
                                  child: Icon(
                                    passToggle ? Icons.visibility : Icons.visibility_off,
                                  ),
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
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: validateFields,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blueAccent,
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
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register1');
                                  },
                                  child: Text(
                                    'Register',
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
