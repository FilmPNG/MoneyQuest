import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<DocumentSnapshot> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/Notification');
              break;
            case 2:
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
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("ไม่พบข้อมูลผู้ใช้"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('M', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Icon(Icons.monetization_on, size: 28),
                      Text('neyQuest', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white.withOpacity(0.85),
                  child: const Center(
                    child: Text('บัญชีของฉัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),

                // 🔽 แสดงข้อมูลผู้ใช้จาก Firestore
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อ: ${userData['name'] ?? '-'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('นามสกุล: ${userData['lastName'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text('อีเมล: ${userData['email'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text('เบอร์โทร: ${userData['phone'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text('วันเกิด: ${userData['birthDate'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("เกิดข้อผิดพลาดขณะออกจากระบบ: $e")),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 3,
                  ),
                  child: const Text('ออกจากระบบ'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
