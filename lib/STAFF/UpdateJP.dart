import 'package:flutter/material.dart';
import 'package:ise_hub_mp1/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UpdateJP extends StatefulWidget {
  final EventDetails2 eventDetails;

  UpdateJP({required this.eventDetails});

  @override
  _UpdateJPState createState() => _UpdateJPState();
}

class _UpdateJPState extends State<UpdateJP> {
  // Controller for text fields
  //late DatabaseService _databaseService;
  String imageUrl='';
  String documentUrl='';
  File? _document;
  late File? _photo=null;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _organizerController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _venueController = TextEditingController();
  TextEditingController _aicteController = TextEditingController();
  TextEditingController _photoDescriptionController = TextEditingController();
  TextEditingController _documentDescriptionController = TextEditingController();
  TextEditingController _imgController = TextEditingController();
  TextEditingController _docController = TextEditingController();
  late DatabaseService _databaseService;


  Future<String> _uploadFile(dynamic file,String foldername, String fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('STAFF/JP/$foldername/$fileName');
    if (file is String) {
      // Handle file path (non-web platforms)
      File fileObj = File(file);
      UploadTask uploadTask = storageReference.putFile(fileObj);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      print(url);
      return url;
    } else if (file is Uint8List) {
      // Handle file content as bytes (web platform)
      UploadTask uploadTask = storageReference.putData(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } else {
      throw Exception('Unsupported file type');
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
  void initState() {
    super.initState();
    _databaseService = DatabaseService();

    _eventNameController.text = widget.eventDetails.eventName;
    _organizerController.text = widget.eventDetails.organizer;
    _dateController.text = widget.eventDetails.date;
    _venueController.text = widget.eventDetails.venue;

    _photoDescriptionController.text = widget.eventDetails.photoDescription;
    _documentDescriptionController.text = widget.eventDetails.documentDescription;
    _imgController.text = widget.eventDetails.img;
    _docController.text=widget.eventDetails.doc;
    setState(() {
      documentUrl = widget.eventDetails.doc.isNotEmpty ? widget.eventDetails.doc : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Extra-curricular Event"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your form fields go here, using the controllers to pre-fill values
            TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(labelText: 'Program'),
            ),
            SizedBox(height:20),
            TextFormField(
              controller: _organizerController,
              decoration: InputDecoration(labelText: 'Organizer'),
            ),

            SizedBox(height:20),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            SizedBox(height:20),
            TextFormField(
              controller: _venueController,
              decoration: InputDecoration(labelText: 'Venue'),
            ),

            SizedBox(height:20),
            TextFormField(
              controller: _photoDescriptionController,
              decoration: InputDecoration(labelText: 'Photo description'),
            ),
            SizedBox(height:20),
            GestureDetector(
              onTap: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                if (file == null) return;
                String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('STAFF').child('JP').child("images");
                Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                try {
                  final Uint8List imageBytes = await file.readAsBytes();
                  final String mimeType = 'photo/${file.name.split('.').last}';
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

                // Your existing code for uploading the image to Firebase Storage goes here...

                // Update the _imgController and imageUrl
                setState(() {
                  _imgController.text = imageUrl; // Update the image URL
                  _photo = File(file.path); // Update the photo file
                });
              },
              child: _photo != null
                  ? Image.file(
                _photo!,
                fit: BoxFit.fill,
                height: 60,
                width: 60,
              )
                  : _imgController.text.isNotEmpty
                  ? Image.network(
                _imgController.text,
                fit: BoxFit.fill,
                height: 60,
                width: 60,
              )
                  :Row(
                children: [
                  Icon(Icons.add_a_photo, color: Colors.blue),
                  SizedBox(width: 5),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _documentDescriptionController,
              decoration: InputDecoration(labelText: 'Document description'),
            ),
            SizedBox(height:30),
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      if (kIsWeb) {
                        // Handle web platform
                        Uint8List bytes = file.bytes!;
                        String documentURL = await _uploadFile(bytes, 'documents', file.name);
                        print('Document uploaded successfully :Download URL is $documentURL');
                        setState(() {
                          documentUrl = documentURL;
                          _document = File(file.name);
                          _docController.text =documentUrl;// Update _document with the selected file
                        });
                      } else {
                        // Handle other platforms
                        String documentURL = await _uploadFile(file.path!, 'documents', file.name);
                        setState(() {

                          documentUrl = documentURL;
                          _document = File(file.path!);
                          _docController.text =documentUrl;// Update _document with the selected file
                        });
                      }
                    }
                  },
                  child: (documentUrl=='')?Row(
                    children: [
                      Icon(Icons.add_card, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        'Add Document',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  )
                      :Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        'Update Document',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            SizedBox(height: 30),

            Center(
              child:SizedBox(
                width:170,
                child:ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,),
                  onPressed: () async{
                    // Call the function to update the event with the new values
                    await _databaseService.updateExtraCurricularEvent(
                      userId,
                      widget.eventDetails.eventId,
                      _eventNameController.text,
                      _organizerController.text,
                      _dateController.text,
                      _venueController.text,
                      _photoDescriptionController.text,
                      imageUrl,
                      _documentDescriptionController.text,
                      documentUrl,
                    );
                    _showSuccessSnackBar('Event details updated successfully');
                    // Pop the current page from the navigation stack
                    Navigator.pop(context);
                  },
                  child: Text('Update',
                    style:TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                ),),
            ),


          ],
        ),
      ),
    );
  }
}

class EventDetails2 {
  final String eventId;
  final String eventName;
  final String organizer;
  final String date;
  final String venue;
  final String photoDescription;
  final String img;
  final String documentDescription;
  final String doc;

  EventDetails2({
    required this.eventId,
    required this.eventName,
    required this.organizer,
    required this.date,
    required this.venue,
    required this.photoDescription,
    required this.img,
    required this.documentDescription,
    required this.doc,
  });
}

