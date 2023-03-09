// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniprojeto/app_container.dart';

import 'package:miniprojeto/main.dart';
import 'package:miniprojeto/pages/detalhes.dart';
import 'package:miniprojeto/pages/home.dart';
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

  group('Dashboard', () {
    testWidgets('displays dashboard when created', (WidgetTester tester) async {
      // build the widget
      HttpOverrides.global = MyHttpOverrides();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => AvaliacaoProvider(),
          child: MaterialApp(
            home: AppContainer(),
          ),
        ),
      );

      // expect to see the title and back button
      expect(find.text('Sistemas de Informação na Nuvem'), findsOneWidget);

      //gotta have a list with at least two items
      expect(find.byType(ListTile), findsNWidgets(2));
    });
  });

  //test the method _share in the Detalhes class for index 0
  group('Share', () {
    testWidgets('share the details of the evaluation', (WidgetTester tester) async {
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

      // tap the share button
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();

      // expect to see the share button
      expect(find.byIcon(Icons.share), findsOneWidget);

      // expect to see the difficulty of the evaluation
      expect(find.text('Projeto difícil'), findsOneWidget);

      // expect to see the notes of the evaluation
      expect(find.text('Projeto de grupo'), findsOneWidget);

      // expect to see the date and time of the evaluation
      expect(find.text('Realizada a 11 de fevereiro de 2023 às 10:10'), findsOneWidget);

      // expect to see the title and back button
      expect(find.text('Detalhes da avaliação'), findsOneWidget);
    });
  });

  //test the method _delete in the Detalhes class for index 2
  group('Delete', () {
    testWidgets('delete the details of the evaluation', (WidgetTester tester) async {
      // build the widget
      HttpOverrides.global = MyHttpOverrides();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => AvaliacaoProvider(),
          child: MaterialApp(
            home: Detalhes(
              index: 2,
            ),
          ),
        ),
      );

      // expect to see the title and back button
      expect(find.text('Detalhes da avaliação'), findsOneWidget);

      // expect to see the delete button
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // expect that we are not editing
      expect(find.byType(DetalhesEdit), findsNothing);
      expect(find.byType(DetalhesView), findsOneWidget);

      // tap the delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // confirm dialog
      expect(find.text('Não'), findsOneWidget);
      expect(find.text('Sim'), findsOneWidget);

      // tap the yes button
      await tester.tap(find.text('Sim'));
      await tester.pump();
    });
  });
}
