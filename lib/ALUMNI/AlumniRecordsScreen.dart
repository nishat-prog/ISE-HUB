import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlumniRecordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alumni",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('alumni_account_information').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> users = snapshot.data!.docs;

              return Column(
                children: users.map((user) {
                  String userId = user.id;
                  String userName = user['name'];
                  String id=user['id'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                         'Name: $userName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'ID : $id',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      EventList3(userId: userId),
                    ],
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class EventList3 extends StatelessWidget {
  final String userId;

  const EventList3({required this.userId});

  @override
  Widget build(BuildContext context) {
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

                return _buildEventSection1(
                    context, 'Higher Studies', academicEvents);
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

                return _buildEventSection2(
                    context, 'Work Profile', extracurricularEvents);
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

                  ],
                )
            ).toList(),
          ),
        ),],);}
}


