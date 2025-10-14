import 'package:flutter/material.dart';
import '../model/menu_item.dart';

// import halaman
import '../pages/menu/mood_tracker_page.dart';
import '../pages/menu/journal_page.dart';
import '../pages/menu/reminder_page.dart';
import '../pages/menu/dear_me_page.dart';
import '../pages/menu/journey_page.dart';
import '../pages/menu/daily_quotes_page.dart';

class AppData {
  List<MenuItem> getMenuItems(String userId) {
    return [
      MenuItem(
        title: "Mood Tracker",
        icon: Icons.mood,
        color: Colors.blueAccent,
        pageBuilder: () => const MoodTrackerPage(
          userId: '',
        ),
      ),
      MenuItem(
        title: "My Journal",
        icon: Icons.book_rounded,
        color: Colors.greenAccent,
        pageBuilder: () => const JournalPage(
          userId: '',
        ),
      ),
      MenuItem(
        title: "Reminder",
        icon: Icons.alarm,
        color: Colors.teal,
        pageBuilder: () => const ReminderPage(
          userId: '',
        ),
      ),
      MenuItem(
        title: "Daily Quotes",
        icon: Icons.format_quote_rounded,
        color: Colors.purpleAccent,
        pageBuilder: () => DailyQuotesPage(userId: userId),
      ),
      MenuItem(
        title: "Dear Me",
        icon: Icons.favorite_rounded,
        color: Colors.pinkAccent,
        pageBuilder: () => const DearMePage(
          userId: '',
        ),
      ),
      MenuItem(
        title: "My Journey",
        icon: Icons.timeline_rounded,
        color: Colors.lightBlueAccent,
        pageBuilder: () => JourneyPage(userId: userId),
      ),
    ];
  }
}
