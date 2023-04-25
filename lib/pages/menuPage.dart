import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utility/router.dart' as route;

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

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

  void getTimeStamp() {
    setState(() {
      time = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    uId = _timeStampInfo.get('uid');

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _atWork
                    ? Text(
                        " Shift started at: ${_timeStampInfo.get('startWork').toString().substring(0, 16)}",
                        style: Theme.of(context).textTheme.bodyLarge)
                    : const Text("Shift not started yet",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 350),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  color: Theme.of(context)
                      .elevatedButtonTheme
                      .style!
                      .backgroundColor!
                      .resolve(<MaterialState>{}),
                  textColor: Theme.of(context).textTheme.bodyLarge!.color,
                  disabledColor: Colors.grey[500],
                  height: 45,
                  onPressed: checkWorkStatus(_atLunch, _atPersonal)
                      ? () {
                          if (_atWork) {
                            getTimeStamp();
                            endWork();
                          } else {
                            getTimeStamp();
                            startWork();
                          }
                          setState(() {
                            _atWork = !_atWork;
                            _timeStampInfo.put('atWork', _atWork);
                          });
                        }
                      : null,
                  child: _atWork
                      ? const Text("End shift")
                      : const Text("Start shift"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.35,
                      color: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .backgroundColor!
                          .resolve(<MaterialState>{}),
                      textColor: Theme.of(context).textTheme.bodyLarge!.color,
                      disabledColor: Colors.grey[500],
                      height: 45,
                      onPressed: checkWorkStatus(_atWork, _atPersonal)
                          ? null
                          : () {
                              if (_atLunch) {
                                getTimeStamp();
                                endLunch();
                              } else {
                                getTimeStamp();
                                startLunch();
                              }
                              setState(() {
                                _atLunch = !_atLunch;
                                _timeStampInfo.put('atLunch', _atLunch);
                              });
                            },
                      child: _atLunch
                          ? const Text("End lunch")
                          : const Text("Start lunch"),
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.35,
                      color: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .backgroundColor!
                          .resolve(<MaterialState>{}),
                      textColor: Theme.of(context).textTheme.bodyLarge!.color,
                      disabledColor: Colors.grey[500],
                      height: 45,
                      onPressed: checkWorkStatus(_atWork, _atLunch)
                          ? null
                          : () {
                              if (_atPersonal) {
                                getTimeStamp();
                                endPersonal();
                              } else {
                                getTimeStamp();
                                startPersonal();
                              }
                              setState(() {
                                _atPersonal = !_atPersonal;
                                _timeStampInfo.put('atPersonal', _atPersonal);
                              });
                            },
                      child: _atPersonal
                          ? const Text("End personal")
                          : const Text("Start personal"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, route.homePage);
                    },
                    child: const Text("Go back")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startWork() async {
    setState(() {
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

    _timeStampInfo.delete('lunchStart');
    _timeStampInfo.delete('lunchEnd');
    _timeStampInfo.delete('personalStart');
    _timeStampInfo.delete('personalEnd');
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
