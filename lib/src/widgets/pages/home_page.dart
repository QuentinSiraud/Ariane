import 'package:flutter/material.dart';
import 'package:arianne/src/widgets/components/bars/topBarWidget/topBarWidget.dart';
import 'package:arianne/src/widgets/components/cards/gameCardWidget/gameCardWidget.dart';
import 'package:arianne/src/widgets/components/bars/navBarWidget/navBarWidget.dart';
import 'package:arianne/src/widgets/pages/labyrinthe_page.dart';
import 'package:arianne/src/widgets/pages/calcul_page.dart';
import 'package:arianne/src/widgets/pages/geometire_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<GameCardWidget> cards = [
      const GameCardWidget(
        title: 'Labyrinthe',
        description: 'Créer ton labyrinthe et laisse Michel le résoudre tout seul',
        imagePath: 'lib/assets/images/logo.png',
        page: LabyrinthePage(),
      ),
      const GameCardWidget(
        title: 'Calcul',
        description: 'Résous des calculs mathématiques pour gagner des points',
        imagePath: 'lib/assets/images/logo.png',
        page: CalculPage(),
      ),
      const GameCardWidget(
        title: 'Géométrie',
        description: 'Résous des problèmes de géométrie pour gagner des points',
        imagePath: 'lib/assets/images/logo.png',
        page: GeometirePage(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TopBarWidget(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                for (var card in cards) ...[
                  card,
                  SizedBox(height: 16.0), // Espacement entre les cartes
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}