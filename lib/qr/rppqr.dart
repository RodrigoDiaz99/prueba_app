// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/qr/resultadorppPdf.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

import '../alerts.dart';
import '../constants.dart';
import 'resultadorpp.dart';

void main() => runApp(const Rppqr());

class Rppqr extends StatefulWidget {
  const Rppqr({Key? key}) : super(key: key);

  @override
  State<Rppqr> createState() => _RppqrState();
}

class _RppqrState extends State<Rppqr> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = true; // Variable para controlar el escaneo
  bool isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        isCameraPermissionGranted = true;
      });
      // Inicia el escaneo una vez que se otorga el permiso
      startScanning();
    } else {
      setState(() {
        isCameraPermissionGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('isCameraPermissionGranted: $isCameraPermissionGranted');
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR RPP'),
      ),
    );
  }

  Future<void> startScanning() async {
    setState(() {
      isScanning = true;
    });
    scanBarcode();
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

  Future<void> scanBarcode() async {
    RegExp formato1 = RegExp(
        r'^[A-Z]\d{1,6}-\d{4}-\d{1}\s[A-Z]\d{1,7}-\d{2}$'); // formato: S00000-2023-0 P000000-00
    RegExp formato2 = RegExp(r'^\d{5}-\d{1}-\d{4}-\d+$'); //25574-0-2019-542836
    RegExp formatoUrl = RegExp(
        r'^https:\/\/[a-zA-Z0-9.-]+\/api\/RPPMNC\/visorBoleta\/[A-Z]+\/\d+$'); //https://ancj.insejupy.gob.mx/api/RPPMNC/visorBoleta/INS/13949
    // final result = await BarcodeScanner.scan();
    final result =
        await BarcodeScanner.scan().timeout(const Duration(seconds: 30));

    if (result.type == ResultType.Barcode) {
      final barcodeScanRes = result.rawContent;
      if (kDebugMode) {
        print('here');
        print(barcodeScanRes);
      }

      if (barcodeScanRes.isEmpty != true && formato1.hasMatch(barcodeScanRes) ||
          barcodeScanRes.isEmpty != true && formato2.hasMatch(barcodeScanRes) ||
          barcodeScanRes.isEmpty != true &&
              formatoUrl.hasMatch(barcodeScanRes)) {
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

        String apiUrl = '$baseUrlDoc/getBoletaGeneral?datax=$barcodeScanRes';
        if (kDebugMode) {
          print(apiUrl);
        }
        // Llamar a tu función para procesar el resultado
        try {
          Map<String, dynamic> apiData = await fetchDataFromApi(apiUrl);
          if (kDebugMode) {
            print(apiData);
          }
          Navigator.of(context, rootNavigator: true)
              .pop(); // Cerrar el dialog de carga

          bool lSuccess = apiData['lSuccess'] == true;
          bool cUrlDocumentoNotZero = apiData['cURL'] != 0;
          bool allOtherValuesAreZero = true;
          apiData.forEach((key, value) {
            if (key != 'lSuccess' &&
                key != 'cURL' &&
                key != 'iError' &&
                value != 0) {
              allOtherValuesAreZero = false;
            }
          });
          if (lSuccess && cUrlDocumentoNotZero && allOtherValuesAreZero) {
            if (kDebugMode) {
              print('entro');
            }
            String pdfUrl = apiData['cURL'];
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadoRppPdf(pdf: pdfUrl),
              ),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadoRpp(apiData: apiData),
              ),
            );
          }
        } catch (e) {
          Navigator.of(context, rootNavigator: true)
              .pop(); // Cerrar el dialog de carga
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
                      // startScanning();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Rppqr(),
                          ));
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text("Por favor, verifica que sea un QR de RPP"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el diálogo de error
                      // startScanning();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Rppqr(),
                          ));
                    },
                  ),
                ],
              );
            });
      }
    } else {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Cerrar el dialog de carga
      cancelado("Cancelado", context);
    }
  }
}
