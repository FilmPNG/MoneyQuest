import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
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

  Future<void> _fetchTotalSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
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

  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (!mounted || data == null) return;
    setState(() {
      userName = data['name'] ?? '';
    });
  }

  Future<void> _checkGoalsAndNotify() async {
    final now = DateTime.now();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
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
      final createdAt = (createdAtRaw is Timestamp)
          ? createdAtRaw.toDate()
          : now.subtract(const Duration(days: 1));

      final targetDate = DateTime.tryParse(data['targetDate'] ?? '') ?? now;
      final duration = targetDate.difference(createdAt).inDays;
      if (duration <= 0) continue;

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

      final lastNotify = data['lastNotify']?.toDate();
      final shouldNotify = () {
        final diff = now.difference(lastNotify ?? DateTime.fromMillisecondsSinceEpoch(0));
        return savingMethod == 'daily'
            ? diff.inSeconds >= 10
            : savingMethod == 'weekly'
                ? diff.inDays >= 7
                : diff.inDays >= 30;
      }();

      if (saved < expected && shouldNotify) {
        final remaining = (expected - saved).clamp(1, price);
        final msg = 'โปรดอย่าลืมออมเงินสำหรับ "$name" จำนวน ${remaining.toStringAsFixed(2)} ฿';
        newMessages.add(msg);

        await doc.reference.update({'lastNotify': now});

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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact us'),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('M', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Icon(Icons.monetization_on, size: 26),
                Text('neyQuest', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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
                    Text('เงินเก็บรวม ${totalSaved.toStringAsFixed(2)} ฿', style: const TextStyle(fontSize: 16)),
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
              child: Text('การแจ้งเตือน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFA8E1E6),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: messages.isEmpty
                  ? const Center(child: Text("ยังไม่มีการแจ้งเตือน 😊"))
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(Icons.notifications_active, color: Colors.orange),
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
