// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      debugShowCheckedModeBanner: false,
      home: MoodHomePage(),
    );
  }
}

class MoodHomePage extends StatefulWidget {
  const MoodHomePage({super.key});

  @override
  _MoodHomePageState createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage> {
  final TextEditingController noteController = TextEditingController();
  final List<String> moods = ['😄', '😐', '😢', '😠', '😴'];
  final List<String> moodColors = ['#FFD700', '#B0C4DE', '#FF6347', '#DC143C', '#778899'];
  final String today = DateFormat('EEEE, MMM d').format(DateTime.now());
  final List<Map<String, String>> moodHistory = [];
  int _currentIndex = 0;

  void _saveMood(String mood) {
    setState(() {
      moodHistory.insert(0, {
        'mood': mood,
        'note': noteController.text,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });
    });
    noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You selected $mood'), duration: Duration(seconds: 1)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _currentIndex == 0 ? _buildHomePage() : _buildHistoryPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              today,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: moods.asMap().entries.map((entry) {
                int index = entry.key;
                String mood = entry.value;
                return InkWell(
                  onTap: () => _saveMood(mood),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xFF${moodColors[index].substring(1)}')),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      mood,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            TextField(
              controller: noteController,
              maxLines: 4,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Write about your day...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (noteController.text.isNotEmpty) {
                      _saveMood('😄');
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    noteController.clear();
                  },
                  icon: Icon(Icons.clear),
                  label: Text("Clear"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: moodHistory.length,
        itemBuilder: (context, index) {
          final moodEntry = moodHistory[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text('${moodEntry['mood']} - ${moodEntry['date']}'),
              subtitle: Text(moodEntry['note'] ?? 'No note'),
            ),
          );
        },
      ),
    );
  }
}