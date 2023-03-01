import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:miniprojeto/providers/avaliacao_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'app_container.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // para poder carregar imagens de https sem certificado
  runApp(ChangeNotifierProvider(
    create: (context) => AvaliacaoProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'iQueChumbei',
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.purple,
            snackBarTheme: const SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
              )
            )
        ),
        home: AnimatedSplashScreen(
            duration: 1000,
            splash: 'lib/assets/images/logo.png',
            splashIconSize: 400,
            nextScreen: AppContainer(),
            animationDuration: const Duration(milliseconds: 1000),
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.theme,
            backgroundColor: Colors.purple.shade50
        )
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}