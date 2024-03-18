import 'package:flutter/material.dart';
import '../models/calendar_model.dart';
import '../utility/router.dart' as route;

class CalendarAdmin extends StatefulWidget {
  final bool isWeb;
  
  const CalendarAdmin({super.key, required this.isWeb});

  @override
  State<CalendarAdmin> createState() => _CalendarAdminState();
}

class _CalendarAdminState extends State<CalendarAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
          centerTitle: true,
        ),
        body: const CalendarModel(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, route.addEvent);
          },
          child: const Icon(Icons.add),
        ));
  }
}
