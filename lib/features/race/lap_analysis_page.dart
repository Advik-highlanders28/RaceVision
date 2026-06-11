import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:racevision/core/api/openf1_service.dart';

class LapAnalysisPage extends StatefulWidget {
  const LapAnalysisPage({super.key});

  @override
  State<LapAnalysisPage> createState() => _LapAnalysisPageState();
}

class _LapAnalysisPageState extends State<LapAnalysisPage> {
  List<double> driver1 = [];
  List<double> driver2 = [];

  bool isLoading = true;

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

  List<FlSpot> buildSpots(List<double> laps) {
    return List.generate(
      laps.length,
      (index) => FlSpot(index.toDouble(), laps[index]),
    );
  }

  double getMinY() {
    final all = [...driver1, ...driver2];
    double min = all.reduce((a, b) => a < b ? a : b);
    return (min ~/ 5) * 5;
  }

  double getMaxY() {
    final all = [...driver1, ...driver2];
    double max = all.reduce((a, b) => a > b ? a : b);
    return ((max ~/ 5) + 1) * 5;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || driver1.isEmpty || driver2.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lap Time Comparison',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Icon(Icons.circle, color: Colors.redAccent, size: 10),
              SizedBox(width: 6),
              Text('Verstappen'),
              SizedBox(width: 16),
              Icon(Icons.circle, color: Colors.cyanAccent, size: 10),
              SizedBox(width: 6),
              Text('Leclerc'),
            ],
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
                  horizontalInterval: 5,
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white24),
                ),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text('Lap Number'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        if (value % 2 != 0) return const SizedBox();
                        return Text('${value.toInt() + 1}');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('Time (s)'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
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
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: buildSpots(driver2),
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.cyanAccent,
                    dotData: FlDotData(show: false),
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
