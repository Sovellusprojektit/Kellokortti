import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/addClient_popup.dart';
import '../utility/router.dart' as route;


class AddClients extends StatefulWidget {
  final bool isWeb;
  const AddClients({super.key, required this.isWeb});

  @override
  State<AddClients> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddClients> {
    @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clients'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: const DecorationImage(
            image: AssetImage('assets/employee_manager_bcgrnd.jpg'),
            fit: BoxFit.cover,
          ),
          
        ),
      child: StreamBuilder <QuerySnapshot> (stream: 
      FirebaseFirestore.instance.collection('Clients').snapshots(),
      builder: 
      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No clients found'));
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Center(
              child: Container(
                width: 400,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Client name: ${data['name']}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    Text(
                      'Client ID: ${data['id']}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }
     
      ),
      ),
      

      floatingActionButton: 
        FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddClient();
            },
          ),
          child: const Icon(Icons.add),
        ),
    );
  }


}