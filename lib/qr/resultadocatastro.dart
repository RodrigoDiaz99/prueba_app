
import 'package:flutter/material.dart';
import 'package:insejupy_multiplatform/qr/catastroqr.dart';
import 'package:url_launcher/url_launcher.dart';
class ResultadoCatastro extends StatelessWidget {
  final Map<String, dynamic> apiData;

  const ResultadoCatastro({super.key, required this.apiData});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado Catastro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Cambia el icono según tus preferencias
          onPressed: () {
            Navigator.push(
            context,
              MaterialPageRoute(
                builder: (context) => const Catastroqr(),
              )
            );   
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
                    'RESULTADO DEL ESCANEO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(105, 80, 147, 1.0),
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
                    'TRAMITES DE SOLICITUD: ${apiData['iIDSolicitud']} - ${apiData['iIDAnioFiscal']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(110, 121, 159, 1.0),
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Operación: ${apiData['cOperacion']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha de firma: ${apiData['cFechaFirma']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Cadena original: ${apiData['cCadenaOriginal']}'),
                  ),
                  ListTile(
                    title: Text('Cadena hash: ${apiData['cCadenaHash']}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          String url = '${apiData['cUrlDocumento']}';
                            _launch(url);
                          },
                          icon: const Icon(Icons.edit_document),
                          label: const Text('Ver pdf', style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

