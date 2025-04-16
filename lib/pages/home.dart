import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // Notification tab
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
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'M',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.monetization_on,
                        size: 28,
                      ),
                      Text(
                        'neyQuest',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                
                // Full width container without any parent padding
                Container(
                  width: double.infinity, // This makes it full screen width
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 0), // Ensure no horizontal margin
                  decoration: const BoxDecoration(
                    color: Color(0xFFA8E1E6),
                    // No border radius to match the design in the screenshot
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/75.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('เงินเก็บรวม 6000 ฿', style: TextStyle(fontSize: 16)),
                          Text('สวัสดีคุณ วีรภัทร', style: TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Add padding only to the goal section title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFA8E1E6),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _goalItem('ซื้อ iPhone 19', '99.34 ฿', '0.32%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png', context),
                  _goalItem('ซื้อกระเป๋า', '30.74 ฿', '10%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png', context),
                  _goalItem('ซื้อรถ', '300.53 ฿', '0.2%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png', context),
                  _goalItem('ซื้อบ้าน', '500.0 ฿', '1%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png', context),
                  _goalItem('อาหารแมว', '700.0 ฿', '70%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png', context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalItem(String title, String amount, String percentage, String imageUrl, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/goal_detail');
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, height: 50),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(amount, style: const TextStyle(color: Colors.grey)),
            Text('ความคืบหน้า: $percentage', 
                style: const TextStyle(color: Colors.lightBlueAccent)),
          ],
        ),
      ),
    ),
  );
  }
}