import 'package:flutter/material.dart';

// Widget principal de carte de jeu
class GameCardWidget extends StatelessWidget {
  final String title;        // Titre du jeu affiché sous l'image
  final String description;  // Description dans la bulle blanche
  final String imagePath;    // Chemin vers l'image (Asset)
  final Widget page;         // Page à ouvrir au clic

  const GameCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Ombre
      clipBehavior: Clip.antiAlias, // Couper proprement les coins
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Coins arrondis
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFDE7E7), // Dégradé rose pâle
                Color(0xFFF9CFCF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Partie gauche : image + titre
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePath,
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Partie droite : bulle blanche avec découpe
              Expanded(
                child: ClipPath(
                  clipper: _BubbleClipper(),
                  child: Container(
                    height: double.infinity,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 28.0;
    final path = Path();
    // Arrondi haut gauche
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    // Ligne droite jusqu'à la découpe haut droite
    path.lineTo(size.width - radius - 18, 0);
    // Découpe douce en haut à droite
    path.quadraticBezierTo(
      size.width - 10, 0, size.width - 10, 18);
    path.lineTo(size.width, 30);
    path.lineTo(size.width, size.height - radius);
    // Arrondi bas droite
    path.quadraticBezierTo(
      size.width, size.height, size.width - radius, size.height);
    // Ligne bas gauche
    path.lineTo(radius, size.height);
    // Arrondi bas gauche
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
