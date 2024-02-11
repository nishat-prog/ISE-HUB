import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent, // Set the app bar color
        elevation: 0.0,
        flexibleSpace: Container(
          color:Colors.transparent,
        ),// Remove app bar shadow
        actions: [
          IconButton(
            icon: Icon(Icons.close,color:Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          // You can customize the loading and error behavior here if needed
        ),
      ),
    );
  }
}
