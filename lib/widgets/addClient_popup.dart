import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  AddClientState createState() => AddClientState();
}

class AddClientState extends State<AddClient> {
  String clientName = "";
  int? clientId;

  void addClient() {
    FirebaseFirestore.instance.collection('Clients').add({
      'name': '$clientName',
      'id': '$clientId',
    });
  }

  final nameController = TextEditingController();
  final idController = TextEditingController();
  
 @override
 void dispose() {
   nameController.dispose();
   idController.dispose();
   super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        'Add client',
        style: TextStyle(
          color: Theme.of(context).textTheme.displayLarge!.color,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: nameController,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              labelText: 'Client name',
            ),
          ),
          TextField(
            controller: idController,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              labelText: 'Client id',
            ),
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              clientName = nameController.text;
              clientId = int.tryParse(idController.text) ?? clientId;
            });
            addClient();
          },
          child: const Text('Add client'),
        ),
      ],
    );
  }
}
