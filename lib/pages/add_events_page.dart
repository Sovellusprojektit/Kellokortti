import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:provider/provider.dart';

class AddEventsPage extends StatefulWidget {
  final Event? event;

  const AddEventsPage({Key? key, this.event}) : super(key: key);

  @override
  State<AddEventsPage> createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  late DateTime _startDate;
  late DateTime _endDate;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(hours: 8));
    } else {
      _startDate = widget.event!.start;
      _endDate = widget.event!.end;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Events'),
        centerTitle: true,
        leading: const CloseButton(),
        actions: saveEventButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/abstract_background.png'),
                    fit: BoxFit.cover),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    TextFormField(
                      style: Theme.of(context).textTheme.displayLarge,
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Event Title',
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      //onFieldSubmitted: (_) => saveEvent(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Start Date', style:Theme.of(context).textTheme.displayLarge),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildDropdownField(
                            text: EventUtility.toDate(_startDate),
                            onTap: () => pickFromDateTime(pickDate: true),
                          ),
                        ),
                        Expanded(
                          child: buildDropdownField(
                            text: EventUtility.toTime(_startDate),
                            onTap: () => pickFromDateTime(pickDate: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('End Date', style:Theme.of(context).textTheme.displayLarge),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildDropdownField(
                            text: EventUtility.toDate(_endDate),
                            onTap: () => pickToDateTime(pickDate: true),
                          ),
                        ),
                        Expanded(
                          child: buildDropdownField(
                            text: EventUtility.toTime(_endDate),
                            onTap: () => pickToDateTime(pickDate: false),
                          ),
                        ),
                      ],
                    ),
                   const SizedBox(height: 20),
                   TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Event Description',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minLines: 3,
                    maxLines: 5,
                    //onFieldSubmitted: (_) => saveEvent(),

                   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> saveEventButton() {
    return [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).iconTheme.color,
          shadowColor: Colors.transparent,
        ),
        onPressed: saveEvent,
        icon: const Icon(Icons.save),
        label: Text(widget.event == null ? 'Save' : 'Update'),
      ),
    ];
  }

  Widget buildDropdownField(
      {required String text, required VoidCallback onTap}) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onTap,
    );
  }

  Future<void> pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(_startDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(_endDate)) {
      setState(() {
        _endDate = DateTime(
            date.year, date.month, date.day, _endDate.hour, _endDate.minute);
      });
    }

    setState(() {
      _startDate = date;
    });
  }

  Future<void> pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(_endDate,
        pickDate: pickDate, firstDate: pickDate ? _startDate : null);
    if (date == null) return;

    setState(() {
      _endDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2019, 1, 1),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  void saveEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        start: _startDate,
        end: _endDate,
      );
      final manager = Provider.of<EventManager>(context, listen: false);
      manager.addEvent(event);
      Navigator.of(context).pop();
    }
  }
}
