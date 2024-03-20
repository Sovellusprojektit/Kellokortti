import 'package:flutter/material.dart';

class Guide extends StatefulWidget {
  final bool isWeb;

  const Guide({super.key, required this.isWeb});

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ohjeet'),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(15),
        child: widget.isWeb
            ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                ),
              )
            : ListView(
                children: [
                  Text(
                    'Ohjeet sovelluksen käyttöön:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '1. Kirjaudu sisään tai rekisteröidy.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '2. Valitse "Start your day!" jos haluat aloittaa työpäiväsi.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '3. Valitse "Start shift" kun olet valmis aloittamaan työvuorosi.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '4. Valitse "Start lunch" tai "Start personal" jos haluat aloittaa tauon tai henkilökohtaisen menon.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '5. Valitse "End lunch" tai "End personal" kun olet valmis lopettamaan tauon tai henkilökohtaisen menon.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '6. Valitse "End shift" kun olet valmis lopettamaan työvuorosi.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '7. Vetovalikosta voit valita "Salary information". Tällä sivulla voit muokata palkkatietojasi.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '8. Palkkatiedot sivulta löytyy myös painike "Workhistory". Tällä sivulla voit tarkastella työhistoriaasi.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
      ),
    );
  }
}
