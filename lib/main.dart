import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './utility/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobprojekti/models/event.dart';
import 'package:mobprojekti/utility/theme_provider.dart';
import 'package:provider/provider.dart';
import 'utility/theme_data.dart';
import './utility/router.dart' as route;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('userData');
  runApp(const MyApp(
    isWeb: kIsWeb,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isWeb});

  final bool isWeb;

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    print("isWeb: ${widget.isWeb}");
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in! ${user.uid}');
      }
    });
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventManager(),
      child: MaterialApp(
        onGenerateRoute: (settings) => _generateRoute(settings, widget.isWeb),
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: currentTheme.currentTheme(),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? route.loginPage
            : route.homePage,
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings, bool isWeb) {
    return route.controller(settings, isWeb: isWeb);
  }
}
