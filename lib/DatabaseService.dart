import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchStudentData(String userId) async {
    try {
      // Replace 'users' with the name of your Firestore collection
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('student_account_information').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        // Return a default value or handle the case when no data is found
        return {
          'name': 'Unknown',
          'usn': 'Unknown',
          'phoneNumber': 'Unknown',
          'email': 'Unknown',
          'address': 'Unknown',
          'photoUrl':'Unknown',
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Return a default value or handle the error case
      return {
        'name': 'Unknown',
        'usn': 'Unknown',
        'phoneNumber': 'Unknown',
        'email': 'Unknown',
        'address': 'Unknown',
        'photoUrl':'Unknown',
      };
    }
  }
  Future<Map<String, dynamic>> fetchStaffData(String userId) async {
    try {
      // Replace 'users' with the name of your Firestore collection
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('staff_account_information').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        // Return a default value or handle the case when no data is found
        return {
          'name': 'Unknown',
          'id': 'Unknown',
          'phoneNumber': 'Unknown',
          'email': 'Unknown',
          'address': 'Unknown',
          'photoUrl':'Unknown',
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Return a default value or handle the error case
      return {
        'name': 'Unknown',
        'id': 'Unknown',
        'phoneNumber': 'Unknown',
        'email': 'Unknown',
        'address': 'Unknown',
        'photoUrl':'Unknown',
      };
    }
  }
  Future<Map<String, dynamic>> fetchAlumniData(String userId) async {
    try {
      print("hello");
      // Replace 'users' with the name of your Firestore collection
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('alumni_account_information').doc(userId).get();
print(snapshot);
      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        // Return a default value or handle the case when no data is found
        print("hi");
        return {
          'name': '',
          'id': '',
          'phoneNumber': '',
          'email': '',
          'address': '',
          'photoUrl':'',
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Return a default value or handle the error case
      return {
        'name': '',
        'id': '',
        'phoneNumber': 'Unknown',
        'email': 'Unknown',
        'address': 'Unknown',
        'photoUrl':'Unknown',
      };
    }
  }
  Future<Map<String, dynamic>> fetchAcademicDetails(String userId,String eventId) async {
    try {
      // Replace 'users' with the name of your Firestore collection
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('academic_event_details').doc(userId).collection('events').doc(eventId).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        // Return a default value or handle the case when no data is found
        return {
          'eventName':'Unknown',
          'organizer':'Unknown',
          'date':'Unknown',
          'venue':'Unknown',
          'aicte':'Unknown',
          'photoDescription':'Unknown',
          'documentDescription':'Unknown'
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Return a default value or handle the error case
      return {
        'eventName':'Unknown',
        'organizer':'Unknown',
        'date':'Unknown',
        'venue':'Unknown',
        'aicte':'Unknown',
        'photoDescription':'Unknown',
        'documentDescription':'Unknown'
      };
    }
  }
  Future<void> updateStudentProfile(
      String userId,
      String name,
      String usn,
      String phone,
      String email,
      String address,
      String photoUrl,
     // String photoURL,

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
      await _firestore.collection('student_account_information').doc(userId).update({
        'name': name,
        'usn': usn,
        'phoneNumber': phone,
        'email': email,
        'address': address,
        'photoUrl':photoUrl

      });
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }
  Future<void> updateStaffProfile(
      String userId,
      String name,
      String usn,
      String phone,
      String email,
      String address,
      String photoUrl,
      // String photoURL,

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
      await _firestore.collection('staff_account_information').doc(userId).update({
        'name': name,
        'id': usn,
        'phoneNumber': phone,
        'email': email,
        'address': address,
        'photoUrl':photoUrl

      });
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }

  Future<void> updateAcademicEvent(
      String userId,
      String eventId,
      String eventName,
      String organizer,
      String date,
      String venue,
      String aicte,
      String photoDescription,
      String imgUrl,
      String documentDescription,
      String doc,
      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
      await _firestore.collection('academic_event_details').doc(userId).collection('events').doc(eventId).update({
       'eventName':eventName,
        'organizer':organizer,
        'date':date,
        'venue':venue,
        'aicte':aicte,
        'photoDescription':photoDescription,
        'imageUrl':imgUrl,
        'documentDescription':documentDescription,
        'documentUrl':doc,

      });
    } catch (e) {
      print('Error updating academic event: $e');
      throw Exception('Failed to update academic event');
    }


  Future<void> updateUserPhoto(String userId, String photoUrl) async {
    try {
      await _firestore.collection('student_account_information').doc(userId).update({'photoUrl': photoUrl});
    } catch (e) {
      print('Error updating user photo: $e');
      // Handle the error gracefully, e.g., show an error message to the user
    }
  }
}
  Future<void> updateExtraCurricularEvent(
      String userId,
      String eventId,
      String eventName,
      String organizer,
      String date,
      String venue,
      String photoDescription,
      String imgUrl,
      String documentDescription,
      String doc,

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
      await _firestore.collection('extracurricular_event_details').doc(userId).collection('events').doc(eventId).update({
        'eventName':eventName,
        'organizer':organizer,
        'date':date,
        'venue':venue,
        'photoDescription':photoDescription,
        'imageUrl':imgUrl,
        'documentDescription':documentDescription,
        'documentUrl':doc,

      });
    } catch (e) {
      print('Error updating academic event: $e');
      throw Exception('Failed to update academic event');
    }
}
  Future<void> updateFDPEvent(
      String userId,
      String eventId,
      String eventName,
      String organizer,
      String date,
      String venue,
      String photoDescription,
      String img,
      String documentDescription,
      String doc,

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
      await _firestore.collection('faculty_development_programs').doc(userId).collection('programs').doc(eventId).update({
        'eventName':eventName,
        'organizer':organizer,
        'date':date,
        'venue':venue,
        'photoDescription':photoDescription,
        'imageUrl':img,
        'documentDescription':documentDescription,
        'documentUrl':doc,

      });
    } catch (e) {
      print('Error updating academic event: $e');
      throw Exception('Failed to update academic event');
    }
  }

  Future<void> updateJPEvent(
      String userId,
      String eventId,
      String eventName,
      String organizer,
      String date,
      String venue,
      String photoDescription,
      String documentDescription,

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
      await _firestore.collection('journal_papers').doc(userId).collection('papers').doc(eventId).update({
        'eventName':eventName,
        'organizer':organizer,
        'date':date,
        'venue':venue,
        'photoDescription':photoDescription,
        'documentDescription':documentDescription

      });
    } catch (e) {
      print('Error updating academic event: $e');
      throw Exception('Failed to update academic event');
    }
  }

  Future<void> updateWP(
      String userId,
      String eventId,
      String cName,
      String desgn,
      String exp,
      String dept,
      String loc,
      String qlf,
      String skill

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore
     await FirebaseFirestore.instance
          .collection('work_profile')
          .doc(userId).collection('companies').doc(eventId).update({
        'companyName': cName,
        'designation': desgn,
        'experience': exp,
        'department': dept,
        'location': loc,
        'qualification' : qlf,
        'skills':skill

      });
    } catch (e) {
      print('Error updating academic event: $e');
      throw Exception('Failed to update academic event');
    }
  }

  Future<void> updateHS(
      String userId,
      String eventId,
      String degName,
      String maj,
      String uni,
      String loc,
      String grade,

      ) async {
    try {
      // Implement your logic to update the user profile in Firestore

      await FirebaseFirestore.instance
          .collection('higher_studies')
          .doc(userId)
          .collection('courses').doc(eventId).update({

      'Degree': degName,
      'Major': maj,
      'University': uni,
      'Location': loc,
      'Grade': grade,

      });
    } catch (e) {
      print('Error updating academic event: $e');
      throw Exception('Failed to update academic event');
    }
  }
}