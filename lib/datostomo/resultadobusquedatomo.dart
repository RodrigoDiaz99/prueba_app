import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class Resultadobusquedatomo extends StatelessWidget {
  final String informacion;
  const Resultadobusquedatomo({
    Key? key,
    required this.informacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(informacion);
    if (kDebugMode) {
      print("holamundo2");
      print(resultados);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Busqueda'),
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
                  title: Text('Tomo: ${resultado['cTomo']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Volumen: ${resultado['cVolumen']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tipo: ${resultado['cTipoPredio']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Letra: ${resultado['cLetraTomo']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Libro: ${resultado['cLibro']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${resultado['cSistema']}',
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
                        String url = '${resultado['cVisor']}';
                 _launch(url);
                      },
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Ver tomo')             
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
}
Future<void> _launch(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw "Cannot load Url $url";
  }
}
