import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/privacidad/Privacidad.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PrivacidadPdf extends StatefulWidget {
  final String pdf;

  const PrivacidadPdf({Key? key, required this.pdf}) : super(key: key);

  @override
  State<PrivacidadPdf> createState() => _PrivacidadPdfState();
}

class _PrivacidadPdfState extends State<PrivacidadPdf> {
  bool _pdfLoaded = false;
  String _pdfPath = '';

  @override
  void initState() {
    super.initState();
    _loadPDF(); // Carga el PDF automáticamente al iniciar la pantalla
  }

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
        title: const Text('Politicas INSEJUPY'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Cambia el icono según tus preferencias
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Privacidad(),
              ),
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
                    'POLITICAS DE PRIVACIDAD',
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
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
