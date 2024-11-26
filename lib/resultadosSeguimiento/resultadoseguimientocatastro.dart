import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:insejupy_multiplatform/detalleseguimiento/detalleseguimientocatastro.dart';
import 'package:insejupy_multiplatform/constants.dart';

import '../seguimiento.dart';

class ResultadosSeguimientoCatastro extends StatelessWidget {
  final String informacion;
  final String iIDSolicitud;
  final int iIDAnioFiscal;

  const ResultadosSeguimientoCatastro({
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Seguimiento(),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: resultados.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
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
            );
          } else if (index == 1) {
            return Card(
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
            );
          } else {
            final resultado = resultados[index - 2];

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
                          'Folio Electrónico: ${resultado['iIDPredio']}',
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
                        Text(
                          'Motivo: ${resultado['cMotivo']}',
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
                            resultado['iIDSolicitud'],
                            iIDAnioFiscal,
                            resultado['iIDDetalle'],
                          );
                        },
                        icon: const Icon(Icons.info),
                        label: const Text('Seguimiento'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> obtenerDetallesDeAPI(
    BuildContext context,
    String iIDSolicitud,
    int iIDAnioFiscal,
    int iIDDetalle,
  ) async {
    try {
      int solicitud = int.parse(iIDSolicitud);
      String apiUrl = '$baseUrl/catastro/lineaTiempo';
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'iIDSolicitud': solicitud.toString(),
          'iIDAnioFiscal': iIDAnioFiscal.toString(),
          'iIDDetalle': iIDDetalle.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = response.body;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesSeguimientoCatastro(detalles: data),
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
