import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _savingMethod;
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveGoalToFirestore() async {
    if (_goalNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        selectedDate == null ||
        _savingMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")),
      );
      return;
    }

    try {
      final goalData = {
        'name': _goalNameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'targetDate': selectedDate!.toIso8601String(),
        'savingMethod': _savingMethod,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('goals').add(goalData);
      _showSuccessDialog();


      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("สร้างเป้าหมายสำเร็จแล้ว!")),
      // );

      _goalNameController.clear();
      _priceController.clear();
      setState(() {
        selectedDate = null;
        _savingMethod = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('สำเร็จ!'),
        content: const Text('สร้างเป้าหมายของคุณเรียบร้อยแล้ว'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // ปิด dialog
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false); // กลับหน้า Home และล้าง stack
            },
            child: const Text('ตกลง'),
          ),
        ],
      );
    },
  );
}


  @override
  void dispose() {
    _goalNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('M', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                Icon(Icons.autorenew, size: 26),
                Text('oneyQuest', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        const Text('เพิ่มเป้าหมาย', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    inputField('ชื่อเป้าหมาย', _goalNameController),
                    const SizedBox(height: 15),
                    inputField('ราคา', _priceController),
                    const SizedBox(height: 15),
                    const Text('วันที่ต้องการบรรลุเป้าหมาย', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedDate != null
                                  ? "${selectedDate!.toLocal()}".split(' ')[0]
                                  : 'เลือกวันที่',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('วิธีการออม', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      hint: const Text('เลือกวิธีการออม'),
                      value: _savingMethod,
                      items: const [
                        DropdownMenuItem(value: 'daily', child: Text('รายวัน')),
                        DropdownMenuItem(value: 'weekly', child: Text('รายสัปดาห์')),
                        DropdownMenuItem(value: 'monthly', child: Text('รายเดือน')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _savingMethod = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA8E1E6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        ),
                        onPressed: _saveGoalToFirestore,
                        child: const Text('สร้างเป้าหมาย'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget inputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: hint == 'ราคา' ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
