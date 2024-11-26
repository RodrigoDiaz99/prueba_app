// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/alerts.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import 'resultadoavaluo.dart';
import 'resultadoavaluoPdf.dart';

void main() => runApp(const Avaluoqr());

class Avaluoqr extends StatefulWidget {
  const Avaluoqr({Key? key}) : super(key: key);

  @override
  State<Avaluoqr> createState() => _AvaluoqrState();

}

class _AvaluoqrState extends State<Avaluoqr> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = true; // Variable para controlar el escaneo
  bool isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      isCameraPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraPermissionGranted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('QR Avaluo'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Avaluo'),
      ),
    );
  }


  Future<Map<String, dynamic>> fetchDataFromApi(String apiUrl) async {
    try {
      final response = await http.post(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        mostrarError('Error al cargar datos de la API', context);
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      mostrarError('Error al cargar datos de la API', context);
      throw Exception('Failed to load data from API');
    }
  }

Future<void> startScanning() async {
  setState(() {
    isScanning = true;
  });
  scanBarcode();
}


  Future<void> scanBarcode() async {

  RegExp urlPattern = RegExp(
      r'^https://sistemaavaluos.insejupy.gob.mx/api/AVALUO/VerDocumento/\d+$');
  
  RegExp urlPattern1 = RegExp(
      r'^http://192.168.126.52/api/AVALUO/VerDocumento/\d+$');
  
  RegExp urlPattern2 = RegExp(
      r'^https://sistemaavaluos\.insejupy\.gob\.mx/api/Valuador/VerDocumento/[A-Za-z0-9]+$');

  final result = await BarcodeScanner.scan();

if (result.type == ResultType.Barcode) {
  final barcodeScanRes = result.rawContent;
  if (barcodeScanRes.isEmpty != true &&
  urlPattern.hasMatch(barcodeScanRes) ||
  barcodeScanRes.isEmpty != true && 
  urlPattern1.hasMatch(barcodeScanRes)) {

    showDialog(
      context: context,
      barrierDismissible:false, // No se puede cerrar tocando fuera del dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Cargando..."),
          content: CircularProgressIndicator(), // Indicador de carga
        );
      },
    );
    //print('Resultado del escaneo: $barcodeScanRes');

    String apiUrl = '$baseUrlDoc/getBoletaAvaluo?datax=$barcodeScanRes';

    // Llamar a tu función para procesar el resultado
    try {
      Map<String, dynamic> apiData = await fetchDataFromApi(apiUrl);
      Navigator.of(context, rootNavigator: true).pop(); // Cerrar el dialog de carga
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoAvaluo(apiData: apiData),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Cerrar el dialog de carga
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("No se pudo obtener la información."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context); // Cerrar el dialog de error    
                   startScanning();                
                },
              ),
            ],
          );
        },
      );
    }
  } else if (barcodeScanRes.isEmpty != true &&
  urlPattern2.hasMatch(barcodeScanRes)){
    showDialog(
      context: context,
      barrierDismissible:
          false, // No se puede cerrar tocando fuera del dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Cargando..."),
          content: CircularProgressIndicator(), // Indicador de carga
        );
      },
    );
  if (result.type == ResultType.Barcode) {
    final barcodeScanRes = result.rawContent;
    // El escaneo fue exitoso, barcodeScanRes contiene el resultado
    //print('Resultado del escaneo: $barcodeScanRes');

    String apiUrl = barcodeScanRes;

    try {
      Navigator.of(context, rootNavigator: true).pop(); // Cerrar el dialog de carga
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoAvaluoPdf(pdf: apiUrl),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Cerrar el dialog de carga
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("No se pudo obtener la información."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context); // Cerrar el dialog de error    
                   startScanning();                 
                },
              ),
            ],
          );
        },
      );
    }
  } else {
    // El usuario canceló el escaneo o hubo un error
    Navigator.of(context, rootNavigator: true).pop(); // Cerrar el dialog de carga
    cancelado("Cancelado", context);
  }

  }else{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Por favor, verifica que sea un QR de Avalúos"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo de error
                startScanning();
              },
            ),
          ],
        );
      }
    );
  }
  } else {
    Navigator.of(context, rootNavigator: true).pop(); // Cerrar el dialog de carga
    cancelado("Cancelado", context);
  }
}

}