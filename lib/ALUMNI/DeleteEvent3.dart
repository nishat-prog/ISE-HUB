import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:ise_hub_mp1/FullScreenImage.dart';
import 'package:ise_hub_mp1/DocumentDisplayPage.dart';
import 'UpdateHS.dart';
import 'UpdateWP.dart';

class DeleteEvent3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile",style: TextStyle(color:Colors.white),),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color:Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child:DeleteEvent(),
        )
    );
  }
}
String userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';
class DeleteEvent extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
 //   String userId = FirebaseAuth.instance.currentUser?.uid ?? 'defaultUserId';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('higher_studies')
                .doc(userId)
                .collection('courses')
                .snapshots(),
            builder: (context, academicSnapshot) {
              if (academicSnapshot.hasData) {
                List<QueryDocumentSnapshot> academicEvents =
                    academicSnapshot.data!.docs;

                return _buildEventSection1(context,'Higher Studies', academicEvents);
              } else if (academicSnapshot.hasError) {
                return Text('Error: ${academicSnapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('work_profile')
                .doc(userId)
                .collection('companies')
                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.hasData) {
                List<QueryDocumentSnapshot> extracurricularEvents =
                    extracurricularSnapshot.data!.docs;

                return _buildEventSection2(context,
                    'Work Profile', extracurricularEvents);
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


  Widget YourErrorWidget() {
    return Icon(
      Icons.error,
      color: Colors.red,
    );
  }

  Widget _buildEventSection1(
      BuildContext context,
      String sectionTitle,
      List<QueryDocumentSnapshot> events) {
    return Column(
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
            dataRowHeight: 60,
            columns: [
              DataColumn(
                label: Text(
                  'Degree',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Major',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'University',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Location',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              DataColumn(
                label: Text(
                  'Grades',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              // DataColumn(
              //   label: Text(
              //     'Photo',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // DataColumn(
              //   label: Text(
              //     'Document Description',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // DataColumn(
              //   label: Text(
              //     'Document',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),

            ],
            rows: events
                .map(
                    (event) => DataRow(
                  cells: [
                    DataCell(Text(event['Degree'])),
                    DataCell(Text(event['Major'])),
                    DataCell(Text(event['University'])),
                    DataCell(Text(event['Location'])),
                    DataCell(Text(event['Grade'])),
                    // DataCell(
                    //   GestureDetector(onTap: () {
                    //     // Navigate to a new page to display the image in full size
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => FullScreenImagePage(imageUrl: event['imageUrl']),
                    //       ),
                    //     );
                    //   },
                    //     child:
                    //     Image.network(
                    //       event['imageUrl'],
                    //       fit: BoxFit.fill,
                    //       height:45,
                    //       width:45,
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Center(); // Replace with your error widget
                    //       },
                    //       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //         if (loadingProgress == null) {
                    //           return child;
                    //         } else {
                    //           return Center();
                    //         }
                    //       },
                    //     ),
                    //   ),),
                    // DataCell(Text(event['documentDescription'])),
                    // DataCell(
                    //   event['documentUrl'] != ''
                    //       ? GestureDetector(
                    //     onTap: () {
                    //       // Handle the onTap event, such as opening the document in a new page or a viewer
                    //       // For example:
                    //       print(event['documentUrl']);
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => DocumentDisplayPage(documentUrl: event['documentUrl']),
                    //         ),
                    //       );
                    //
                    //     },
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.description, color: Colors.blue),
                    //         SizedBox(width: 5),
                    //         Text(
                    //           'View Document',
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             color: Colors.blue,
                    //             decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    //       : SizedBox(
                    //     child:Text('-'),
                    //   ), // If documentUrl is null, render an empty SizedBox
                    // ),
                    //
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,),
                          onPressed: () {
                            print(sectionTitle);
                            // Navigate to the appropriate update page

                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardPage()));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateHS(
                                  eventDetails: EventDetails1(
                                    eventId: event['eventId'],
                                    degName: event['Degree'],
                                    maj: event['Major'],
                                    uni: event['University'],
                                    //  dept: event['department'],
                                    loc: event['Location'],
                                    grade:event['Grade'],
                                    // qlf:event['qualification'],
                                    //skill: event['skills'],
                                    // doc:event['documentUrl'],
                                  ),
                                ),
                              ),
                            );


                          },

                          child: Text('Update',
                            style:TextStyle(
                              color:Colors.white,
                            ),),
                        ),
                      ),
                    ),
                  ],
                )
            ).toList(),
          ),
        ),],);}

  Widget _buildEventSection2(
      BuildContext context,
      String sectionTitle,
      List<QueryDocumentSnapshot> events) {
    return Column(
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
            dataRowHeight: 60,
            columns: [
              DataColumn(
                label: Text(
                  'Company',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Designation',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Department',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Company location',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              DataColumn(
                label: Text(
                  'Experience',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Qualification',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Skills',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              // DataColumn(
              //   label: Text(
              //     'Photo',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // DataColumn(
              //   label: Text(
              //     'Document Description',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // DataColumn(
              //   label: Text(
              //     'Document',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              //   ),
              // ),

            ],
            rows: events
                .map(
                    (event) => DataRow(
                  cells: [
                    DataCell(Text(event['companyName'])),
                    DataCell(Text(event['designation'])),
                    DataCell(Text(event['experience'])),
                    DataCell(Text(event['department'])),
                    DataCell(Text(event['location'])),
                    DataCell(Text(event['qualification'])),
                    DataCell(Text(event['skills'])),
                    // DataCell(
                    //   GestureDetector(onTap: () {
                    //     // Navigate to a new page to display the image in full size
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => FullScreenImagePage(imageUrl: event['imageUrl']),
                    //       ),
                    //     );
                    //   },
                    //     child:
                    //     Image.network(
                    //       event['imageUrl'],
                    //       fit: BoxFit.fill,
                    //       height:45,
                    //       width:45,
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Center(); // Replace with your error widget
                    //       },
                    //       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //         if (loadingProgress == null) {
                    //           return child;
                    //         } else {
                    //           return Center();
                    //         }
                    //       },
                    //     ),
                    //   ),),
                    // DataCell(Text(event['documentDescription'])),
                    // DataCell(
                    //   event['documentUrl'] != ''
                    //       ? GestureDetector(
                    //     onTap: () {
                    //       // Handle the onTap event, such as opening the document in a new page or a viewer
                    //       // For example:
                    //       print(event['documentUrl']);
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => DocumentDisplayPage(documentUrl: event['documentUrl']),
                    //         ),
                    //       );
                    //
                    //     },
                    //     child: Row(
                    //       children: [
                    //         Icon(Icons.description, color: Colors.blue),
                    //         SizedBox(width: 5),
                    //         Text(
                    //           'View Document',
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             color: Colors.blue,
                    //             decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    //       : SizedBox(
                    //     child:Text('-'),
                    //   ), // If documentUrl is null, render an empty SizedBox
                    // ),
                    //
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue,),
                          onPressed: () {
                            // Delete the event document from Firestore
                            FirebaseFirestore.instance
                                .collection(sectionTitle == 'Work Profile' ? 'work_profile' : 'higher_studies')
                                .doc(userId)
                                .collection(sectionTitle == 'Work Profile' ? 'companies' : 'courses')
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
                )
            ).toList(),
          ),
        ),],);}
}
