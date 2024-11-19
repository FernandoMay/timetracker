import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/addtimeentry.dart';
import 'package:timetracker/details.dart';
import 'package:timetracker/models.dart';
import 'package:timetracker/providers.dart';

class ProjectTaskManagementScreen extends StatefulWidget {
  const ProjectTaskManagementScreen({super.key});

  @override
  State<ProjectTaskManagementScreen> createState() =>
      _ProjectTaskManagementScreenState();
}

class _ProjectTaskManagementScreenState
    extends State<ProjectTaskManagementScreen> {
  //final _searchController = TextEditingController();
  String _searchText = '';

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeEntries = Provider.of<TimeEntryProvider>(context).timeEntries;
    final filteredEntries = _searchText.isEmpty
        ? timeEntries
        : timeEntries
            .where((entry) =>
                entry.project
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                entry.task.toLowerCase().contains(_searchText.toLowerCase()) ||
                entry.notes.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _SearchDelegate(filteredEntries),
              );
            },
          ),
        ],
      ),
      drawer: const Drawer(
        child: Column(children: [
          ListTile(title: Text('Projects'),),
          ListTile(title: Text('Tasks'),),
        ],),
      ),
      body: ListView.builder(
        itemCount: filteredEntries.length, //timeEntries.length,
        itemBuilder: (context, index) {
          final entry = timeEntries[index];
          final duration = entry.endTime.difference(entry.startTime);

          return Dismissible(
            key: Key(entry.toString()),
            onDismissed: (direction) {
              Provider.of<TimeEntryProvider>(context, listen: false)
                  .deleteTimeEntry(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(Icons.delete),
            ),
            child: ListTile(
              title: Text(entry.project),
              subtitle: Text(entry.task),
              trailing: Text(
                  '${duration.inHours}h ${duration.inMinutes.remainder(60)}m'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TimeEntryDetailsScreen(timeEntry: entry),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTimeEntryScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  final List<TimeEntry> _entries;

  _SearchDelegate(this._entries);

  @override
  String? get searchFieldLabel => 'Search time entries';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final timeEntries = Provider.of<TimeEntryProvider>(context).timeEntries;
    final filteredEntries = _entries
        .where((entry) =>
            entry.project.toLowerCase().contains(query.toLowerCase()) ||
            entry.task.toLowerCase().contains(query.toLowerCase()) ||
            entry.notes.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = timeEntries[index];
        final duration = entry.endTime.difference(entry.startTime);

        return Dismissible(
          key: Key(entry.toString()),
          onDismissed: (direction) {
            Provider.of<TimeEntryProvider>(context, listen: false)
                .deleteTimeEntry(index);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
            title: Text(entry.project),
            subtitle: Text(entry.task),
            trailing: Text(
                '${duration.inHours}h ${duration.inMinutes.remainder(60)}m'),
            onTap: () {
              // Implement details screen or editing functionality here
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement suggestions if needed
    return const SizedBox.shrink();
  }
}
