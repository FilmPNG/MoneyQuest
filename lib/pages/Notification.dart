import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _checkGoalsAndNotify();
  }

  Future<void> _checkGoalsAndNotify() async {
    final now = DateTime.now();
    final goals = await FirebaseFirestore.instance.collection('goals').get();

    for (var doc in goals.docs) {
      final data = doc.data();
      final name = data['name'] ?? 'ไม่ระบุชื่อ';
      final price = (data['price'] ?? 0).toDouble();
      final saved = (data['savedAmount'] ?? 0).toDouble();
      final savingMethod = data['savingMethod'] ?? 'daily';
      final createdAt = (data['createdAt'] as Timestamp).toDate();
      final targetDate = DateTime.tryParse(data['targetDate'] ?? '') ?? now;
      final duration = targetDate.difference(createdAt).inDays;

      int elapsedUnits = savingMethod == 'daily'
          ? now.difference(createdAt).inDays
          : savingMethod == 'weekly'
              ? (now.difference(createdAt).inDays / 7).floor()
              : (now.difference(createdAt).inDays / 30).floor();

      double expected = savingMethod == 'daily'
          ? (price / duration) * elapsedUnits
          : savingMethod == 'weekly'
              ? (price / (duration / 7)) * elapsedUnits
              : (price / (duration / 30)) * elapsedUnits;

      if (saved < expected) {
        final remaining = (expected - saved).clamp(1, price);
        final msg = 'โปรดอย่าลืมออมเงินสำหรับ $name จำนวน ${remaining.toStringAsFixed(2)} ฿';
        messages.add(msg);

        // แสดงแจ้งเตือนในแอปทันทีแบบ in-app (ไม่ใช่ระบบ OS)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.orange.shade600,
              duration: const Duration(seconds: 5),
            ),
          );
        });
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact us'),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('M', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Icon(Icons.monetization_on, size: 28),
                Text('neyQuest', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color(0xFFA8E1E6),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/75.jpg')
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('เงินเก็บรวม 6000 ฿', style: TextStyle(fontSize: 16)),
                    Text('สู้ๆ น้า คุณวีรภัทร', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('การแจ้งเตือน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFA8E1E6),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active),
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
