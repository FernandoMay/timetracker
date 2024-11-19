import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetracker/models.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _timeEntries = [];

  List<TimeEntry> get timeEntries => _timeEntries;

  Future<void> loadTimeEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final encodedEntries = prefs.getStringList('timeEntries');

  if (encodedEntries != null) {
    _timeEntries = encodedEntries.map((entry) {
      return TimeEntry.fromJson(jsonDecode(entry));
    }).toList();
    notifyListeners();
  }
}

  Future<void> addTimeEntry(TimeEntry entry) async {
    _timeEntries.add(entry);
    notifyListeners();
    await saveTimeEntries();
  }

  Future<void> deleteTimeEntry(int index) async {
    _timeEntries.removeAt(index);
    notifyListeners();
    await saveTimeEntries();
  }

  Future<void> saveTimeEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final encodedEntries = _timeEntries.map((entry) {
    return jsonEncode(entry.toJson());
  }).toList();
  await prefs.setStringList('timeEntries', encodedEntries);
}

  List<TimeEntry> getEntriesByProject(String project) {
    return _timeEntries.where((entry) => entry.project == project).toList();
  }

  List<TimeEntry> getEntriesByDateRange(DateTime startDate, DateTime endDate) {
    return _timeEntries.where((entry) =>
        entry.startTime.isAfter(startDate) && entry.endTime.isBefore(endDate))
        .toList();
  }

  List<TimeEntry> filterEntriesByKeyword(String keyword) {
    return _timeEntries.where((entry) =>
        entry.project.contains(keyword) ||
        entry.task.contains(keyword) ||
        entry.notes.contains(keyword))
        .toList();
  }
}