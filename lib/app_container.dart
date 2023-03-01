import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:miniprojeto/pages/avaliacoes.dart';
import 'package:miniprojeto/pages/create_avaliacao.dart';
import 'package:miniprojeto/providers/avaliacao_provider.dart';
import 'package:provider/provider.dart';

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
    final avaliacoes = Provider.of<AvaliacaoProvider>(context).avaliacoes;

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle()),
      ),
      body: _buildPage(),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          const Icon(Icons.home, size: 30, color: Colors.white),
          // List icon with number of avaliacoes
          Stack(
            children: [
              const Icon(Icons.list, size: 30, color: Colors.white),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    avaliacoes.length.toString(),
                    style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const Icon(Icons.add, size: 30, color: Colors.white),
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
