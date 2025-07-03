import 'package:flutter/material.dart';
import 'package:arianne/src/widgets/components/bars/navBarWidget/navBarWidget.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Center(
        child: Text('Page des paramètres'),
      ),
    );
  }
}