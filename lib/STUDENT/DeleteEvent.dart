import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ise_hub_mp1/FullScreenImage.dart';
import 'package:ise_hub_mp1/DocumentDisplayPage.dart';

class DeleteEvent1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete an event",style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(child:DeleteEventPage(),),
    );
  }
}
String userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
class DeleteEventPage extends StatelessWidget {
  void _showSuccessSnackBar(BuildContext context, String message){
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
  Widget YourErrorWidget() {
    return Icon(
      Icons.error,
      color: Colors.red,
    );
  }
  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('academic_event_details')
                .doc(userId)
                .collection('events')
                .snapshots(),
            builder: (context, academicSnapshot) {
              if (academicSnapshot.hasData) {
                List<QueryDocumentSnapshot> academicEvents =
                    academicSnapshot.data!.docs;

                return _buildEventSection(context,'Academic Events', academicEvents);
              } else if (academicSnapshot.hasError) {
                return Text('Error: ${academicSnapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('extracurricular_event_details')
                .doc(userId)
                .collection('events')
                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.hasData) {
                List<QueryDocumentSnapshot> extracurricularEvents =
                    extracurricularSnapshot.data!.docs;

                return _buildEventSection(context,
                    'Extra-Curricular Events', extracurricularEvents);
              } else if (extracurricularSnapshot.hasError) {
                return Text('Error: ${extracurricularSnapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventSection(
      BuildContext context,
      String sectionTitle,
      List<QueryDocumentSnapshot> events) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            dataRowHeight: 50,
            columns: [
              DataColumn(
                label: Text(
                  'Event Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Organizer',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Date',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Venue',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              if (sectionTitle == 'Academic Events')
                DataColumn(
                  label: Text(
                    'AICTE Points',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              DataColumn(
                label: Text(
                  'Photo Description',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Photo',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Document Description',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Document',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: events
                .map(
                  (event) => DataRow(
                cells: [
                  DataCell(Text(event['eventName'])),
                  DataCell(Text(event['organizer'])),
                  DataCell(Text(event['date'])),
                  DataCell(Text(event['venue'])),
                  if (sectionTitle == 'Academic Events')
                    DataCell(Text(event['aicte'])),
                  DataCell(Text(event['photoDescription'])),
                  DataCell(
                    GestureDetector(onTap: () {
                      // Navigate to a new page to display the image in full size
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(imageUrl: event['imageUrl']),
                        ),
                      );
                    },
                      child:
                      Image.network(
                        event['imageUrl'],
                        fit: BoxFit.cover,
                        height:45,
                        width:45,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(); // Replace with your error widget
                        },
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(

                            );
                          }
                        },
                      ),
                    ),),
                  DataCell(Text(event['documentDescription'])),
                  DataCell(
                    event['documentUrl'] != ''
                        ? GestureDetector(
                      onTap: () {
                        // Handle the onTap event, such as opening the document in a new page or a viewer
                        // For example:
                        print(event['documentUrl']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentDisplayPage(documentUrl: event['documentUrl']),
                          ),
                        );

                      },
                      child: Row(
                        children: [
                          Icon(Icons.description, color: Colors.blue),
                          SizedBox(width: 5),
                          Text(
                            'View Document',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    )
                        : SizedBox(
                      child:Text('-'),
                    ), // If documentUrl is null, render an empty SizedBox
                  ),
                  // Inside the _buildEventSection method, modify the DataCell for "Actions"
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue,),
                        onPressed: () {
                          // Delete the event document from Firestore
                          FirebaseFirestore.instance
                              .collection(sectionTitle == 'Academic Events' ? 'academic_event_details' : 'extracurricular_event_details')
                              .doc(userId)
                              .collection('events')
                              .doc(event.id) // Assuming event.id is the document ID of the event
                              .delete()
                              .then((_) {
                            // Document successfully deleted
                            print('Event deleted');
                            _showSuccessSnackBar(context, "Event Deleted");
                          }).catchError((error) {
                            // An error occurred while deleting the document
                            print('Error deleting event: $error');
                          });
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )
                .toList(),
          ),
        ),
      ],
      ),);
  }
}
