import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';



class Resultadobusquedatomocomercio extends StatelessWidget {
  final String informacion;
  const Resultadobusquedatomocomercio({
    Key? key,
    required this.informacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> resultados = json.decode(informacion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Seguimiento'),
      ),
      body: ListView.builder(
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
                  title: Text('Libro: ${resultado['cLibro']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tomo y Letra: ${resultado['cTomoLetra']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Volumen: ${resultado['cVolumen']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Tipo Predio: ${resultado['cTipoPredio']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${resultado['cLibro']}',
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
                        String url = '${resultado['cImagenURL']}';
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
