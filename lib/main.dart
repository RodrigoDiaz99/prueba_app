import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  //  await Preferences.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INSEJUPY',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium:
              TextStyle(fontFamily: 'EpicaPro'), // Define la fuente por defecto
        ),
        primaryColor: Color.fromRGBO(142, 44, 72, 1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(142, 44, 72, 1), // Your desired color
          titleTextStyle: TextStyle(
            color: Colors.white, // Color del texto
            fontSize: 20, // Tamaño de la fuente
          ),
          iconTheme: IconThemeData(
            // Define el color de los iconos del menú
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            // Define el color de los iconos de acciones
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          // Tema para ElevatedButton
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromRGBO(142, 44, 72, 1), // Cambia el color de fondo aquí
            foregroundColor:
                Colors.white, // Cambia el color del texto y del icono
            textStyle: const TextStyle(
              fontFamily: 'EpicaPro',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),

      initialRoute: 'splash', // Ruta inicial
      routes: {
        'splash': (context) =>
            const SplashScreen(), // Ruta para la pantalla splash
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
