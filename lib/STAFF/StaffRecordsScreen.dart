import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ise_hub_mp1/FullScreenImage.dart';
import 'package:ise_hub_mp1/DocumentDisplayPage.dart';

enum EventDisplayCriteria {
  month,
  year,
}

class StaffRecordsScreen extends StatefulWidget {
  @override
  _StaffRecordsScreenState createState() => _StaffRecordsScreenState();
}

class _StaffRecordsScreenState extends State<StaffRecordsScreen> {
  EventDisplayCriteria selectedCriteria = EventDisplayCriteria.month;
  late String currentMonthYear;
  late String previousMonthYear;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '8xSIfX1v97WfZcvx8t4nDfXwPQP2';
  @override
  void initState() {
    super.initState();
    // Initialize currentMonthYear when the widget is first created
    updateCurrentMonthYear();
  }

  // Update currentMonthYear based on the current date
  void updateCurrentMonthYear() {
    final now = DateTime.now();
    final monthYearFormat = DateFormat.yMMMM();
    final previousMonth = now.month - 1 == 0 ? 12 : now.month - 1;
    final previousYear = previousMonth == 12 ? now.year - 1 : now.year;
    setState(() {
      currentMonthYear = monthYearFormat.format(now);
      previousMonthYear = monthYearFormat.format(DateTime(previousYear, previousMonth));
    });
  }

  Widget buildMonthStreamBuilder(int year, int month) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('faculty_development_programs')
          .doc(userId)
          .collection('programs')
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month)
          .snapshots(),
      builder: (context, academicSnapshot) {
        if (academicSnapshot.connectionState == ConnectionState.waiting) {
          return Center();
        } else if (academicSnapshot.hasError) {
          return Text('Error: ${academicSnapshot.error}');
        } else {
          List<QueryDocumentSnapshot> academicEvents = academicSnapshot.data!.docs;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('journal_papers').doc(userId).collection('papers')
                .where('year', isEqualTo: year)
                .where('month', isEqualTo: month)
                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.connectionState == ConnectionState.waiting) {
                return Center();
              } else if (extracurricularSnapshot.hasError) {
                return Text('Error: ${extracurricularSnapshot.error}');
              } else {
                List<QueryDocumentSnapshot> extracurricularEvents = extracurricularSnapshot.data!.docs;
                if (academicEvents.isEmpty && extracurricularEvents.isEmpty) {
                  // No academic or extracurricular events for this month, return an empty container
                  return Container();
                } else {
                  // Academic or extracurricular events found for this month, display the heading and events
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedCriteria == EventDisplayCriteria.month)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat.yMMMM().format(DateTime(year, month)),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('staff_account_information')
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Container();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else {
                            List<QueryDocumentSnapshot> users = userSnapshot.data!.docs;
                            return Column(
                              children: users.map((user) {
                                String userId = user.id;
                                String userName = user.get('name') ?? 'Unknown';
                                String userUSN = user.get('id') ?? 'Unknown';
                                return _buildUserSectionMonth(userId, userName, userUSN, month, year);
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  );
                }
              }
            },
          );
        }
      },
    );
  }
  Widget buildYearStreamBuilder(int year) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('academic_event_details')
          .doc(userId)
          .collection('events')
          .where('year', isEqualTo: year)

          .snapshots(),
      builder: (context, academicSnapshot) {
        if (academicSnapshot.connectionState == ConnectionState.waiting) {
          return Center();
        } else if (academicSnapshot.hasError) {
          return Text('Error: ${academicSnapshot.error}');
        } else {
          List<QueryDocumentSnapshot> academicEvents = academicSnapshot.data!.docs;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('journal_papers').doc(userId).collection('papers')
                .where('year', isEqualTo: year)

                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.connectionState == ConnectionState.waiting) {
                return Center();
              } else if (extracurricularSnapshot.hasError) {
                return Text('Error: ${extracurricularSnapshot.error}');
              } else {
                List<QueryDocumentSnapshot> extracurricularEvents = extracurricularSnapshot.data!.docs;
                if (academicEvents.isEmpty && extracurricularEvents.isEmpty) {
                  // No academic or extracurricular events for this month, return an empty container
                  return Container();
                } else {
                  // Academic or extracurricular events found for this month, display the heading and events
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedCriteria == EventDisplayCriteria.year)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                year.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('staff_account_information')
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Container();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else {
                            List<QueryDocumentSnapshot> users = userSnapshot.data!.docs;
                            return Column(
                              children: users.map((user) {
                                String userId = user.id;
                                String userName = user.get('name') ?? 'Unknown';
                                String userUSN = user.get('id') ?? 'Unknown';
                                return _buildUserSectionYear(userId, userName, userUSN, year);
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  );
                }
              }
            },
          );
        }
      },
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Staff Records",style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Radio buttons for criteria selection
            RadioListTile<EventDisplayCriteria>(
              title: Text('Month-wise'),
              value: EventDisplayCriteria.month,
              groupValue: selectedCriteria,
              onChanged: (criteria) {
                // Update the selected criteria
                setState(() {
                  selectedCriteria = criteria!;
                });
              },
            ),
            RadioListTile<EventDisplayCriteria>(
              title: Text('Year-wise'),
              value: EventDisplayCriteria.year,
              groupValue: selectedCriteria,
              onChanged: (criteria) {
                // Update the selected criteria
                setState(() {
                  selectedCriteria = criteria!;
                });
              },
            ),
            // Display the events based on the selected criteria
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     currentMonthYear,
            //     style: TextStyle(
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            if(selectedCriteria==EventDisplayCriteria.month)
              for (int month = 1; month <= 12; month++)
                buildMonthStreamBuilder(2023, month),
            if(selectedCriteria==EventDisplayCriteria.year)
              for (int year = 2024; year >= 2013; year--)
                buildYearStreamBuilder(year),

            //
            // // StreamBuilder for student records
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance.collection(
            //       'student_account_information').snapshots(),
            //   builder: (context, userSnapshot) {
            //     if (userSnapshot.hasData) {
            //       List<QueryDocumentSnapshot> users = userSnapshot.data!.docs;
            //
            //       return Column(
            //         children: users.map((user) {
            //           String userId = user.id;
            //           String userName = user.get('name') ?? 'Unknown';
            //           String userUSN = user.get('usn') ?? 'Unknown';
            //           return _buildUserSection(userId, userName, userUSN);
            //         }).toList(),
            //       );
            //     } else if (userSnapshot.hasError) {
            //       return Text('Error: ${userSnapshot.error}');
            //     } else {
            //       return Center(child: CircularProgressIndicator());
            //     }
            //   },
            // ),


            // StreamBuilder for events in the previous month

            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }



  Widget _buildUserSectionMonth(String userId, String userName, String userUSN,int month,int  year) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('faculty_development_programs')
          .doc(userId)
          .collection('programs')
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month)
          .snapshots(),
      builder: (context, academicSnapshot) {
        if (academicSnapshot.hasData) {
          List<QueryDocumentSnapshot> academicEvents =
              academicSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('journal_papers')
                .doc(userId)
                .collection('papers')
                .where('year', isEqualTo: year)
                .where('month', isEqualTo: month)
                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.hasData) {
                List<QueryDocumentSnapshot> extracurricularEvents =
                    extracurricularSnapshot.data!.docs;

                // Combine academic and extracurricular events
                List<QueryDocumentSnapshot> allEvents = [];
                allEvents.addAll(academicEvents);
                allEvents.addAll(extracurricularEvents);

                // Apply selected criteria to filter events
                List<QueryDocumentSnapshot> filteredEvents =
                filterEvents(allEvents,year,month);

                return _buildEventSection('FDP', userId, userName,
                    userUSN, filteredEvents);
              } else if (extracurricularSnapshot.hasError) {
                return Text('Error: ${extracurricularSnapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (academicSnapshot.hasError) {
          return Text('Error: ${academicSnapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }
  Widget _buildUserSectionYear(String userId, String userName, String userUSN,int  year) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('faculty_development_programs')
          .doc(userId)
          .collection('programs')
          .where('year', isEqualTo: year)
          .snapshots(),
      builder: (context, academicSnapshot) {
        if (academicSnapshot.hasData) {
          List<QueryDocumentSnapshot> academicEvents =
              academicSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('journal_papers')
                .doc(userId)
                .collection('papers')
                .where('year', isEqualTo: year)
                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.hasData) {
                List<QueryDocumentSnapshot> extracurricularEvents =
                    extracurricularSnapshot.data!.docs;

                // Combine academic and extracurricular events
                List<QueryDocumentSnapshot> allEvents = [];
                allEvents.addAll(academicEvents);
                allEvents.addAll(extracurricularEvents);

                // Apply selected criteria to filter events
                List<QueryDocumentSnapshot> filteredEvents =
                filterEvents(allEvents,year,0);
                // if(sectionTitle=='AcademicEvents')

                return _buildEventSection('FDP', userId, userName,
                    userUSN, filteredEvents);

              } else if (extracurricularSnapshot.hasError) {
                return Text('Error: ${extracurricularSnapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else if (academicSnapshot.hasError) {
          return Text('Error: ${academicSnapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }

  Widget _buildEventSection(String sectionTitle,
      String userId,
      String userName,
      String userUSN,
      List<QueryDocumentSnapshot> events) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowHeight: 60,
        columns: [
          DataColumn(label: Text('Staff Name')),
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Event Type')),
          DataColumn(label: Text('Event Name')),
          DataColumn(label: Text('Organizer')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Venue')),
          DataColumn(
            label: Text(
              'Photo Description',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Photo ',
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
        ],
        rows: events.map((event) {
          var eventData = event.data() as Map<String, dynamic>;
//          bool hasAICTEPoints = eventData.containsKey('aicte') && eventData['aicte'] != null && eventData['aicte'].isNotEmpty;

          // Decide the event type based on AICTE points
       //   String eventType = hasAICTEPoints ? 'Academic Event' : 'Extracurricular Event';

          return DataRow(
            cells: [
              DataCell(Text(userName)),
              DataCell(Text(userUSN)),
              DataCell(Text(sectionTitle)),
              DataCell(Text(eventData['eventName'] ?? '-')),
              DataCell(Text(eventData['organizer'] ?? '-')),
              DataCell(Text(eventData['date'] ?? '-')),
              DataCell(Text(eventData['venue'] ?? '-')),
              DataCell(Text(eventData['photoDescription'] ?? '-')),

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
                        return Center();
                      }
                    },
                  ),
                ),),
              DataCell(Text(eventData['documentDescription'] ?? '-')),
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
            ],
          );
        }).toList(),
      ),
    );
  }

  List<QueryDocumentSnapshot> filterEvents(List<QueryDocumentSnapshot> events,int year,int month) {
    if (selectedCriteria == EventDisplayCriteria.month) {
      // Filter events for the current month and previous month
      final now = DateTime.now();
      final currentMonth = now.month;
      return events.where((event) {
        var eventData = event.data() as Map<String, dynamic>;
        dynamic dateValue = eventData['date'];
        DateTime eventDate = dateValue is Timestamp
            ? dateValue.toDate()
            : DateTime.parse(dateValue);
        return eventDate.year == year && eventDate.month == month;
      }).toList();
    } else if (selectedCriteria == EventDisplayCriteria.year) {
      // Filter events for the current year
      final now = DateTime.now();
      final currentYear = now.year;

      return events.where((event) {
        var eventData = event.data() as Map<String, dynamic>;
        dynamic dateValue = eventData['date'];
        DateTime eventDate = dateValue is Timestamp
            ? dateValue.toDate()
            : DateTime.parse(dateValue);
        return eventDate.year >= currentYear - 5;
      }).toList();
    } else {
      // Return all events
      return events;
    }
  }

}