import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
                  'บัญชีของฉัน',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
           
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : const NetworkImage(
                      'https://randomuser.me/api/portraits/men/75.jpg') as ImageProvider,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('แก้ไขรูปภาพ'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ชื่อ วีรภัทร', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('นามสกุล อภิภูวงศ์', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text('อีเมล Weerapat.aph@student.mahidol.edu', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text('เบอร์โทร 012-345-6789', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text('วัน เดือน ปี เกิด 11/01/2547', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
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
      ),
    );
  }
}
