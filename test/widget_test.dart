// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:miniprojeto/main.dart';
import 'package:miniprojeto/pages/detalhes.dart';
import 'package:miniprojeto/providers/avaliacao_provider.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  group('Detalhes', () {
    testWidgets('displays details when created', (WidgetTester tester) async {
      // build the widget
      HttpOverrides.global = MyHttpOverrides();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => AvaliacaoProvider(),
          child: MaterialApp(
            home: Detalhes(
              index: 0,
            ),
          ),
        ),
      );

      // expect to see the title and back button
      expect(find.text('Detalhes da avaliação'), findsOneWidget);

      // expect to see the date and time of the evaluation
      expect(find.text('Realizada a 11 de fevereiro de 2023 às 10:10'), findsOneWidget);

      // expect to see the difficulty of the evaluation
      expect(find.text('Projeto difícil'), findsOneWidget);

      // expect to see the notes of the evaluation
      expect(find.text('Projeto de grupo'), findsOneWidget);

      // expect to not see the delete button
      expect(find.byIcon(Icons.delete), findsNothing);

      // expect that we are not editing
      expect(find.byType(DetalhesEdit), findsNothing);
      expect(find.byType(DetalhesView), findsOneWidget);
    });
  });
}
