import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetallesSeguimientoCatastro extends StatelessWidget {
  final String detalles;

  const DetallesSeguimientoCatastro({Key? key, required this.detalles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decodificamos los detalles del JSON
    final List<dynamic> datos = json.decode(detalles);

    // Mapear los valores de 'cIcono' a los iconos en Flutter
    Map<String, IconData> iconos = {
      'far fa-edit': Icons.edit,
      'fas fa-check-square': Icons.check_box,
      'fas fa-circle-notch': Icons.circle,
      'fas fa-exclamation-triangle': Icons.warning,
      'fas fa-receipt': Icons.receipt,
      'far fa-folder-open': Icons.folder_open,
      'fas fa-file-invoice-dollar': Icons.payment,
      'fas fa-file-signature': MdiIcons.signature
      // Puedes agregar más iconos según tus necesidades
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Seguimiento'),
      ),
      body: ListView.builder(
        itemCount: datos.length,
        itemBuilder: (context, index) {
          final dato = datos[index];
          // var timelineClass = index % 2 == 0 ? "timeline-inverted" : "";

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dato['cTema'] == 'success'
                          ? Colors.green
                          : dato['cTema'] == 'primary'
                              ? Colors.blue
                              : Colors.yellow,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      iconos[dato['cIcono']] ??
                          Icons
                              .error_outline, // Icono por defecto en caso de que no se encuentre el icono en el mapa
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Etapa: ${dato['cEtapa']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${dato['cLeyenda']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${dato['cDescripcion']}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
