import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JourneyPage extends StatefulWidget {
  final String userId; 

  const JourneyPage({super.key, required this.userId});

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  int totalMoodEntries = 0;
  int journalCount = 0;
  int remindersDone = 0;

  String get moodKey => "mood_${widget.userId}";
  String get journalKey => "journal_${widget.userId}";
  String get reminderKey => "reminder_${widget.userId}";

  @override
  void initState() {
    super.initState();
    _loadJourneyData();
  }

  Future<void> _loadJourneyData() async {
    final prefs = await SharedPreferences.getInstance();

    final moodData = prefs.getString(moodKey);
    final journalData = prefs.getString(journalKey);
    final reminderData = prefs.getString(reminderKey);

    setState(() {
      totalMoodEntries = moodData != null
          ? List<Map<String, dynamic>>.from(json.decode(moodData) as List).length
          : 0;
      journalCount = journalData != null
          ? List<Map<String, dynamic>>.from(json.decode(journalData) as List).length
          : 0;
      remindersDone = reminderData != null
          ? List<String>.from(json.decode(reminderData) as List).length
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Journey"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Statistik Perjalanan Kamu",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: ([totalMoodEntries, journalCount, remindersDone].reduce((a, b) => a > b ? a : b).toDouble()) + 5,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(toY: totalMoodEntries.toDouble(), color: Colors.teal, width: 22)],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(toY: journalCount.toDouble(), color: Colors.blue, width: 22)],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(toY: remindersDone.toDouble(), color: Colors.orange, width: 22)],
                      showingTooltipIndicators: [0],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ["Mood", "Journal", "Reminder"];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(labels[value.toInt()]),
                          );
                        },
                      ),
                    ),
                    leftTitles:  const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1),
                    ),
                  ),
                  gridData:  const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
