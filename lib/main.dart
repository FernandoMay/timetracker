import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/projecttaskman.dart';
import 'package:timetracker/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeEntryProvider(),
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: const ProjectTaskManagementScreen(),
        // routes: {
        //   '/add_time_entry': (context) => const AddTimeEntryScreen(),
        // },
      ),
    );
  }
}