import 'package:flutter/material.dart';
import 'package:arianne/src/widgets/pages/home_page.dart'; // Importation de HomePage

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView( // Ajout d'un SingleChildScrollView pour éviter le débordement
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'lib/assets/images/logo.png', // Assurez-vous d'avoir le fichier logo dans le dossier assets
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),

              // Titre
              const Text(
                'ARIANE',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // Images des pandas côte à côte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/mascotte.png', // Assurez-vous d'avoir le fichier image dans le dossier assets
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 20), // Espacement entre les deux images
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159), // Inverser horizontalement
                    child: Image.asset(
                      'lib/assets/images/mascotte2.png', // Assurez-vous d'avoir le fichier image dans le dossier assets
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Bouton Commencer
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white, // Couleur du texte
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Bords arrondis
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0), // Padding interne
                  side: BorderSide(color: Colors.black, width: 2.0), // Bordure
                ),
                child: const Text(
                  'COMMENCER',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
