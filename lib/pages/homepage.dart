import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utility/router.dart' as route;
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/drawer_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? email;
  final _userInfo = Hive.box('userData');

  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser?.email;
    print(FirebaseAuth.instance.currentUser?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
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
              icon: Icons.message_rounded,
              text: 'Messages',
              onTap: () {}, //Navigator.pushNamed(context, route.messagePage),
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
            ThemedListTile(
              icon: Icons.privacy_tip_outlined,
              text: 'AdminHomePage',
              onTap: () {
                if (_userInfo.get('isAdmin')) {
                  Navigator.pushNamed(context, route.adminHomePage);
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        icon: const Icon(Icons.error_outline),
                        title: const Text('Auth Error'),
                        content:
                            const Text('Only an admin can access this page'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
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
          Text(
            'Welcome back, $email!',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
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
