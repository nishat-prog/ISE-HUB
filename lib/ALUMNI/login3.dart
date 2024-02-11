import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MyLogin3 extends StatefulWidget {
  const MyLogin3({Key? key}) : super(key: key);

  @override
  _MyLogin3State createState() => _MyLogin3State();
}

class _MyLogin3State extends State<MyLogin3> {
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
        usnError = "Enter ID";
        passwordError = null;
      });
    } else if (password.isEmpty && usn.isNotEmpty) {
      setState(() {
        usnError = null;
        passwordError = "Enter password";
      });
    }  else if ((!usn.toLowerCase().contains("is") && !usn.toLowerCase().contains("IS")) ||
        (!usn.toLowerCase().contains("dt") && !usn.toLowerCase().contains("DT"))) {
      setState(() {
        usnError = "Invalid ID";
      });
    }else if (usn.isEmpty && password.isEmpty) {
      setState(() {
        usnError = "Enter ID";
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
            Navigator.pushNamed(context, 'alumni_dashboard');
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
        _showErrorSnackBar("Invalid ID or Password");

      } catch (e) {
        print("Error: $e");
      }
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
          title: Text("Alumni Login"),
          //  backgroundColor: Colors.blue, // Set the app bar color
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),// Remove app bar shadow
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
                                hintText: "ID",
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
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register3');
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
