import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [BarChartRodData(toY: 8)],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [BarChartRodData(toY: 10)],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [BarChartRodData(toY: 14)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
