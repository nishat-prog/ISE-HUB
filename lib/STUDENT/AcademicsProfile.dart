import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' ;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;

class AcademicsProfile extends StatefulWidget {
  const AcademicsProfile({Key? key}) : super(key: key);
  @override
  AcademicsProfileState createState() => AcademicsProfileState();
}

class AcademicsProfileState extends State<AcademicsProfile> {
  int? selectedAICTECategoryPoints = null; // Change the type to int?

  List<String> aicteCategories = ['Workshop', 'Hackathon', 'Poster Presentation', 'Research Paper'];
  late DateTime pickedDate = DateTime.now();
  late File? _photo=null;
   File? _document;
   PlatformFile? pickedFile;
   UploadTask? uploadTask;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController organizerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  //TextEditingController timeController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController photoDescriptionController = TextEditingController();
  TextEditingController documentDescriptionController = TextEditingController();
  TextEditingController AICTEController = TextEditingController();
  TextEditingController photoController = TextEditingController();
  TextEditingController documentController = TextEditingController();
String imageUrl='';
String documentUrl='';

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
  int getAICTEPointsForCategory(String category) {
    if(category=='Workshop')
       return 10;
    else if(category=='Hackathon')
      return 20;
    else if(category=='Research Paper')
      return 30;
    else if(category=='Poster Presentation')
      return 40;
    else
      return 0;

  }
  Future<String> _uploadFile(dynamic file,String foldername, String fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('STUDENT/Academics/$foldername/$fileName');
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

  String formatDate(DateTime date) {
    String formattedDate= DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;// Adjust the date format as needed
  }

  Future<String> _addEventDetails(
      String eventName,
      String organizer,
      String date,
      String venue,
      String aicte,
      String photoDescription,
      String documentDescription,
      String imageUrl,
      String documentUrl,
      ) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
   // String formattedDate = formatDate(date);
    DateTime formattedDate = DateTime.parse(date); // Parse the date string to DateTime
    String formattedDateString = formatDate(formattedDate);

    CollectionReference eventsCollection = FirebaseFirestore.instance
        .collection('academic_event_details')
        .doc(userId)
        .collection('events');
    DocumentReference docRef = await eventsCollection.add({
      'eventName': eventName,
      'organizer': organizer,
      'date': formattedDateString,
      'year': formattedDate.year,
      'month': formattedDate.month,
      'venue': venue,
      'aicte': aicte,
      'photoDescription': photoDescription,
      'documentDescription': documentDescription,
      'imageUrl': imageUrl,
      'documentUrl': documentUrl,
      // Add more fields as needed
    });
    String eventId = docRef.id;
    await docRef.update({
      'eventId': eventId,
    });

    return eventId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Academic Events",
              style:TextStyle(
                color:Colors.white,
                fontWeight: FontWeight.bold
              )),
              backgroundColor: Colors.transparent, // Set the app bar color
              elevation: 0.0,
              flexibleSpace: Container(
            color:Colors.transparent,
              ),// Remove app bar shadow
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                color:Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/img_8.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                   // padding: EdgeInsets.only(
                   //   top: MediaQuery.of(context).size.height * 0.04, // Add padding to avoid overlap
                   // ),

                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.0 + kToolbarHeight,
                      left: 0,
                      right: 0,
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height:90),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: eventNameController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Event name",
                                    prefixIcon: const Icon(Icons.event),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: organizerController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Organized by",
                                    prefixIcon: const Icon(Icons.contact_mail_rounded),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: dateController,
                                  style: const TextStyle(color: Colors.black),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );

                                    if (pickedDate != null && pickedDate != DateTime.now()) {
                                      setState(() {
                                        dateController.text = formatDate(pickedDate);
                                      });
                                    }


                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Date",
                                    prefixIcon: const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),

                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: venueController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Venue",
                                    prefixIcon: const Icon(Icons.place),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: AICTEController,
                                  readOnly: true,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "AICTE points",
                                    prefixIcon: const Icon(Icons.score),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                  ),
                                ),
                            // Dropdown for AICTE categories
                               // const SizedBox(height: 10),
                                // Dropdown for AICTE categories
                                const SizedBox(height: 10),
                                Container(

                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    DropdownButton<int>(
                                      icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Set the color of the dropdown arrow
                                      iconSize: 24.0, // Set the size of the dropdown arrow icon
                                      iconEnabledColor: Colors.white,
                                      dropdownColor: Colors.white,
                                      value: selectedAICTECategoryPoints,
                                      hint: Text("Select your category",style: TextStyle(
                                        color: Colors.white, // Set the text color of the dropdown items
                                        fontSize: 16.0, // Set the font size of the dropdown items
                                      ),
                                      ),
                                      //color:Colors.blueAccent,
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          selectedAICTECategoryPoints = newValue;
                                          // Autofill the AICTE points field based on the selected category
                                          AICTEController.text = selectedAICTECategoryPoints?.toString() ?? '';
                                        });
                                      },
                                      items: aicteCategories.map((String category) {
                                        return DropdownMenuItem<int>(
                                          value: getAICTEPointsForCategory(category),
                                          // child: Align(
                                           //  alignment: Alignment.topLeft,
                                            child: Text(category,
                                              style: TextStyle(
                                                color: Colors.black, // Set the text color of the dropdown items
                                                fontSize: 16.0, // Set the font size of the dropdown items
                                              ),),
                                          //),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: photoDescriptionController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Photo Description",
                                    prefixIcon: const Icon(Icons.image),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
// Photo upload field
                                Align(
                                  alignment: Alignment.topLeft,
                                  child:
                                  ElevatedButton(
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                      print('${file?.path}');
                                      if (file == null) return;
                                      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                                      Reference referenceRoot = FirebaseStorage.instance.ref();
                                      Reference referenceDirImages = referenceRoot.child('STUDENT').child('Academic').child('images');
                                      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
                                      try {
                                        final Uint8List imageBytes = await file.readAsBytes();
                                        final String mimeType = 'image/${file.name.split('.').last}'; // Set correct MIME type

                                        // Upload the image with specific content type
                                        await referenceImageToUpload.putData(imageBytes, SettableMetadata(contentType: mimeType));

                                        imageUrl = await referenceImageToUpload.getDownloadURL();
                                        setState(() {
                                          _photo  = File(file.path);
                                        });
                                        print('Image uploaded successfully. Download URL: $imageUrl');
                                      } catch (e) {
                                        print('Error uploading image: $e');
                                      }
                                    },
                                    child: Text(_photo == null ? "Upload Photo" : "Photo Selected"),
                                  ),
                                ),

                                if (_photo != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width:50,
                                    height:50,
                                    child: kIsWeb
                                        ? Image.network(_photo!.path) // For web
                                        : Image.file(
                                      File(_photo!.path),
                                      width: 15,
                                      alignment: Alignment.topLeft,
                                      height:15,
                                      fit: BoxFit.contain,
                                    ), // For mobile
                                  ),
                                const SizedBox(height: 30),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: documentDescriptionController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Document Description",
                                    prefixIcon: const Icon(Icons.file_copy),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height:10),
                                // Document upload field
                                Align(
                                  alignment: Alignment.topLeft,

                                   child: ElevatedButton(
                                      onPressed: () async {
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
                                              _document = File(file.name); // Update _document with the selected file
                                            });
                                          } else {
                                            // Handle other platforms
                                            String documentURL = await _uploadFile(file.path!, 'documents', file.name);
                                            setState(() {
                                              documentUrl = documentURL;
                                              _document = File(file.path!); // Update _document with the selected file
                                            });
                                          }
                                        }
                                      },
                                      child: Text(_document == null ? "Upload Certificate" : "Document Selected"),
                                    )
                                ),
                                SizedBox(height: 20),
                                if (_document != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.description,color:Colors.white), // Replace with appropriate document icon
                                        SizedBox(width: 10),
                                        Text(_document!.path.split('/').last,style:TextStyle(color: Colors.white)), // Display the document name
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      String eventId = await _addEventDetails(
                                        eventNameController.text,
                                        organizerController.text,
                                        dateController.text ,
                                        venueController.text,
                                        AICTEController.text,
                                        photoDescriptionController.text,
                                        documentDescriptionController.text,
                                        imageUrl,
                                        documentUrl,
                                        //photoController.text,
                                        // documentController.text
                                      );
                                      print(eventId);
                                      _showSuccessSnackBar('Event Added Successfully!!');
                                      Navigator.pop(context);


                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    child: const Text(
                                      'Add event',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize:21,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height:60)
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
        );
    }
}