import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Action à effectuer lorsque le bouton est pressé
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
    );
  }
}
