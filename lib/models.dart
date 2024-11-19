class TimeEntry {
  final String project;
  final String task;
  final DateTime startTime;
  final DateTime endTime;
  final String notes;

  TimeEntry({
    required this.project,
    required this.task,
    required this.startTime,
    required this.endTime,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'task': task,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'notes': notes,
    };
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      project: json['project'],
      task: json['task'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      notes: json['notes'],
    );
  }
}