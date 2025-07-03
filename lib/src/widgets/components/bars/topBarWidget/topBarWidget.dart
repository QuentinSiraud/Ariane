import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(), // Ajout d'un Spacer pour centrer le texte
          const Text(
            'Ariane',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
           Transform(
              alignment: Alignment.topRight,
              transform: Matrix4.rotationY(3.14159), // Inverser horizontalement
              child: Image.asset(
                'lib/assets/images/mascotte.png', // Assurez-vous d'avoir le fichier image dans le dossier assets
                width: 100,
                height: 100,
              ),
            ),
          Spacer(), // Ajout d'un Spacer pour centrer le texte
          SizedBox(width: 24), // Espace pour équilibrer l'icône de menu
        ],
      ),
    );
  }
}
