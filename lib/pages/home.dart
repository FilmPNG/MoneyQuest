import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'goal_detail.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUid = currentUser?.uid;

    /*print("current UID = $currentUid"); // debug */

    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/Notification');
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
          

          // 🧩 แสดง UID ด้านบน 
         /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "👤 UID ของคุณ: ${currentUid ?? 'ยังไม่ได้ login'}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 10), */

          // โลโก้
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


          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('เป้าหมายของฉัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddGoalPage');
                  },
                  icon: const Icon(Icons.add, color: Colors.lightBlueAccent),
                  label: const Text('เพิ่มเป้าหมาย', style: TextStyle(color: Colors.lightBlueAccent)),
                ),
              ],
            ),
          ),

          Expanded(
            child: currentUid == null
                ? const Center(child: Text('❗ กรุณา login ก่อน'))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('goals')
                        .where('userId', isEqualTo: currentUid)
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print("📦 เรียกข้อมูล goal...");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        print("error: ${snapshot.error}");
                        return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                      }

                      final goals = snapshot.data?.docs ?? [];
                      print("goals ทั้งหมด: ${goals.length}");

                      if (goals.isEmpty) {
                        return const Center(child: Text('ยังไม่มีเป้าหมาย'));
                      }

                      return GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(10),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: goals.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final title = data['name'] ?? 'ไม่ระบุ';
                          final price = data['price']?.toString() ?? '0';
                          final method = data['savingMethod'] ?? '-';
                          final date = data['targetDate']?.split('T')[0] ?? '-';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoalDetailPage(documentId: doc.id),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.flag, size: 36, color: Colors.blueGrey),
                                    const SizedBox(height: 10),
                                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                    Text('$price ฿', style: const TextStyle(color: Colors.grey)),
                                    Text('ออม: $method', style: const TextStyle(color: Colors.teal)),
                                    Text('ภายใน $date', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
