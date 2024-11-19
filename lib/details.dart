import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models.dart';
import 'package:timetracker/providers.dart';

class TimeEntryDetailsScreen extends StatelessWidget {
  final TimeEntry timeEntry;

  const TimeEntryDetailsScreen({super.key, required this.timeEntry});

  @override
  Widget build(BuildContext context) {
    final timeEntries = Provider.of<TimeEntryProvider>(context).timeEntries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Entry Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement editing functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TimeEntryProvider>(context, listen: false)
                  .deleteTimeEntry(timeEntries.indexOf(timeEntry));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project: ${timeEntry.project}'),
            Text('Task: ${timeEntry.task}'),
            Text('Start Time: ${timeEntry.startTime}'),
            Text('End Time: ${timeEntry.endTime}'),
            Text('Duration: ${timeEntry.endTime.difference(timeEntry.startTime)}'),
            if (timeEntry.notes.isNotEmpty)
              Text('Notes: ${timeEntry.notes}'),
          ],
        ),
      ),
    );
  }
}