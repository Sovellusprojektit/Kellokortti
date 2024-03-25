import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/client_popup.dart';
import 'package:intl/intl.dart';

class MenuPage extends StatefulWidget {
  final bool isWeb;

  const MenuPage({super.key, required this.isWeb});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _timeStampInfo = Hive.box('userData');

  DateTime time = DateTime.now();
  DateTime? lunchStart;
  DateTime? lunchEnd;
  DateTime? personalStart;
  DateTime? personalEnd;
  String? docId;
  String? uId;
  bool _atWork = false;
  bool _atLunch = false;
  bool _atPersonal = false;
  String dropdownValue = '';
  final clientIdController = TextEditingController();
  List<String> clientNames = [];
  late String fname;
  late String lname;

  void getTimeStamp() {
    setState(() {
      time = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    uId = _timeStampInfo.get('uid');

    getClients();
    getUserName();

    if (_timeStampInfo.containsKey('atWork')) {
      _atWork = _timeStampInfo.get('atWork');
    } else {
      _timeStampInfo.put('atWork', _atWork);
    }

    if (_timeStampInfo.containsKey('atLunch')) {
      _atLunch = _timeStampInfo.get('atLunch');
    } else {
      _timeStampInfo.put('atLunch', _atLunch);
    }

    if (_timeStampInfo.containsKey('atPersonal')) {
      _atPersonal = _timeStampInfo.get('atPersonal');
    } else {
      _timeStampInfo.put('atPersonal', _atPersonal);
    }
  }

  bool checkWorkStatus(bool a, bool b) {
    if (a == b) {
      return true;
    } else {
      return false;
    }
  }

  void getClients() async {
    final List<String> clients = [];
    await FirebaseFirestore.instance
        .collection('/Clients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        clients.add(doc['name']);
      }
    });

    setState(() {
      clientNames = clients;
    });
  }

  void getUserName() async {
    FirebaseFirestore.instance
        .collection('/Users')
        .doc(uId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          fname = documentSnapshot.get('fname');
          lname = documentSnapshot.get('lname');
        });
      }
    });
  }

  String getFormattedTime(DateTime time) {
    return DateFormat('dd-MM hh:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Menu"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/homepage_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: _atWork
                ? Column(
                    children: [
                      const SizedBox(height: 50.0),
                      Text('Active client: ${_timeStampInfo.get('clientName')}',
                          style: Theme.of(context).textTheme.displayLarge),
                      Text(
                          'Start time: ${getFormattedTime(_timeStampInfo.get("startWork"))}',
                          style: Theme.of(context).textTheme.bodyLarge),
                      widget.isWeb
                          ? const SizedBox(height: 200.0)
                          : const Spacer(),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            getTimeStamp();
                            endWork();
                            setState(() {
                              _atWork = false;
                            });
                          },
                          child: const Text('End work'))
                    ],
                  )
                : Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).appBarTheme.foregroundColor!,
                          Theme.of(context).appBarTheme.backgroundColor!,
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ClientPopup(
                              clientNames: clientNames,
                              onValueChange: (newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              onOkPress: (invoiceId) async {
                                if (dropdownValue.isNotEmpty) {
                                  _timeStampInfo.put(
                                      'clientName', dropdownValue);
                                  FirebaseFirestore.instance
                                      .collection('Clients')
                                      .where('name', isEqualTo: dropdownValue)
                                      .get()
                                      .then((querySnapshot) async {
                                    for (var doc in querySnapshot.docs) {
                                      var clientDoc = FirebaseFirestore.instance
                                          .collection('Clients')
                                          .doc(doc.id);
                                      _timeStampInfo.put('clientRoot', doc.id);

                                      if (invoiceId.isEmpty) {
                                        invoiceId = "Invoice ID not provided";
                                      }

                                      await clientDoc
                                          .collection('general')
                                          .add({
                                        'startWork': time,
                                        'invoiceId': invoiceId,
                                        'name': '$fname $lname',
                                        'clientName': dropdownValue,
                                      }).then((docRef) {
                                        _timeStampInfo.put(
                                            'clientDocId', docRef.id);
                                        print(
                                            "Document added with ID: ${docRef.id}");

                                        startWork();
                                      }).catchError((error) {
                                        print("Failed to add document: $error");
                                      });
                                    }
                                  });
                                }
                                getTimeStamp();
                              },
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.work,
                        size: 70.0,
                        color: Theme.of(context)
                            .floatingActionButtonTheme
                            .foregroundColor,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  DocumentReference? clientWorkDocumentRef;

  void startWork() async {
    setState(() {
      _atWork = true;
      docId = time.toString().substring(0, 19);
    });
    _timeStampInfo.put('docId', docId);
    _timeStampInfo.put('startWork', time);
    FirebaseFirestore.instance
        .collection('/Users/$uId/workTime')
        .doc(_timeStampInfo.get('docId'))
        .set({
      'startWork': time,
    });
  }

  void endWork() async {
    DateTime? startWork = _timeStampInfo.get('startWork') as DateTime?;
    if (startWork == null) {
      return;
    }

    setState(() {
      _atWork = false;
    });
    Duration duration = time.difference(startWork);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String durationString = '$hours:$minutes:$seconds';

    DateTime? lunchEnd = _timeStampInfo.get('lunchEnd') as DateTime?;
    DateTime? personalEnd = _timeStampInfo.get('personalEnd') as DateTime?;

    Duration? lunchDuration =
        lunchEnd?.difference(_timeStampInfo.get('lunchStart') as DateTime);
    Duration? personalDuration = personalEnd
        ?.difference(_timeStampInfo.get('personalStart') as DateTime);

    Duration workDurationAfterBreaks = duration;

    if (lunchDuration != null) {
      workDurationAfterBreaks -= lunchDuration;
    }

    if (personalDuration != null) {
      workDurationAfterBreaks -= personalDuration;
    }

    int workHours = workDurationAfterBreaks.inHours;
    int workMinutes = workDurationAfterBreaks.inMinutes.remainder(60);
    int workSeconds = workDurationAfterBreaks.inSeconds.remainder(60);
    String workDurationString = '$workHours:$workMinutes:$workSeconds';

    int minuutti = workDurationAfterBreaks.inMinutes;
    double minute = (minuutti - 480) / 60;
    FirebaseFirestore.instance
        .collection('/Users/$uId/workTime')
        .doc(_timeStampInfo.get('docId'))
        .set({
      'endWork': time,
      'workDuration': durationString,
      'workDurationAfterBreaks': workDurationString,
      'overHours': minute
    }, SetOptions(merge: true));

    //This is to retrieve the same original CLIENT document that was created when starting work
    String? clientDocId = _timeStampInfo.get('clientDocId');
    String? clientRoot = _timeStampInfo.get('clientRoot');
    print("ClientRoot: $clientRoot ja clientDocId: $clientDocId");
    clientWorkDocumentRef = FirebaseFirestore.instance
        .collection('Clients')
        .doc(clientRoot)
        .collection('general')
        .doc(clientDocId);

    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .set({'isWorking': false}, SetOptions(merge: true));
    print("endWork: $clientWorkDocumentRef");
    await clientWorkDocumentRef!.update(
      {
        'endWork': time,
        'workDuration': durationString,
        'workDurationAfterBreaks': workDurationString,
      },
    );

    _timeStampInfo.delete('startWork');
    _timeStampInfo.delete('lunchStart');
    _timeStampInfo.delete('lunchEnd');
    _timeStampInfo.delete('personalStart');
    _timeStampInfo.delete('personalEnd');
    _timeStampInfo.delete('clientName');
    _timeStampInfo.delete('clientDocId');
    _timeStampInfo.delete('clientRoot');
  }

  void startLunch() async {
    setState(() {
      lunchStart = time;
    });
    _timeStampInfo.put('lunchStart', lunchStart);
    FirebaseFirestore.instance
        .collection('/Users/$uId/workTime')
        .doc(_timeStampInfo.get('docId'))
        .set({
      'startLunch': lunchStart,
    }, SetOptions(merge: true));
  }

  void endLunch() async {
    setState(() {
      lunchEnd = time;
    });
    Duration lunchDuration =
        lunchEnd!.difference(_timeStampInfo.get('lunchStart') as DateTime);
    int lunchHours = lunchDuration.inHours;
    int lunchMinutes = lunchDuration.inMinutes.remainder(60);
    int lunchSeconds = lunchDuration.inSeconds.remainder(60);
    String durationString = '$lunchHours:$lunchMinutes:$lunchSeconds';
    _timeStampInfo.put('lunchEnd', lunchEnd);

    FirebaseFirestore.instance
        .collection('/Users/$uId/workTime')
        .doc(_timeStampInfo.get('docId'))
        .set({
      'endLunch': lunchEnd as DateTime,
      'lunchDuration': durationString,
    }, SetOptions(merge: true));
  }

  void startPersonal() async {
    setState(() {
      personalStart = time;
    });
    _timeStampInfo.put('personalStart', personalStart);
    FirebaseFirestore.instance
        .collection('/Users/$uId/workTime')
        .doc(_timeStampInfo.get('docId'))
        .set({
      'startPersonal': personalStart,
    }, SetOptions(merge: true));
  }

  void endPersonal() async {
    setState(() {
      personalEnd = time;
    });
    Duration personalDuration = personalEnd!
        .difference(_timeStampInfo.get('personalStart') as DateTime);
    int personalHours = personalDuration.inHours;
    int personalMinutes = personalDuration.inMinutes.remainder(60);
    int personalSeconds = personalDuration.inSeconds.remainder(60);
    String durationString = '$personalHours:$personalMinutes:$personalSeconds';
    _timeStampInfo.put('personalEnd', personalEnd);

    FirebaseFirestore.instance
        .collection('/Users/$uId/workTime')
        .doc(_timeStampInfo.get('docId'))
        .set({
      'endPersonal': personalEnd as DateTime,
      'personalDuration': durationString,
    }, SetOptions(merge: true));
  }
}
