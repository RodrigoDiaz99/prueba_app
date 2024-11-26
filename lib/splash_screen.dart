// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'webview.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndNavigate();
  }

  Future<void> checkAndNavigate() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión a Internet, puedes mostrar un mensaje o realizar una acción adecuada.
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Sin conexión a Internet'),
          content: const Text(
              'Por favor, verifica tu conexión a Internet y vuelve a intentarlo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Intente nuevamente después de un breve retraso.
                Future.delayed(const Duration(seconds: 5), () {
                  checkAndNavigate();
                });
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } else {
      // Hay conexión a Internet, puedes continuar con la navegación.
      var duration = const Duration(seconds: 4);
      Future.delayed(duration, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WebViewApp()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(
              255, 255, 255, 1), // Cambia esto al color que desees
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                width: 300, // Ancho
                height: 450, // Alto
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(height: 20),
              const ListTile(
                titleTextStyle:
                    TextStyle(color: Color.fromRGBO(142, 44, 72, 1)),
                title: Text(
                  "Consultas INSEJUPY",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'EpicaPro',
                    fontWeight: FontWeight.bold, // Para negrita
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Color.fromRGBO(142, 44, 72, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
