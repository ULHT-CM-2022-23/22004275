import 'package:flutter/material.dart';
import 'package:miniprojeto/providers/avaliacao_provider.dart';
import 'package:provider/provider.dart';
import 'app_container.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AvaliacaoProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.purple
        ),
        home: AppContainer(),
    );
  }
}