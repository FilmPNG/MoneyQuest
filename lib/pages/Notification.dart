import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Notification tab
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
                Text('M',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Icon(Icons.monetization_on, size: 28),
                Text('neyQuest',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
              child: ListView(
                children: [
                  _notificationSection('วันนี้', '11:30น.', [
                    'โปรดอย่าลืมออมเงินสำหรับ ค่าอาหารแมว จำนวน 20 ฿',
                    'โปรดอย่าลืมออมเงินสำหรับ ค่า iPhone 19 จำนวน 30 ฿',
                  ]),
                  _notificationSection('5 มี.ค. 2568', '11:31น.', [
                    'โปรดอย่าลืมออมเงินสำหรับ ค่าอาหารแมว จำนวน 20 ฿',
                    'โปรดอย่าลืมออมเงินสำหรับ ค่า iPhone 19 จำนวน 30 ฿',
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationSection(String date, String time, List<String> messages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(time, style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 5),
        ...messages.map((msg) => Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: Text(msg),
              ),
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}
