import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models.dart';
import 'package:timetracker/providers.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectController = TextEditingController();
  final _taskController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final timeEntry = TimeEntry(
        project: _projectController.text,
        task: _taskController.text,
        startTime: _startTime,
        endTime: _endTime,
        notes: _notesController.text,
      );

      Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(timeEntry);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _projectController,
                decoration: const InputDecoration(labelText: 'Project'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: 'Task'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedTime = await showDatePicker(
                          context: context,
                          initialDate: _startTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _startTime = selectedTime;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Start Time'),
                    ),
                    Text(_startTime.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_endTime),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _endTime = DateTime(
                              _endTime.year,
                              _endTime.month,
                              _endTime.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: const Text('End Time'),
                    ),
                    Text(_endTime.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Time Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}