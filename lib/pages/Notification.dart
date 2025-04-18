import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_savemoney/notification_service.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // List to store notification messages
  List<String> messages = [];
  double totalSaved = 0.0;
  String userName = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchTotalSaved();
    _fetchUserName();
    _checkGoalsAndNotify();

    // Set up timer to periodically check for notifications every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted) return;
      await _fetchTotalSaved();
      await _checkGoalsAndNotify();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Fetches the total amount saved across all goals
  Future<void> _fetchTotalSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('goals')
            .where('userId', isEqualTo: uid)
            .get();

    double sum = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final saved = (data['savedAmount'] ?? 0).toDouble();
      sum += saved;
    }

    if (!mounted) return;
    setState(() {
      totalSaved = sum;
    });
  }

  /// Fetches the user's name from Firestore
  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (!mounted || data == null) return;
    setState(() {
      userName = data['name'] ?? '';
    });
  }

  /// Checks if notifications should be triggered for any goals
  Future<void> _checkGoalsAndNotify() async {
    final now = DateTime.now();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('goals')
            .where('userId', isEqualTo: uid)
            .get();

    List<String> newMessages = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name'] ?? 'ไม่ระบุชื่อ';
      final price = (data['price'] ?? 0).toDouble();
      final saved = (data['savedAmount'] ?? 0).toDouble();
      final savingMethod = data['savingMethod'] ?? 'daily';

      final createdAtRaw = data['createdAt'];
      final createdAt =
          (createdAtRaw is Timestamp)
              ? createdAtRaw.toDate()
              : now.subtract(const Duration(days: 1));

      final targetDate = DateTime.tryParse(data['targetDate'] ?? '') ?? now;
      final duration = targetDate.difference(createdAt).inDays;
      if (duration <= 0) continue;

      // Calculate elapsed time based on saving method
      int elapsedUnits =
          savingMethod == 'daily'
              ? now.difference(createdAt).inDays
              : savingMethod == 'weekly'
              ? (now.difference(createdAt).inDays / 7).floor()
              : (now.difference(createdAt).inDays / 30).floor();

      // Calculate expected savings based on elapsed time
      double expected =
          savingMethod == 'daily'
              ? (price / duration) * elapsedUnits
              : savingMethod == 'weekly'
              ? (price / (duration / 7)) * elapsedUnits
              : (price / (duration / 30)) * elapsedUnits;

      final lastNotify = data['lastNotify']?.toDate();
      final lastNotifyTime =
          lastNotify ?? DateTime.fromMillisecondsSinceEpoch(0);

      // Determine if notification should be triggered based on saving method
      bool shouldNotify = false;

      if (savingMethod == 'daily') {
        // Daily notification: check every 10 seconds for testing
        shouldNotify = now.difference(lastNotifyTime).inSeconds >= 10;
      } else if (savingMethod == 'weekly') {
        // Weekly notification: every Sunday at 10:00
        final isToday = lastNotify == null || !_isSameDay(lastNotifyTime, now);
        final isSunday = now.weekday == DateTime.sunday;
        final isTargetTime =
            now.hour == 10 && now.minute >= 0 && now.minute < 5;

        shouldNotify = isSunday && isTargetTime && isToday;
      } else if (savingMethod == 'monthly') {
        // Monthly notification: 1st day of month at 10:00
        final isToday = lastNotify == null || !_isSameDay(lastNotifyTime, now);
        final isFirstOfMonth = now.day == 1;
        final isTargetTime =
            now.hour == 10 && now.minute >= 0 && now.minute < 5;

        shouldNotify = isFirstOfMonth && isTargetTime && isToday;
      }

      // For testing: Show current time conditions
      print(
        'Method: $savingMethod, Day: ${now.day}, Hour: ${now.hour}, '
        'Minute: ${now.minute}, ShouldNotify: $shouldNotify',
      );

      if (saved < expected && shouldNotify) {
        final remaining = (expected - saved).clamp(1, price).toDouble();
        final msg = _buildNotificationMessage(savingMethod, name, remaining);
        newMessages.add(msg);

        // Update last notification timestamp
        await doc.reference.update({'lastNotify': now});

        // Show system notification
        await NotificationService.showNotification('แจ้งเตือนการออมเงิน', msg);

        // Show in-app notification
        if (!mounted) continue;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: Colors.orange.shade700,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
      }
    }

    if (!mounted || newMessages.isEmpty) return;
    setState(() {
      messages.addAll(newMessages);
    });
  }

  /// Helper to check if two dates are the same calendar day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Build notification message based on saving method
  String _buildNotificationMessage(String method, String name, double amount) {
    final formattedAmount = amount.toStringAsFixed(2);
    switch (method) {
      case 'daily':
        return 'วันนี้: โปรดอย่าลืมออมเงินสำหรับ "$name" จำนวน $formattedAmount ฿';
      case 'weekly':
        return 'สัปดาห์นี้: โปรดอย่าลืมออมเงินสำหรับ "$name" จำนวน $formattedAmount ฿';
      case 'monthly':
        return 'เดือนนี้: โปรดอย่าลืมออมเงินสำหรับ "$name" จำนวน $formattedAmount ฿';
      default:
        return 'โปรดอย่าลืมออมเงินสำหรับ "$name" จำนวน $formattedAmount ฿';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/account_page');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/Contactus');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact us',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'M',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.monetization_on, size: 28),
                Text(
                  'neyQuest',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFA8E1E6),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'เงินเก็บรวม ${totalSaved.toStringAsFixed(2)} ฿',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'สู้ๆ น้า ${userName.isNotEmpty ? "คุณ$userName" : "คุณผู้ใช้"}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'การแจ้งเตือน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFA8E1E6),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child:
                  messages.isEmpty
                      ? const Center(child: Text("ยังไม่มีการแจ้งเตือน 😊"))
                      : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder:
                            (context, index) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.notifications_active,
                                  color: Colors.orange,
                                ),
                                title: Text(messages[index]),
                              ),
                            ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
