import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHistory extends StatefulWidget {
  final String uID;

  const AdminHistory({required this.uID, Key? key}) : super(key: key);

  @override
  State<AdminHistory> createState() => _AdminHistoryState();
}

class _AdminHistoryState extends State<AdminHistory> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workhistory'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('/Users/${widget.uID}/workTime')
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
                      'Shift started: ${Text('$dt').toString().substring(6, 25)}'),
                  children: [
                    ListTile(
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
                          Text('Worktime (hh/mm/ss): ${data['workDuration']}'),
                          const SizedBox(height: 10),
                          Text(
                              'After breaks (hh/mm/ss): ${data['workDurationAfterBreaks']}'),
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
