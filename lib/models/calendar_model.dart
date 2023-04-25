import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'event.dart';

class CalendarModel extends StatefulWidget {
   const CalendarModel({Key? key}) : super(key: key);

  @override
  State<CalendarModel> createState() => _CalendarModelState();
}

class _CalendarModelState extends State<CalendarModel> {
  @override
  void initState() {
    super.initState();
  }

 @override
Widget build(BuildContext context) {
  return FutureBuilder<List<Event>>(
    future: Provider.of<EventManager>(context).getEventsFromFirebase(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error loading events: ${snapshot.error}'),
        );
      } else {
        final eventList = snapshot.data!;
        return SfCalendar(
          dataSource: EventDataSource(eventList),
          showNavigationArrow: true,
          firstDayOfWeek: 1,
          initialSelectedDate: DateTime.now(),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          cellBorderColor: Colors.transparent,
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).iconTheme.color!,
              width: 1.5,
            ),
          ),
          todayHighlightColor: Theme.of(context).iconTheme.color,
          viewHeaderStyle: ViewHeaderStyle(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            dayTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          headerStyle: CalendarHeaderStyle(
            textStyle: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          view: CalendarView.month,
          monthViewSettings: MonthViewSettings(
            showAgenda: true,
            showTrailingAndLeadingDates: false,
            monthCellStyle: MonthCellStyle(
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
            ),
            agendaStyle: AgendaStyle(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              dateTextStyle: Theme.of(context).textTheme.displayLarge,
              dayTextStyle: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
            ),
          ),
        );
      }
    },
  );
}
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  Event getEvent(int index) {
    return appointments?[index] as Event;
  }

  @override
  DateTime getStartTime(int index) {
    return getEvent(index).start;
  }

  @override
  DateTime getEndTime(int index) {
    return getEvent(index).end;
  }

  @override
  String getSubject(int index) {
    return getEvent(index).title;
  }

  @override
  Color getColor(int index) {
    return getEvent(index).color;
  }

  @override
  bool isAllDay(int index) {
    return getEvent(index).isAllDay;
  }
}
