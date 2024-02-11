import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum EventDisplayCriteria {
  month,
  year,
}

class Dummy extends StatefulWidget {
  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  EventDisplayCriteria selectedCriteria = EventDisplayCriteria.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Records"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          RadioListTile<EventDisplayCriteria>(
            title: Text('Month-wise'),
            value: EventDisplayCriteria.month,
            groupValue: selectedCriteria,
            onChanged: (criteria) {
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
              setState(() {
                selectedCriteria = criteria!;
              });
            },
          ),
          Expanded(
            child: StudentRecordsList(
              checkYear: 2023,
              selectedCriteria: selectedCriteria,
            ),
          ),
        ],
      ),
    );
  }
}

class StudentRecordsList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int checkYear;
  final EventDisplayCriteria selectedCriteria;

  StudentRecordsList({
    required this.checkYear,
    required this.selectedCriteria,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('student_account_information').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            List<QueryDocumentSnapshot> users = userSnapshot.data!.docs;

            return Column(
              children: users
                  .map((user) => _buildUserSection(
                userId: user.id,
                userName: user.get('name') ?? 'Unknown',
                userUSN: user.get('usn') ?? 'Unknown',
              ))
                  .toList(),
            );
          } else if (userSnapshot.hasError) {
            return Text('Error: ${userSnapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildUserSection({
    required String userId,
    required String userName,
    required String userUSN,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('academic_event_details')
          .doc(userId)
          .collection('events')
          .snapshots(),
      builder: (context, academicSnapshot) {
        if (academicSnapshot.hasData) {
          List<QueryDocumentSnapshot> academicEvents = academicSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('extracurricular_event_details')
                .doc(userId)
                .collection('events')
                .snapshots(),
            builder: (context, extracurricularSnapshot) {
              if (extracurricularSnapshot.hasData) {
                List<QueryDocumentSnapshot> extracurricularEvents =
                    extracurricularSnapshot.data!.docs;

                List<QueryDocumentSnapshot> allEvents = [];
                allEvents.addAll(academicEvents);
                allEvents.addAll(extracurricularEvents);

                return _buildEventSection(
                  userId: userId,
                  userName: userName,
                  userUSN: userUSN,
                  events: allEvents,
                );
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

  Widget _buildEventSection({
    required String userId,
    required String userName,
    required String userUSN,
    required List<QueryDocumentSnapshot> events,
  }) {
    Map<String, List<QueryDocumentSnapshot>> organizedEvents = {};

    String formatDate(String date) {
      DateTime dateTime = DateTime.parse(date);
      if (selectedCriteria == EventDisplayCriteria.year) {
        return "${dateTime.year}";
      } else {
        return "${DateFormat.yMMMM().format(dateTime)}";
      }
    }

    for (QueryDocumentSnapshot event in events) {
      if (_filterEventsByMonth(event, selectedCriteria, checkYear)) {
        var eventData = event.data() as Map<String, dynamic>;
        String eventDate = eventData['date'] ?? '';

        if (eventDate.isNotEmpty) {
          String formattedValue = formatDate(eventDate);

          if (!organizedEvents.containsKey(formattedValue)) {
            organizedEvents[formattedValue] = [];
          }
          organizedEvents[formattedValue]!.add(event);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: organizedEvents.entries.map((entry) {
        String formattedValue = entry.key;
        List<QueryDocumentSnapshot> events = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                formattedValue,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildEventListSection(
              eventType: selectedCriteria == EventDisplayCriteria.month
                  ? 'Events in $formattedValue'
                  : 'Events in $formattedValue',
              userName: userName,
              userUSN: userUSN,
              events: events,
              selectedCriteria: selectedCriteria
            ),
          ],
        );
      }).toList(),
    );
  }

  bool _filterEventsByMonth(
      QueryDocumentSnapshot event, EventDisplayCriteria criteria, int checkYear) {
    var eventData = event.data() as Map<String, dynamic>;
    String eventDate = eventData['date'] ?? '';

    if (eventDate.isNotEmpty) {
      DateTime dateTime = DateTime.parse(eventDate);

      if (criteria == EventDisplayCriteria.month) {
        return dateTime.year == checkYear && dateTime.month == DateTime.now().month;
      } else {
        return dateTime.year == checkYear;
      }
    }

    return false;
  }

  Widget _buildEventListSection({
    required String eventType,
    required String userName,
    required String userUSN,
    required List<QueryDocumentSnapshot> events,
    required EventDisplayCriteria selectedCriteria,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Events',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'USN',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Type',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
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
                  'Document Description',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: events.map((event) {
              var eventData = event.data() as Map<String, dynamic>;

              return DataRow(
                cells: [
                  DataCell(Text(userName)),
                  DataCell(Text(userUSN)),
                  DataCell(Text(eventType)),
                  DataCell(Text(eventData['eventName'] ?? 'Unknown')),
                  DataCell(Text(eventData['organizer'] ?? 'Unknown')),
                  DataCell(Text(eventData['date'] ?? 'Unknown')),
                  DataCell(Text(eventData['venue'] ?? 'Unknown')),
                  DataCell(Text(eventData['aicte'] ?? 'Unknown')),
                  DataCell(Text(eventData['photoDescription'] ?? 'Unknown')),
                  DataCell(Text(eventData['documentDescription'] ?? 'Unknown')),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
