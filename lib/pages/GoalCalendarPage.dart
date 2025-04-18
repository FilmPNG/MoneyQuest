import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GoalCalendarPage extends StatefulWidget {
  final String documentId;
  const GoalCalendarPage({super.key, required this.documentId});

  @override
  State<GoalCalendarPage> createState() => _GoalCalendarPageState();
}

class _GoalCalendarPageState extends State<GoalCalendarPage> {
  List<bool> _checked = [];
  int totalUnits = 0;
  double amountPerUnit = 0;
  String goalName = '';
  String savingMethod = '';
  List<bool> _previousChecked = [];

  @override
  void initState() {
    super.initState();
    fetchGoalData();
  }

  Future<void> fetchGoalData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('goals')
            .doc(widget.documentId)
            .get();
    final data = doc.data();

    if (data != null) {
      final createdAt = (data['createdAt'] as Timestamp).toDate();
      final targetDate =
          DateTime.tryParse(data['targetDate']) ?? DateTime.now();
      goalName = data['name'] ?? '';
      savingMethod = data['savingMethod'] ?? 'daily';

      final completed = (data['completedUnits'] ?? 0) as int;

      setState(() {
        // ปรับการคำนวณ totalUnits ให้เป็น double
        totalUnits =
            savingMethod == 'weekly'
                ? (targetDate.difference(createdAt).inDays / 7).ceil()
                : savingMethod == 'monthly'
                ? (targetDate.difference(createdAt).inDays / 30).ceil()
                : targetDate.difference(createdAt).inDays;

        if (totalUnits <= 0) {
          // กรณีที่ไม่มีหน่วยให้ทำการแสดงข้อความหรือดำเนินการอื่น ๆ
          totalUnits = 1; // หรือกำหนดให้มีการแสดงผลอย่างน้อย 1 unit
        }

        amountPerUnit =
            totalUnits > 0
                ? (data['price'] / totalUnits).toDouble()
                : data['price'].toDouble();

        _checked = List<bool>.generate(totalUnits, (i) => i < completed);
        _previousChecked = List<bool>.from(_checked); // Clone for comparison
      });
    }
  }

  void saveProgress() async {
    int completedUnits = _checked.where((e) => e).length;
    double savedAmount = amountPerUnit * completedUnits;

    await FirebaseFirestore.instance
        .collection('goals')
        .doc(widget.documentId)
        .update({'savedAmount': savedAmount, 'completedUnits': completedUnits});

    for (int i = 0; i < _checked.length; i++) {
      if (_checked[i] && !_previousChecked[i]) {
        await FirebaseFirestore.instance
            .collection('goals')
            .doc(widget.documentId)
            .collection('history')
            .add({
              'amount': amountPerUnit,
              'goalName': goalName,
              'timestamp': FieldValue.serverTimestamp(),
            });
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('บันทึกเรียบร้อย')));
      Navigator.pop(context);
    }
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
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text(
                  'M',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.monetization_on,
                  size: 26,
                  color: Colors.black,
                ),
                const Text(
                  'oneyQuest',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child:
                  _checked.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                        itemCount: totalUnits,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${index + 1}'),
                              Checkbox(
                                value: _checked[index],
                                onChanged: (val) {
                                  setState(() {
                                    _checked[index] = val ?? false;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: saveProgress,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA8E1E6),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('บันทึก'),
            ),
          ),
        ],
      ),
    );
  }
}
