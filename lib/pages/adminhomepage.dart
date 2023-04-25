import 'package:flutter/material.dart';
import '../utility/router.dart' as route;

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin user'),
        centerTitle: true,
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
          Column(
            children: [
              const SizedBox(
                height: 350,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, route.calendarAdmin),
                 
                  child: const Text("Calendar"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () =>
                    Navigator.pushNamed(context, route.manageEmployees),
                  child: const Text("Manage employees"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 70,
              ),

              // Voi kopioida takaisin napin ja asettaa haluaman navigoinnin.
              /*Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, route.homePage);
                    },
                    child: const Text("Takaisin")),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
