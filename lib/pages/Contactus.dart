import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔲 พื้นหลังส่วนบนสีขาว พร้อมโลโก้
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Column(
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'M',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.monetization_on, size: 28),
                      Text(
                        'neyQuest',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white.withOpacity(0.85), // <-- แก้ตรงนี้
              child: const Center(
                child: Text(
                  'ติดต่อเรา',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔲 รูปโลโก้
            const CircleAvatar(
              radius: 75,
              backgroundImage: AssetImage('assets/images/logo.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 20),

            // 🔲 กล่องฟอร์มโปร่งใสสีขาว
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85), // <-- โปร่งใส
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'ชื่อผู้ใช้งาน',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'อีเมล',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'เบอร์โทรศัพท์',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'ข้อความ',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ส่งข้อความสำเร็จ'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF84D3DD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('ส่งข้อมูล'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔲 ข้อมูลการติดต่อ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.black54),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'ที่อยู่ 999 ถ. พุทธมณฑลสาย 4 ตำบล ศาลายา จังหวัดนครปฐม รหัสไปรษณีย์ 73170',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.black54),
                      SizedBox(width: 5),
                      Text(
                        'โทร 091-111-1111',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.black54),
                      SizedBox(width: 5),
                      Text(
                        'อีเมล info@moneyquest.com',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
