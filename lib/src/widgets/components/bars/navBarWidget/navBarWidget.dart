import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:arianne/src/widgets/pages/home_page.dart';
import 'package:arianne/src/widgets/pages/settings_page.dart';
import 'package:arianne/src/widgets/pages/score_page.dart';

class NavBarWidget extends StatefulWidget {
  @override
  _NavBarWidgetState createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int _selectedIndex = 1;

  static final List<Widget> _widgetOptions = <Widget>[
    ScorePage(),   // NE PAS inclure NavBarWidget dans ScorePage
    HomePage(),    // NE PAS inclure NavBarWidget dans HomePage
    SettingsPage() // NE PAS inclure NavBarWidget dans SettingsPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Résultats',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gamepad),
            label: 'Jeux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}