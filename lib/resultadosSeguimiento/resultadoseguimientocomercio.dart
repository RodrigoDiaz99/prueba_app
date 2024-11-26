import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:insejupy_multiplatform/detalleseguimiento/detalleseguimiento.dart';
import 'package:insejupy_multiplatform/constants.dart';

import '../seguimiento.dart';

class ResultadosSeguimientoComercio extends StatelessWidget {
  final String informacion;
  final String iIDSolicitud;
  final int iIDAnioFiscal;

  const ResultadosSeguimientoComercio({
    Key? key,
    required this.informacion,
    required this.iIDSolicitud,
    required this.iIDAnioFiscal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(informacion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Seguimiento'),
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back), // Cambia el icono según tus preferencias
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Seguimiento(),
                ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                title: Center(
                  child: Text(
                    'RESULTADO DEL SEGUIMIENTO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(194, 153, 92, 1.0),
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    'TRAMITES DE SOLICITUD: $iIDSolicitud - $iIDAnioFiscal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(0, 0, 5, 1.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: resultados.length,
              itemBuilder: (context, index) {
                final resultado = resultados[index];
                if (kDebugMode) {
                  print(resultado);
                }
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Trámite: ${resultado['cOperacion']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Folio Civil: ${resultado['iFolioCivil']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Etapa: ${resultado['cEstatus']}',
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
                              onPressed: () {
                                obtenerDetallesDeAPI(
                                  context,
                                  resultado['iIDSolicitud'].toString(),
                                  iIDAnioFiscal,
                                  resultado['iIDDetalle'].toString(),
                                  resultado['cHoraSolicitud'].toString(),
                                );
                              },
                              icon: const Icon(Icons.info),
                              label: const Text('Seguimiento')),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> obtenerDetallesDeAPI(
    BuildContext context,
    String iIDSolicitud,
    int iIDAnioFiscal,
    String iIDDetalle,
    String cHoraSolicitud,
  ) async {
    try {
      int solicitud = int.parse(iIDSolicitud);
      int detalle = int.parse(iIDDetalle);
      String apiUrl = '$baseUrl/comercio/lineaTiempo';
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'iIDSolicitud': solicitud.toString(),
          'iIDAnioFiscal': iIDAnioFiscal.toString(),
          'iIDDetalle': detalle.toString(),
          'cHoraSolicitud': cHoraSolicitud,
        },
      );

      if (response.statusCode == 200) {
        var data = response.body;
        // No es necesario comprobar si context es nulo, siempre será proporcionado en este punto.
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesSeguimiento(detalles: data),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Error de la API - Código de estado: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al convertir los parámetros a enteros: $e');
      }
    }
  }
}
