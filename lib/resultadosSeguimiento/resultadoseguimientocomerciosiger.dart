import 'package:flutter/material.dart';
import 'dart:convert';

import '../seguimiento.dart';

class ResultadoSeguimientoComercioSiger extends StatelessWidget {
  final String informacion;
  final String cActa;
  final String dtFechaActa;

  const ResultadoSeguimientoComercioSiger({
    Key? key,
    required this.informacion,
    required this.cActa,
    required this.dtFechaActa,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(informacion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Seguimiento SIGER'),
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
      body: ListView(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const ListTile(
              title: Center(
                child: Text(
                  'RESULTADO DEL SEGUIMIENTO SIGER',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(194, 153, 92, 1.0)),
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
                  'TRÁMITES DE SOLICITUD: $cActa - $dtFechaActa',
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
            physics:
                const NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento
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
                      title: Text('Operación: ${resultado['cOperacion']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Etapa: ${resultado['cEstatus']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Fecha Ingreso: ${resultado['dtFechaIngresoRPC']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
