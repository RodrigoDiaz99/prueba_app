import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/qr/catastroqr.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ResultadoCatastroPdf extends StatefulWidget {
  final String pdf;

  const ResultadoCatastroPdf({super.key, required this.pdf});

  @override
  State<ResultadoCatastroPdf> createState() => _ResultadoCatastroPdfState();

}

class _ResultadoCatastroPdfState extends State<ResultadoCatastroPdf> {
  bool _pdfLoaded = false;
  String _pdfPath = '';

  Future<void> _loadPDF() async {
    String url = widget.pdf;
    String filename = url.split('/').last;

    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);

    setState(() {
      _pdfPath = file.path;
      _pdfLoaded = true;
    });
  }

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
              // child: ListTile(
              //   title: Center(
              //     child: Text(
              //       'TRAMITES DE SOLICITUD: ${widget.apiData['iIDSolicitud']} - ${widget.apiData['iIDAnioFiscal']}',
              //       style: const TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 20,
              //         color: Color.fromRGBO(110, 121, 159, 1.0),
              //       ),
              //     ),
              //   ),
              // ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await _loadPDF();
                        } catch (error) {
                          if (kDebugMode) {
                            print('Error al cargar el PDF: $error');
                          }
                        }
                      },
                      icon: const Icon(Icons.edit_document),
                      label: const Text('Ver pdf', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  if (_pdfLoaded)
                    SizedBox(
                      height: 500, // Ajusta la altura según tus necesidades
                      child: PDFView(
                        filePath: _pdfPath,
                        // Habilita el zoom más libre para el PDF
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: true,
                        pageFling: true,
                        pageSnap: true,
                        defaultPage: 0,
                        fitPolicy: FitPolicy.BOTH,
                      ),
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
