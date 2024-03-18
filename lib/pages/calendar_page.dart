import 'package:flutter/material.dart';
import '../models/calendar_model.dart';


class CalendarPage extends StatefulWidget {
  final bool isWeb;
  
  const CalendarPage({super.key, required this.isWeb});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
          centerTitle: true,
        ),
        body: const CalendarModel(),
        );
  }
}
