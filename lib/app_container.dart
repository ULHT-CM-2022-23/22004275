import 'package:flutter/material.dart';
import 'package:miniprojeto/pages/avaliacoes.dart';
import 'package:miniprojeto/pages/create_avaliacao.dart';

import 'pages/home.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  _AppContainerState createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _currentIndex = 0;

  void _navigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 1:
        return Avaliacoes();
      case 2:
        return CreateAvaliacao();
      default:
        return Home();
    }
  }

  String _pageTitle() {
    switch (_currentIndex) {
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
        title: Text(_pageTitle()),
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigate,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listagem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Registo',
          ),
        ],
      ),
    );
  }
}
