import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  DateTime? selectedDate;
  File? selectedImage;

  final picker = ImagePicker();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      body: Column(
        children: [
          // Header
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

          // Form Content
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
                    // Back + title
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
                    inputField('ชื่อเป้าหมาย'),
                    const SizedBox(height: 15),
                    inputField('ราคา'),
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
                      items: const [
                        DropdownMenuItem(value: 'daily', child: Text('รายวัน')),
                        DropdownMenuItem(value: 'weekly', child: Text('รายสัปดาห์')),
                        DropdownMenuItem(value: 'monthly', child: Text('รายเดือน')),
                      ],
                      onChanged: (value) {},
                    ),

                    const SizedBox(height: 20),
                    const Text('อัพโหลดรูปภาพ', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF2F2F2),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'อัพโหลดรูปภาพของคุณ\n.JPG, .PNG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                      ),
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
                        onPressed: () {
                          // ยังไม่ต้องเก็บลง database
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("สร้างเป้าหมายสำเร็จ (ยังไม่บันทึก DB)")),
                          );
                        },
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

  Widget inputField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
