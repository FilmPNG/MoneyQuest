import 'package:flutter/material.dart';

class SavingHistoryPage extends StatelessWidget {
  const SavingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      body: Column(
        children: [
          // White header area
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'M',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Icon(Icons.monetization_on, size: 26, color: Colors.black),
                Text(
                  'oneyQuest',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),

          // หัวข้อพร้อม back
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xFFB2E5E8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'ประวัติการออม ซื้อ iPhone 19',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // รายการประวัติ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // แถว วันที่ + เวลา
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'วันนี้',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('11:30 น.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // แถวไอคอน + รายละเอียด
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.savings, size: 32, color: Colors.grey),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ออมเงิน ซื้อ iPhone 19 จำนวน 99.34 ฿',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
