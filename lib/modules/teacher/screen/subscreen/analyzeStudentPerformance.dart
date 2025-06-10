import 'package:fl_chart/fl_chart.dart';
import 'package:tosl_operation/modules/global.dart';

class AnalyzeStudentPerformanceScreen extends StatelessWidget {
  AnalyzeStudentPerformanceScreen({super.key});

  final List<Map<String, dynamic>> performanceData = [
    {"student": "Alice Johnson", "avgScore": 90},
    {"student": "Bob Smith", "avgScore": 85},
    {"student": "Charlie Lee", "avgScore": 95},
    {"student": "Diana Brown", "avgScore": 80},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analyze Student Performance")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Average Quiz Scores",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: performanceData
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value["avgScore"].toDouble(),
                              color: Colors.blueAccent,
                              width: 20,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < performanceData.length) {
                            return Text(
                              performanceData[index]["student"].split(" ")[0],
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ).animate().fadeIn(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
