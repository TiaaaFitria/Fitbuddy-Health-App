import 'package:flutter/material.dart';
import 'menu_item.dart';  
import '../pages/menu/mood_tracker_page.dart';
import '../pages/menu/journal_page.dart';
import '../pages/menu/reminder_page.dart';
import '../pages/menu/daily_quotes_page.dart';
import '../pages/menu/dear_me_page.dart';
import '../pages/menu/journey_page.dart';

class AppData extends ChangeNotifier {
  final List<Map<String, dynamic>> _moodHistory = [];
  List<Map<String, dynamic>> get moodHistory => _moodHistory;

  void addMood(Map<String, dynamic> mood) {
    _moodHistory.insert(0, mood);
    notifyListeners();
  }

  final List<Map<String, dynamic>> _journalEntries = [];
  List<Map<String, dynamic>> get journalEntries => _journalEntries;

  void addJournal(Map<String, dynamic> journal) {
    _journalEntries.insert(0, journal);
    notifyListeners();
  }

  final List<String> _reminders = [];
  List<String> get reminders => _reminders;

  void addReminder(String reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(int index) {
    _reminders.removeAt(index);
    notifyListeners();
  }

  int get journalEntriesCount => _journalEntries.length;
  int get remindersCompleted => _reminders.length;

  final List<MenuItem> _menuItems = [
    MenuItem(
      title: "Mood Tracker",
      icon: Icons.mood,
      color: Colors.teal,
      page: const MoodTrackerPage(userId: 'dummyUser123'),
    ),
    MenuItem(
      title: "My Journal",
      icon: Icons.book,
      color: Colors.blue,
      page: const JournalPage(userId: 'dummyUser123'),
    ),
    MenuItem(
      title: "Reminder",
      icon: Icons.alarm,
      color: Colors.orange,
      page: const ReminderPage(userId: 'dummyUser123'),
    ),
    MenuItem(
      title: "Daily Quotes",
      icon: Icons.format_quote,
      color: Colors.purple,
      page: const DailyQuotesPage(userId: 'dummyUser123'),
    ),
    MenuItem(
      title: "Dear Me",
      icon: Icons.mail,
      color: Colors.pink,
      page: const DearMePage(userId: 'dummyUser123'),
    ),
    MenuItem(
      title: "My Journey",
      icon: Icons.timeline,
      color: Colors.green,
      page: const JourneyPage(userId: 'dummyUser123'),
    ),
  ];

  List<MenuItem> get menuItems => _menuItems;

  set menuItems(List<MenuItem> items) {
    _menuItems
      ..clear()
      ..addAll(items);
    notifyListeners();
  }
}
