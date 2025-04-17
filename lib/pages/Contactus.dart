import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        _nameController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
      });
    }
  }

  Future<void> _submitContact() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเข้าสู่ระบบก่อนส่งข้อความ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อความ'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('contact_messages').add({
        'uid': uid,
        'username': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('สำเร็จ!'),
            content: const Text('ส่งข้อมูลเรียบร้อยแล้ว'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.red),
      );
    }
  }

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
        currentIndex: 3,
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
          // Header with back button and logo
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 40, bottom: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.lightBlueAccent),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text('M', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Icon(Icons.monetization_on, size: 28),
                const Text('neyQuest', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // Logo in center
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/logo.png'), // ✅ ใส่ path โลโก้ของจริง
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 10),
          const Text('ติดต่อผู้ดูแลระบบ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Form Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildReadonlyField(_nameController, 'ชื่อผู้ใช้'),
                    const SizedBox(height: 12),
                    _buildReadonlyField(_emailController, 'อีเมล'),
                    const SizedBox(height: 12),
                    _buildReadonlyField(_phoneController, 'เบอร์โทรศัพท์'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'ข้อความของคุณ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF84D3DD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('ส่งข้อมูล'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadonlyField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
