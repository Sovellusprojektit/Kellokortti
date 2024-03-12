import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utility/router.dart' as route;
import 'package:hive_flutter/hive_flutter.dart';

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
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Home'),
              iconColor: Theme.of(context).iconTheme.color,
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_rounded),
              iconColor: Theme.of(context).iconTheme.color,
              title: const Text('Calendar'),
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              onTap: () => Navigator.pushNamed(context, route.calendarPage),
            ),
            ListTile(
                leading: const Icon(Icons.message_rounded),
                iconColor: Theme.of(context).iconTheme.color,
                title: const Text('Messages'),
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
                onTap: () {} //Navigator.pushNamed(context, route.messagePage),
                ),
            ListTile(
              leading: const Icon(Icons.payment_rounded),
              title: const Text('Salary information'),
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              iconColor: Theme.of(context).iconTheme.color,
              onTap: () => Navigator.pushNamed(context, route.salaryInfo),
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text('Profile'),
              iconColor: Theme.of(context).iconTheme.color,
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
              onTap: () => Navigator.pushNamed(context, route.profilePage),
            ),
            ListTile(
                leading: const Icon(Icons.menu),
                title: const Text('Menu'),
                iconColor: Theme.of(context).iconTheme.color,
                textColor: Theme.of(context).textTheme.bodyLarge!.color,
                onTap: () => Navigator.pushNamed(context, route.menuPage)),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('AdminHomePage'),
              iconColor: Theme.of(context).iconTheme.color,
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
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
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              iconColor: Theme.of(context).iconTheme.color,
              textColor: Theme.of(context).textTheme.bodyLarge!.color,
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
