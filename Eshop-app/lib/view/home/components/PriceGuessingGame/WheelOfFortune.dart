import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  int rewards = 0;
  bool isSpinned = false;

  List<dynamic> items = [
    "Good luck next time", "Good luck next time", "Iphone 15 pro max", "Good luck next time"
  ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: items.map((item) => FortuneItem(child: Text(item))).toList(),
                onAnimationEnd: () {
                  setState(() {
                    rewards = selected.value!;
                  });
                  print(rewards);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(items[selected.value!].toString()),
                    ),
                  );
                  // Delay for 2 seconds before navigating back
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context); // Navigate back to previous screen
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isSpinned) {
                  setState(() {
                    selected.add(Fortune.randomInt(0, items.length));
                    isSpinned = true;
                  });
                }
              },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.redAccent,
                child: Center(
                  child: Text("SPIN"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
