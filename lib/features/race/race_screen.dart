import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/api/openf1_service.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});
  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final service = Openf1Service();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final d1 = await service.fetchLapTimes(1);
    final d2 = await service.fetchLapTimes(16);

    setState(() {
      driver1 = d1;
      driver2 = d2;
      isLoading = false;
    });
  }

  List<double> driver1 = [];
  List<double> driver2 = [];

  bool isLoading = true;
  double getMinY() {
    final all = [...driver1, ...driver2];
    return all.reduce((a, b) => a < b ? a : b) - 1;
  }

  double getMaxY() {
    final all = [...driver1, ...driver2];
    return all.reduce((a, b) => a > b ? a : b) + 1;
  }

  List<FlSpot> buildSpots(List<double> laps) {
    return List.generate(
      laps.length,
      (index) => FlSpot(index.toDouble(), laps[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || driver1.isEmpty || driver2.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('RaceVision')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lap Time Comparison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: driver1.length.toDouble() - 1,

                  minY: getMinY(),
                  maxY: getMaxY(),

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                  ),

                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white24),
                  ),

                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Lap Number',
                        style: TextStyle(color: Colors.white70),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // 🔥 only whole laps
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0)
                            return const SizedBox(); // hide decimals
                          return Text(
                            '${value.toInt() + 1}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),

                    leftTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Lap Time (s)',
                        style: TextStyle(color: Colors.white70),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),

                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      spots: buildSpots(driver1),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.redAccent,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),

                    LineChartBarData(
                      spots: buildSpots(driver2),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.cyanAccent,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
