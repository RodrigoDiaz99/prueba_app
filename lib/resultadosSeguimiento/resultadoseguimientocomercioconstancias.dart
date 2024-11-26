import 'package:flutter/material.dart';
import 'dart:convert';

import '../seguimiento.dart';

class ResultadoSeguimientoComercioConstancias extends StatelessWidget {
  final String informacion;
  final String iIDSolicitud;
  final int iIDAnioFiscal;
  final String cTipo;

  const ResultadoSeguimientoComercioConstancias({
    Key? key,
    required this.informacion,
    required this.iIDSolicitud,
    required this.iIDAnioFiscal,
    required this.cTipo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(informacion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Seguimiento Constancias'),
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
                    'TRÁMITES DE SOLICITUD: $iIDSolicitud - $iIDAnioFiscal',
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
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Trámite: ${resultado['iIDDetalle']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipo: ${resultado['cTipo']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Etapa: ${resultado['cEstatus']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Operación: ${resultado['cOperacion']}',
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
      ),
    );
  }
}
