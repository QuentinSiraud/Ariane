import 'package:flutter/material.dart';

class GeometirePage extends StatelessWidget {
  const GeometirePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Géométrie'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans le jeu de la géométrie !',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}