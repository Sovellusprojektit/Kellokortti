import 'package:flutter/material.dart';

class ClientPopup extends StatefulWidget {
  final List<String> clientNames;
  final Function(String) onValueChange;
  final Function(String, String) onOkPress;

  ClientPopup({
    required this.clientNames,
    required this.onValueChange,
    required this.onOkPress,
  });

  @override
  _ClientPopupState createState() => _ClientPopupState();
}

class _ClientPopupState extends State<ClientPopup> {
  String dropdownValue = '';
  final clientIdController = TextEditingController();

  @override
  void dispose() {
    clientIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        'Enter client information',
        style:
            TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButton<String>(
            hint: Text(
              'Select client',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            dropdownColor: Theme.of(context).primaryColor,
            value: dropdownValue.isEmpty ? null : dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
              widget.onValueChange(newValue!);
            },
            items: widget.clientNames
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: dropdownValue == value
                        ? Theme.of(context).textTheme.displayLarge!.color
                        : Theme.of(context).textTheme.bodyLarge!.color,
                            
                  ),
                ),
              );
            }).toList(),
          ),
          TextField(
            controller: clientIdController,
            decoration: const InputDecoration(
              hintText: 'Invoice ID',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            widget.onOkPress(clientIdController.text, '');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
