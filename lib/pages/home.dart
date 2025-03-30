import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
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
        currentIndex: 0,
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
                        backgroundImage: NetworkImage('https://scontent.fkdt3-1.fna.fbcdn.net/v/t39.30808-6/332602939_584892933534318_8420386110721425268_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeF1n0EjE8Rf1P6cadmDIjMAxXeQ5H2SgsrFd5DkfZKCyhS9Qusym-LVcc-50KAOME-aFmRI6OQ3obWzZjjh9abC&_nc_ohc=4xsfsBX_uXAQ7kNvgHQds39&_nc_oc=AdnKLKGfjS7qQfT9tUtAbqffEKArrULqcx55LKn2GN4cW1hnUkpbbivQL0FNNrQmxsg&_nc_zt=23&_nc_ht=scontent.fkdt3-1.fna&_nc_gid=INIaQ7-zEtoLZafvDD1flQ&oh=00_AYHBBOd9jexd24WshCFCqjqiAVz51RHJrRnL99lcUYUxwQ&oe=67EED78F'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('เงินเก็บรวม 6000 ฿', style: TextStyle(fontSize: 16)),
                          Text('Weerapat Aphiphuwong', style: TextStyle(fontSize: 14, color: Colors.black)),
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
                        onPressed: () {},
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
                  _goalItem('ซื้อ iPhone 19', '99.34 ฿', '0.32%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png'),
                  _goalItem('ซื้อกระเป๋า', '30.74 ฿', '10%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png'),
                  _goalItem('ซื้อรถ', '300.53 ฿', '0.2%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png'),
                  _goalItem('ซื้อบ้าน', '500.0 ฿', '1%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png'),
                  _goalItem('อาหารแมว', '700.0 ฿', '70%', 'https://media.studio7thailand.com/153361/iPhone_15_Pink.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalItem(String title, String amount, String percentage, String imageUrl) {
    return Card(
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
    );
  }
}