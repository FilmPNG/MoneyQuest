import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GoalCalendarPage.dart';
import 'SavingHistoryPage.dart';

class GoalDetailPage extends StatelessWidget {
  final String documentId;

  const GoalDetailPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E1E6),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('goals').doc(documentId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('ไม่พบข้อมูลเป้าหมาย'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final name = data['name'] ?? '-';
          final price = (data['price'] ?? 0).toDouble();
          final savingMethod = data['savingMethod'] ?? '-';
          final rawTargetDate = data['targetDate']?.split('T')[0];
          final targetDate = rawTargetDate != null
              ? '${DateTime.parse(rawTargetDate).day}/${DateTime.parse(rawTargetDate).month}/${DateTime.parse(rawTargetDate).year}'
              : '-';
          final startDate = data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now();

          final endDate = DateTime.tryParse(data['targetDate'] ?? '') ?? DateTime.now();
          final days = endDate.difference(startDate).inDays;
          final totalUnits = savingMethod == 'weekly'
              ? (days / 7).ceil()
              : savingMethod == 'monthly'
                  ? (days / 30).ceil()
                  : days;

          final dailyAmount = totalUnits > 0 ? price / totalUnits : price;

          final savedAmount = (data['savedAmount'] ?? 0).toDouble();
          final remainingAmount = (price - savedAmount).clamp(0, price);
          final progress = (savedAmount / price * 100).clamp(0, 100);

          return Column(
            children: [
              _buildHeader(),
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
                              child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(name,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        infoText('ยอดเงินที่ออมไปแล้ว', '${savedAmount.toStringAsFixed(2)} ฿'),
                        infoText('ยอดออมคงเหลือ', '${remainingAmount.toStringAsFixed(2)} ฿'),
                        infoText('ยอดทั้งหมด', '$price ฿'),
                        infoText('ประเภทการออม', savingMethod),
                        infoText('วันที่เริ่ม', '${startDate.day}/${startDate.month}/${startDate.year}'),
                        infoText('วันที่ต้องการบรรลุเป้าหมาย', targetDate),
                        infoText(
                          savingMethod == 'daily'
                              ? 'ออมวันละ'
                              : savingMethod == 'weekly'
                                  ? 'ออมต่อสัปดาห์'
                                  : 'ออมต่อเดือน',
                          savingMethod == 'daily'
                              ? '${dailyAmount.toStringAsFixed(2)} ฿ เป็นเวลา $totalUnits วัน'
                              : savingMethod == 'weekly'
                                  ? '${dailyAmount.toStringAsFixed(2)} ฿ เป็นเวลา $totalUnits สัปดาห์'
                                  : '${dailyAmount.toStringAsFixed(2)} ฿ เป็นเวลา $totalUnits เดือน',
                        ),
                        infoText('คุณออมเงินไปแล้วประมาณ', '${progress.toStringAsFixed(2)}%'),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('ยืนยันการลบ'),
                                    content:
                                        const Text('คุณแน่ใจหรือไม่ว่าต้องการลบเป้าหมายนี้?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('ยกเลิก'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final goalRef = FirebaseFirestore.instance.collection('goals').doc(documentId);
                                  final historySnapshot = await goalRef.collection('history').get();
                                  for (var doc in historySnapshot.docs) {
                                    await doc.reference.delete();
                                  }
                                  await goalRef.delete();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('ลบเป้าหมายเรียบร้อยแล้ว')),
                                  );
                                }
                              },
                              child: const Text('ลบ'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA8E1E6),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoalCalendarPage(documentId: documentId),
                                  ),
                                );
                              },
                              child: const Text('ออมเงินเพิ่ม'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA8E1E6),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SavingHistoryPage(documentId: documentId),
                                  ),
                                );
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
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('M', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
          Icon(Icons.monetization_on, size: 26, color: Colors.black),
          Text('neyQuest', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
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
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
