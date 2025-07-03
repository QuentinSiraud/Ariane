import 'package:flutter/material.dart';

class ScoreNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ScoreNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final games = [
      {'icon': 'lib/assets/images/logo.png', 'label': 'Labyrinthe'},
      {'icon': 'lib/assets/images/logo.png', 'label': 'Calcul'},
      {'icon': 'lib/assets/images/logo.png', 'label': 'Géométrie'},
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFEAA9B8), Color(0xFFB6C6F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(games.length, (index) {
          final game = games[index];
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Image.asset(
                    game['icon']!,
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  game['label']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isSelected ? Colors.black : Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}