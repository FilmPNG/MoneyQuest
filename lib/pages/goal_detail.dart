import 'package:flutter/material.dart';

class GoalDetailPage extends StatelessWidget {
  const GoalDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      body: Column(
        children: [
          // White header area - made to fully cover the top without borders
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
          
          // Add spacing between header and content box
          const SizedBox(height: 20),

          // Detail box
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
                  children: [
                    // Back button and goal title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'ซื้อ iPhone 19',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Less rounded corners to match screenshot
                      child: Image.network(
                        'https://media.studio7thailand.com/153361/iPhone_15_Pink.png',
                        height: 160,
                        width: 160,
                        fit: BoxFit.contain, // Changed to contain to match screenshot
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Goal details
                    infoText('ยอดเงินที่ออมไปแล้ว', '94.34 ฿'),
                    infoText('ยอดออมคงเหลือ', '29,805.66 ฿'),
                    infoText('ยอดทั้งหมด', '29,900 ฿'),
                    infoText('ประเภทการออม', 'รายวัน'),
                    infoText('วันที่เริ่ม', '3 มีนาคม 2568'),
                    infoText('วันที่ต้องการบรรลุเป้าหมาย', '1 มกราคม 2569'),
                    infoText('ออมวันละ', '99.34 ฿ เป็นเวลา 301 วัน'),
                    infoText('คุณออมเงินไปแล้วประมาณ', '0.32% ของเป้าหมาย'),

                    const SizedBox(height: 30),

                    // Bottom buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA8E1E6),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/GoalCalendarPage');
                          },
                          child: const Text('ออมเงินเพิ่ม'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA8E1E6),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/SavingHistoryPage');
                          },
                          child: const Text('ประวัติการออม'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Add spacing at bottom
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget infoText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}