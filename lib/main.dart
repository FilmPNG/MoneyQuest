import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/sign_up.dart';
import 'pages/goal_detail.dart'; // เพิ่ม import
import 'pages/GoalCalendarPage.dart';
import 'pages/SavingHistoryPage.dart';
import 'pages/AddGoalPage.dart';
import 'pages/Notification.dart';
import 'pages/account_page.dart';
import 'pages/Contactus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/goal_detail': (context) => GoalDetailPage(), 
        '/GoalCalendarPage': (context) => GoalCalendarPage(), 
        '/SavingHistoryPage': (context) => SavingHistoryPage(),
        '/AddGoalPage': (context) => AddGoalPage(),
        '/Notification': (context) => NotificationPage(),
        '/account_page': (context) => AccountPage(),
        '/Contactus': (context) => ContactPage(),
      },
    );
  }
}
