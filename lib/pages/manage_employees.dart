// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobprojekti/models/admin_history.dart';
import '../utility/router.dart' as route;

class EmployeeManager extends StatefulWidget {
  const EmployeeManager({Key? key}) : super(key: key);

  @override
  State<EmployeeManager> createState() => _EmployeeManagerState();
}

class _EmployeeManagerState extends State<EmployeeManager> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Manager'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/employee_manager_bcgrnd.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No employees found'));
            }

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return ListTile(
                  title: Text(data['fname'],
                      style: Theme.of(context).textTheme.displayLarge),
                  subtitle: Text(data['email'],
                      style: const TextStyle(color: Colors.white)),
                  trailing: data['isWorking']
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.cancel, color: Colors.red),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.person),
                        title: Text(data['fname'] + ' ' + data['lname'],
                            style: Theme.of(context).textTheme.displayLarge),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            data['isAdmin']
                                ? Text('Admin',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)
                                : Text('Employee',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 10),
                            data['isWorking']
                                ? Text('Currently at work',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)
                                : Text('Not Working right now',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 20),
                            Text("Email: " + data['email'],
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            Text("Phonenumber: " + data['phone'],
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('History'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminHistory(
                                    uID: document.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.person),
                        title: Text(data['fname'] + ' ' + data['lname'],
                            style: Theme.of(context).textTheme.displayLarge),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            data['isAdmin']
                                ? Text('Admin',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)
                                : Text('Employee',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 10),
                            data['isWorking']
                                ? Text('Currently at work',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)
                                : Text('Not Working right now',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 20),
                            Text("Email: " + data['email'],
                                style:
                                    Theme.of(context).textTheme.displayMedium),
                            Text("Phonenumber: " + data['phone'],
                                style:
                                    Theme.of(context).textTheme.displayMedium),
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
                            child: const Text('Delete'),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(document.id)
                                  .delete();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, route.addEmployees);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
