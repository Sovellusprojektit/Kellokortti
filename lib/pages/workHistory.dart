import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Workhistory extends StatefulWidget {
  final bool isWeb;
  
  const Workhistory({super.key, required this.isWeb});

  @override
  State<Workhistory> createState() => _WorkhistoryState();
}

class _WorkhistoryState extends State<Workhistory> {
  final _userInfo = Hive.box('userData');
  String? uID;
  dynamic info = [];
  late Timestamp ts;
  DateTime? dt;
  late Timestamp ts1;
  DateTime? dt1;
  late Timestamp ts2;
  DateTime? dt2;
  late Timestamp ts3;
  DateTime? dt3;

  @override
  void initState() {
    super.initState();
    uID = _userInfo.get("uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workhistory'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('/Users/$uID/workTime')
              .snapshots(),
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
                ts = data['startWork'];
                ts1 = data['endWork'];
                ts2 = data['startLunch'];
                ts3 = data['endLunch'];
                dt = ts.toDate();
                dt1 = ts1.toDate();
                dt2 = ts2.toDate();
                dt3 = ts3.toDate();

                return ExpansionTile(
                  title: Text(
                    'Shift started: ${Text('$dt').toString().substring(6, 25)}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  children: [
                    ListTile(
                      textColor: Theme.of(context).textTheme.bodyLarge!.color,
                      title: Column(
                        children: [
                          Text(
                              'Lunch started:${Text('$dt2').toString().substring(16, 25)}'),
                          const SizedBox(height: 10),
                          Text(
                              'Lunch ended:${Text('$dt3').toString().substring(16, 25)}'),
                          const SizedBox(height: 10),
                          Text(
                              'Shift ended:${Text('$dt1').toString().substring(16, 25)}'),
                          const SizedBox(height: 10),
                          Text('Worktime (hh/mm/ss): ' + data['workDuration']),
                          const SizedBox(height: 10),
                          Text('After breaks (hh/mm/ss): ' +
                              data['workDurationAfterBreaks']),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  ],
                );
              }).toList(),
            );
          }),
    );
  }
}
