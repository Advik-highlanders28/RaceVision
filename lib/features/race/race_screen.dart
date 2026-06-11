import 'package:flutter/material.dart';
import 'package:racevision/features/race/dashboard_page.dart';
import 'package:racevision/features/race/lap_analysis_page.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [LapAnalysisPage(), DashboardPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RaceVision'),
        actions: [_navButton("Laps", 0), _navButton("Dashboard", 1)],
      ),
      body: pages[selectedIndex],
    );
  }

  Widget _navButton(String label, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          color: selectedIndex == index ? Colors.white : Colors.white70,
          fontWeight: selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }
}
