import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/foliocivilcomercio/historialfce.dart';
import '../constants.dart';
import '../alerts.dart';

class Resultadobusquedafce extends StatefulWidget {
  final String informacion;

  const Resultadobusquedafce({Key? key, required this.informacion})
      : super(key: key);

  @override
  State<Resultadobusquedafce> createState() => _Resultadobusquedafce();

}

class _Resultadobusquedafce extends State<Resultadobusquedafce> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(widget.informacion);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del folio civil'),
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
                  title: Text(
                      'Folio Civil Electronico: ${resultado['iIDFolioMercantil']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre comercial: ${resultado['cRazonSocial']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Capital social: ${resultado['dCapitalSocial']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Fecha de inscripción: ${resultado['dtFechaInscripcion']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Municipio: ${resultado['cMunicipio']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await historialfoliocivil(
                            resultado['iIDFolioMercantil'].toString(),
                            context);
                      },
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Historial')             
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> historialfoliocivil(String folioM, BuildContext context) async {
    bool success = false;
    mostrarAlertDialog(context, 'Buscando información...');
    try {
      String apiUrl = '$apiBaseUrl/api/getHistorialFolioCivilComercio';
      int iIDFolioMercantil = int.parse(folioM);    
      var response = await http.post(Uri.parse(apiUrl), body: {
        'iIDFolioMercantil': iIDFolioMercantil.toString(),
      });

      if ((response.statusCode >= 200 && response.statusCode < 300)) {
        success = true;

        var data = response.body;

        if (data == 'No se encontró historial.') {
          data = '[]';
        }
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Historialfce(historial: data),
          ),
        );
      }
    } catch (e) {
      mostrarError('Error en la solicitud HTTP', context);
    }

    if (!success) {
      mostrarError('Error en la solicitud HTTP', context);
    }
  }
}
