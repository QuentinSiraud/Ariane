import 'package:flutter/material.dart';
import 'package:arianne/src/widgets/components/bars/navBarWidget/navBarWidget.dart';
import 'package:arianne/src/widgets/components/bars/scoreNavBarWidget/scoreNavBarWidget.dart';
import 'package:arianne/src/widgets/components/cards/scoreCardWidget/scoreCardWidget.dart';

class ScorePage extends StatefulWidget {
  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int selectedGame = 0; // 0: Labyrinthe, 1: Calcul, 2: Géométrie

  // Exemple de scores pour chaque jeu
  final List<List<Map<String, dynamic>>> scores = [
    [
      {'name': 'Alice', 'score': 120},
      {'name': 'Bob', 'score': 95},
    ],
    [
      {'name': 'Alice', 'score': 80},
      {'name': 'Bob', 'score': 110},
    ],
    [
      {'name': 'Alice', 'score': 60},
      {'name': 'Bob', 'score': 70},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats'),
      ),
      body: Column(
        children: [
          ScoreNavBarWidget(
            selectedIndex: selectedGame,
            onSelect: (index) {
              setState(() {
                selectedGame = index;
              });
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (var player in scores[selectedGame])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ScoreCardWidget(
                      playerName: player['name'],
                      score: player['score'],
                      imagePath: 'lib/assets/images/logo.png',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}