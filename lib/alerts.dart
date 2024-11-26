import 'package:flutter/material.dart';

import 'webview.dart';

void mostrarAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return WillPopScope(//Previene el cierre del dialog utilizando el boton regresar del telefono
        onWillPop: () async => false,
        child:  AlertDialog(
        title: const Text('Buscando...'),
        content: Text(message),
        ),
      );
    } 
  );
}

void cargandoDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Cargando...'),
      content: Text(message),
    ),
  );
}

  void errorUrl(String url, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('No se pudo abrir la URL: $url'),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarError(String message,  BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void cancelado(String message, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child:  AlertDialog(
            title: const Text("Cancelado"),
            content: const Text("Escaneo cancelado."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                Navigator.pop(context); // Cerrar el dialog de error    
                Navigator.pushAndRemoveUntil(
                 context,
                   MaterialPageRoute(
                     builder: (context) => const WebViewApp(),
                   ),
                   (route) => false,
                  );                 
                },
              ),
            ],
          ),
        );
      },
    );
  }
  