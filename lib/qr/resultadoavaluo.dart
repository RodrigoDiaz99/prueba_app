import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/qr/avaluoqr.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class ResultadoAvaluo extends StatefulWidget {
  final Map<String, dynamic> apiData;

  const ResultadoAvaluo({super.key, required this.apiData});

  @override
  State<ResultadoAvaluo> createState() => _ResultadoAvaluoState();

}

class _ResultadoAvaluoState extends State<ResultadoAvaluo> {
  bool _pdfLoaded = false;
  String _pdfPath = '';

  Future<void> _loadPDF() async {
    String url = '${widget.apiData['cURL']}';
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
        title: const Text('Resultado Avaluo'),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Cambia el icono según tus preferencias
          onPressed: () {
            Navigator.push(
            context,
              MaterialPageRoute(
                builder: (context) => const Avaluoqr(),
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
                    'TRAMITES DE SOLICITUD: ${widget.apiData['iIDSolicitud']} - ${widget.apiData['iIDAnioFiscal']}',
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
