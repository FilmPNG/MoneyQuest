import 'package:flutter/material.dart';

class GoalCalendarPage extends StatefulWidget {
  const GoalCalendarPage({super.key});

  @override
  State<GoalCalendarPage> createState() => _GoalCalendarPageState();
}

class _GoalCalendarPageState extends State<GoalCalendarPage> {
  final List<bool> _checkedDays = List.generate(31, (_) => false); // 31 วัน

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
          
          // Main scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button and goal title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'ซื้อiPhone 19',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Month display
                    const Center(
                      child: Text(
                        'เดือน มีนาคม 2568',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Calendar grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 31,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 1.4, // Further increased to reduce height
                        mainAxisSpacing: 2, 
                        crossAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return _buildCalendarDay(index);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Save button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('บันทึกเรียบร้อย')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA8E1E6),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('บันทึก'),
                      ),
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

  Widget _buildCalendarDay(int index) {
    int day = index + 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$day',
          style: const TextStyle(fontSize: 12),
        ),
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _checkedDays[index],
            onChanged: (value) {
              setState(() {
                _checkedDays[index] = value ?? false;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}