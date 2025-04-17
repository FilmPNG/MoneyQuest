import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/sign_up.dart';
import 'pages/goal_detail.dart';
import 'pages/GoalCalendarPage.dart';
import 'pages/SavingHistoryPage.dart';
import 'pages/AddGoalPage.dart';
import 'pages/Notification.dart';
import 'pages/account_page.dart';
import 'pages/Contactus.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/AddGoalPage': (context) => AddGoalPage(),
        '/Notification': (context) => NotificationPage(),
        '/account_page': (context) => AccountPage(),
        '/Contactus': (context) => ContactPage(),
      },
    );
  }
}
