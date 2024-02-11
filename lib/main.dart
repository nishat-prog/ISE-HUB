import 'package:ise_hub_mp1/ALUMNI/AddEvent3.dart';
import 'package:ise_hub_mp1/ALUMNI/AlumniRecordsScreen.dart';
import 'package:ise_hub_mp1/ALUMNI/DeleteEvent3.dart';
import 'package:ise_hub_mp1/ALUMNI/DisplayUserEvents3.dart';
import 'package:ise_hub_mp1/ALUMNI/EditProfile3.dart';
import 'package:ise_hub_mp1/ALUMNI/HSProfile.dart';
import 'package:ise_hub_mp1/ALUMNI/StaffScreen.dart';
import 'package:ise_hub_mp1/ALUMNI/UpdateExistingEvent3.dart';
import 'package:ise_hub_mp1/ALUMNI/UpdateProfile3.dart';
import 'package:ise_hub_mp1/ALUMNI/UpdateWP.dart';
import 'package:ise_hub_mp1/ALUMNI/ViewProfile3.dart';
import 'package:ise_hub_mp1/ALUMNI/WPProfile.dart';
import 'package:ise_hub_mp1/ALUMNI/alumni_dashboard.dart';
import 'package:ise_hub_mp1/STAFF/AddEvent2.dart';
import 'package:ise_hub_mp1/DeleteAccount.dart';
import 'package:ise_hub_mp1/STAFF/DeleteEvent2.dart';
import 'package:ise_hub_mp1/STAFF/StaffRecordsScreen.dart';
import 'package:ise_hub_mp1/STAFF/StudentRecords.dart';
import 'package:ise_hub_mp1/STAFF/UpdateExistingEvent2.dart';
import 'package:ise_hub_mp1/STUDENT/DeleteEvent.dart';
import 'package:ise_hub_mp1/STAFF/DisplayUserEvents2.dart';
import 'package:ise_hub_mp1/STAFF/EditProfile2.dart';
import 'package:ise_hub_mp1/STUDENT/UpdateExtraCurricularEvent.dart';
import 'package:ise_hub_mp1/StudentRecordsScreen.dart';
import 'package:ise_hub_mp1/STAFF/UpdateProfile2.dart';
import 'package:ise_hub_mp1/STAFF/ViewProfile2.dart';
import 'package:ise_hub_mp1/dummy.dart';
import 'package:ise_hub_mp1/STAFF/fdpProfile.dart';
import 'package:ise_hub_mp1/STAFF/jpProfile.dart';
import 'package:ise_hub_mp1/STAFF/staff_dashboard.dart';
import 'package:ise_hub_mp1/STUDENT/UpdateAcademicEvent.dart';
import 'package:ise_hub_mp1/STUDENT/UpdateExtraCurricularEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ise_hub_mp1/STUDENT/AddEvent.dart';
import 'package:ise_hub_mp1/STUDENT/DisplayUserEvents1.dart';
import 'package:ise_hub_mp1/STUDENT/EditProfile.dart';
import 'package:ise_hub_mp1/STUDENT/ExtraCurricularProfile.dart';
import 'package:ise_hub_mp1/FirstPage.dart';
import 'package:ise_hub_mp1/STUDENT/AcademicsProfile.dart';
import 'package:ise_hub_mp1/STUDENT/UpdatExistingEvent.dart';
import 'package:ise_hub_mp1/STUDENT/UpdateProfile.dart';
import 'package:ise_hub_mp1/STUDENT/ViewProfile.dart';
import 'package:ise_hub_mp1/STUDENT/student_dashboard.dart';
import 'package:ise_hub_mp1/STUDENT/login.dart';
import 'package:ise_hub_mp1/STAFF/login2.dart';
import 'package:ise_hub_mp1/STUDENT/register.dart';
import 'package:ise_hub_mp1/STAFF/register2.dart';
import 'package:ise_hub_mp1/ALUMNI/register3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ise_hub_mp1/ALUMNI/login3.dart';
import 'package:ise_hub_mp1/STUDENT/DeleteEvent.dart';

void main() async {
 // SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MaterialApp(
    debugShowCheckedModeBanner: false,
    home: //(FirebaseAuth.instance.currentUser != null)
       // ? DashboardPage1()
       // :
    FirstPage(),
    routes: {
      'FirstPage': (context) => FirstPage(),

      'login1': (context) => MyLogin1(),
      'register1': (context) => MyRegister1(),

      'login2': (context) => MyLogin2(),
      'register2': (context) => MyRegister2(),

      'login3': (context) => MyLogin3(),
      'register3': (context) => MyRegister3(),

      'db': (context) => DashboardPage1(),
      'staff_dashboard': (context) => DashboardPage2(),
      'alumni_dashboard':(context)=>DashboardPage3(),

      'ViewProfile': (context) => ProfilePage(),
      'ViewProfile2': (context) => ProfilePage2(),
      'ViewProfile3': (context) => ProfilePage3(),

      'EditProfile': (context) => ProfileEditScreen(
        initialProfile: Profile(
          name: '',
          usn:'',// Set your initial values here
          phoneNumber: '',
          email: '',
          address: '',
        ),
      ),
      'EditProfile2': (context) => ProfileEditScreen2(
        initialProfile: Profile2(
          name: '',
          usn:'',// Set your initial values here
          phoneNumber: '',
          email: '',
          address: '',
        ),
      ),
      'EditProfile3': (context) => ProfileEditScreen3(
        initialProfile: Profile3(
          name: '',
          usn:'',// Set your initial values here
          phoneNumber: '',
          email: '',
          address: '',
        ),
      ),

      'dummy': (context) => Dummy(),

      'DisplayUserEvents': (context) => EventListPage(),
      'DisplayUserEvents2': (context) => EventListPage2(),
      'DisplayUserEvents3': (context) => EventListPage3(),


      'UpdateProfile': (context) => UpdateProfile(),
      'UpdateProfile2': (context) => UpdateProfile2(),
      'UpdateProfile3': (context) => UpdateProfile3(),

      'AddEvent': (context) => AddEvent(),
      'AddEvent2': (context) => AddEvent2(),
      'AddEvent3': (context) => AddEvent3(),

      'DeleteEvent': (context) => DeleteEvent1(),
      'DeleteEvent2': (context) => DeleteEvent2(),
      'DeleteEvent3': (context) => DeleteEvent3(),


      'AcademicsProfile': (context) => AcademicsProfile(),
      'ExtraCurricularProfile': (context) => ExtraCurricularProfile(),

      'fdpProfile': (context) => FDPProfile(),
      'jpProfile': (context) => JPProfile(),

      'HSProfile' : (context)=>HSProfile(),
      'WPProfile' : (context)=>WPProfile(),

      'UpdatExistingEvent': (context) => UpdateEventListPage(),
      'UpdateExistingEvent2': (context) => UpdateEventListPage2(),
      'UpdateExistingEvent3': (context) => UpdateExisitingEvent3(),


      'UpdateAcademicEvent': (context) => UpdateAcademicEventPage(
        eventDetails: EventDetails(
          // Initialize with relevant event details
          eventId: '',
          eventName: '',
          organizer: '',
          date: '',
          venue: '',
          aicte: '',
          photoDescription: '',
          img:'',
          documentDescription: '',
          doc:'',
        ),
      ),
      // 'UpdateExtracurricularEvent': (context) => UpdateExtraCurricularEventPage(
      //   eventDetails: EventDetails2(
      //     eventId: '',
      //     eventName: '',
      //     organizer: '',
      //     date: '',
      //     venue: '',
      //     photoDescription: '',
      //     img:'',
      //     documentDescription: '',
      //     doc:'',
      //   ),
      // ),

      'StudentRecordsScreen':(context)=>StudentRecordsScreen(),
      'StudentRecords':(context)=>StudentRecords(),
      'StaffRecordsScreen':(context)=>StaffRecordsScreen(),
      'StaffScreen':(context)=>StaffScreen(),
      'AlumniRecordsScreen' :(context)=>AlumniRecordsScreen(),


      'DeleteAccount': (context) => DeleteAccountPage(),
    },
  ));
}
