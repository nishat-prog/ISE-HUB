import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      // Get the currently signed-in user
      User? user = _auth.currentUser;

      // Delete the user's account
      await user?.delete();

      // Show a snackbar to indicate that the account was deleted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to the first page of the app
      Navigator.pushNamedAndRemoveUntil(
        context,
        'FirstPage', // Replace with the route name of your first page
            (Route<dynamic> route) => false, // Clear all routes from the stack
      );
    } catch (e) {
      // Handle any errors that occur during account deletion
      print('Failed to delete account: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Are you sure you want to delete your account?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _deleteAccount(context),
              child: Text('Delete My Account'),
            ),
          ],
        ),
      ),
    );
  }
}
