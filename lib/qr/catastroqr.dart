// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/qr/resultadocatasreoPdf.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

import '../alerts.dart';
import '../constants.dart';
import 'resultadocatastro.dart';

void main() => runApp(const Catastroqr());

class Catastroqr extends StatefulWidget {
  const Catastroqr({Key? key}) : super(key: key);

  @override
  State<Catastroqr> createState() => _CatastroqrState();
}

class _CatastroqrState extends State<Catastroqr>
    with SingleTickerProviderStateMixin {
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
          title: const Text('QR Catastro'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Catastro'),
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
    RegExp Pattern =
        RegExp(r'^(CERTIFICADA_VIG|NA|PRODIV|CEDULA|CNOPROP)\|\d+$');
    RegExp urlpattern = RegExp(
        r'^http:\/\/www\.insejupy\.gob\.mx:8040\/SGC\/API\/VistaPrecedula\?var_d=\w+$');

    final result =
        await BarcodeScanner.scan().timeout(const Duration(seconds: 30));

    if (result.type == ResultType.Barcode) {
      final barcodeScanRes = result.rawContent;
      if (kDebugMode) {
        print('here');
        print(barcodeScanRes);
      }

      if (barcodeScanRes.isEmpty != true && Pattern.hasMatch(barcodeScanRes) ||
          barcodeScanRes.isEmpty != true &&
              urlpattern.hasMatch(barcodeScanRes)) {
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

        String apiUrl = '$baseUrlDoc/getHojaCatastro?datax=$barcodeScanRes';

        // Llamar a tu función para procesar el resultado, como fetchDataFromApi
        try {
          Map<String, dynamic> apiData = await fetchDataFromApi(apiUrl);
          if (kDebugMode) {
            print('aqui');
            print(apiData);
          }

          Navigator.of(context, rootNavigator: true)
              .pop(); // Cerrar el dialog de carga

          bool lSuccess = apiData['lSuccess'] == true;
          bool cUrlDocumentoNotZero = apiData['cUrlDocumento'] != 0;

          bool allOtherValuesAreZero = true;

          apiData.forEach((key, value) {
            if (key != 'lSuccess' &&
                key != 'cUrlDocumento' &&
                key != 'iError' &&
                value != 0) {
              allOtherValuesAreZero = false;
            }
          });

          if (lSuccess && cUrlDocumentoNotZero && allOtherValuesAreZero) {
            if (kDebugMode) {
              print('entro');
            }
            String pdfUrl = apiData['cUrlDocumento'];
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadoCatastroPdf(pdf: pdfUrl),
              ),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadoCatastro(apiData: apiData),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Catastroqr(),
                          ));
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Cerrar el dialog de carga
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Aviso"),
              content: const Text("Verifica que sea un QR de catastro."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el dialog de error
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Catastroqr(),
                        ));
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Cerrar el dialog de carga
      cancelado("Cancelado", context);
    }
  }
}
