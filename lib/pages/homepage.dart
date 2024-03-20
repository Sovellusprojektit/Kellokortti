import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utility/router.dart' as route;
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/drawer_tile.dart';

class HomePage extends StatefulWidget {
  final bool isWeb;

  const HomePage({super.key, required this.isWeb});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   String? user = FirebaseAuth.instance.currentUser?.uid;
  String? firstName;
  String? email;
  final _userInfo = Hive.box('userData');
  bool? _isAdmin;

  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser?.email;
    isAdmin();
    getFname();
    print(FirebaseAuth.instance.currentUser?.email);
  }

  void isAdmin() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_userInfo.get('uid'))
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            _isAdmin = documentSnapshot.get('isAdmin');
          });
        }
      });
    } else {
      setState(() {
        _isAdmin = false;
      });
    }
  }
  void getFname() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot['fname'] as String?;
        });
      } else {
        print('Käyttäjää ei löydy');
      }
    }).catchError((error) {
      print('Virhe: $error');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade800),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/pfp_placeholder.jpg'),
              ),
            ),
            ThemedListTile(
              icon: Icons.home_rounded,
              text: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            ThemedListTile(
              icon: Icons.calendar_month_rounded,
              text: 'Calendar',
              onTap: () => Navigator.pushNamed(context, route.calendarPage),
            ),
            ThemedListTile(
              icon: Icons.info_rounded,
              text: 'Guide',
              onTap: () => Navigator.pushNamed(context, route.guide),
            ),
            ThemedListTile(
              icon: Icons.payment_rounded,
              text: 'Salary information',
              onTap: () => Navigator.pushNamed(context, route.salaryInfo),
            ),
            ThemedListTile(
              icon: Icons.person_rounded,
              text: 'Profile',
              onTap: () => Navigator.pushNamed(context, route.profilePage),
            ),
            ThemedListTile(
              icon: Icons.menu,
              text: 'Menu',
              onTap: () => Navigator.pushNamed(context, route.menuPage),
            ),
            if (_isAdmin ?? false)
              ThemedListTile(
                icon: Icons.privacy_tip_outlined,
                text: 'AdminHomePage',
                onTap: () {
                  Navigator.pushNamed(context, route.adminHomePage);
                },
              ),
            ThemedListTile(
              icon: Icons.settings_rounded,
              text: 'Settings',
              onTap: () => Navigator.pushNamed(context, route.settingsPage),
            ),
          ],
        ),
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
            child: Text(
              'Welcome back, $firstName!',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.5),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, route.menuPage),
              child: const Text('Start your day!'),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, route.salaryInfo),
              child: const Text('Salary information'),
            ),
          ),
        ],
      ),
    );
  }
}
