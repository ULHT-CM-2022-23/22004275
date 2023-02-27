import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:miniprojeto/pages/avaliacoes.dart';
import 'package:miniprojeto/pages/create_avaliacao.dart';

import 'pages/home.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int index = 0;

  void _navigate(int index) {
    setState(() {
      this.index = index;
    });
  }

  Widget _widget() {
    switch (index) {
      case 1:
        return Avaliacoes();
      case 2:
        return CreateAvaliacao();
      default:
        return Home();
    }
  }

  String _title() {
    switch (index) {
      case 1:
        return 'Listagem de Avaliações';
      case 2:
        return 'Registo de Avaliação';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title()),
      ),
      // make the body scrollable
      body: _widget(),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.add, size: 30, color: Colors.white),
        ],
        color: Colors.purple.shade400,
        buttonBackgroundColor: Colors.purple.shade400,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (int index) => _navigate(index),
      ),
    );
  }
}
