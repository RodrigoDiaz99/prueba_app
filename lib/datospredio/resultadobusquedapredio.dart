import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/alerts.dart';
import 'package:insejupy_multiplatform/datospredio/detallepredio.dart';
import '../constants.dart';

class Resultadobusquedapredio extends StatefulWidget {
  final String informacion;

  const Resultadobusquedapredio({
    Key? key,
    required this.informacion,
  }) : super(key: key);

  @override
  State<Resultadobusquedapredio> createState() => _ResultadobusquedapredioState();

}

class _ResultadobusquedapredioState extends State<Resultadobusquedapredio> {
   @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(widget.informacion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del predio'),
      ),
      body: ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final resultado = resultados[index];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Folio E: ${resultado['iIDPredio']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomenclatura: ${resultado['cNomenclatura']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ubicación: ${resultado['cColonia']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Sección: ${resultado['cSeccion']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Manzana: ${resultado['cManzana']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Municipio: ${resultado['cMunicipio']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () async {
                        await detallesPredio(
                            resultado['iIDPredio'].toString(), context);
                      },
                        icon: const Icon(Icons.info),
                        label: const Text('Detalles')             
                      ),
                    // IconButton(
                    // onPressed: () async {
                    //   await detallesInscripciones(
                    //       resultado['iIDPredio'].toString(), context);
                    // },
                    //   icon: const Icon(Icons.info),
                    //   color: Colors.blue,
                    // ),
                    // const SizedBox(width: 5),
                    // const Text(
                    //   'Detalles',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.blue,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Future<void> detallesPredio(
      String predio, BuildContext context) async {
    bool success =
        false; // Bandera para indicar si al menos una de las API funcionó
    _showAlertDialog(context);

    try {
      String apiUrl = '$apiBaseUrl/api/getInscripcionPredio';
      String apiUrlC = '$apiBaseUrl/api/getCedulaPredio';
      String apiUrlN = '$apiBaseUrl/api/getNomenclaturaPredio';
      int idpredio = int.parse(predio);
      int municipio = 1;

      var response = await http.post(Uri.parse(apiUrl), body: {
        'iIDPredio': idpredio.toString(),
      });

      var response2 = await http.post(Uri.parse(apiUrlC), body: {
        'iIDPredio': idpredio.toString(),
        'cMunicipio': municipio.toString(),
      });

      var response3 = await http.post(Uri.parse(apiUrlN), body: {
        'iIDPredio': idpredio.toString(),
      });

      // Validar las respuestas de las API mediante el statusCode
      if ((response.statusCode >= 200 && response.statusCode < 300) ||
          (response2.statusCode >= 200 && response2.statusCode < 300) ||
          (response3.statusCode >= 200 && response3.statusCode < 300)) {
        success = true; // Al menos una de las API funcionó

        var data = response.body;
        var data2 = response2.body;
        var data3 = response3.body;

        try {
          // Intenta decodificar data como un objeto JSON
          Map<String, dynamic> jsonData = jsonDecode(data);

          // Verifica si el objeto tiene las claves esperadas
          if (jsonData.containsKey("lSuccess") && jsonData.containsKey("cMensaje")) {
            data = '[]'; // Cambia el valor de data a una lista vacía
          }
        } catch (e) {
          if (kDebugMode) {
            print("Verifique el contenido de la API1");
          }
        }

        try {
          Map<String, dynamic> jsonData2 = jsonDecode(data2);

          if (jsonData2.containsKey("lSuccess") && jsonData2.containsKey("cMensaje")) {
            data2 = '[]';
          }
        } catch (e) {
          if (kDebugMode) {
            print("Verifique el contenido de la API2");
          }
        }
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detallepredio(
                detalles: data, detallesC: data2, detallesN: data3),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error en la solicitud HTTP', context);
    }

    if (!success) {
      // Mostrar un mensaje de error en un diálogo, una Snackbar, etc.
      // Ya no es necesario mostrar otro AlertDialog, simplemente muestra un mensaje de error dentro del AlertDialog existente.
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error en la solicitud HTTP', context);
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Buscando'),
          content: Text('Espere un momento, por favor'),
        );
      },
    );
  }
}
