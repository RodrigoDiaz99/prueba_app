import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';



class Historialfce extends StatelessWidget {
  final String historial;

  const Historialfce({
    Key? key,
    required this.historial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> datos = json.decode(historial);

    List<Widget> historialWidgets = [];
    if (datos is List) {
      if (datos.isEmpty) {
        historialWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text('Búsqueda sin resultados '),
              ],
            ),
          ),
        );
      } else {
        for (var dato in datos) {
          if (dato['cTipo'] == 'H' && dato['cTipo'] == 'S') {
            String cOperacion = dato['cOperacion'] ?? '';
            String cLibro = dato['cLibro'] ?? '';
            String cTomoLetra = dato['cTomoLetra'];
            String cVolumen = dato['cVolumen'];
            String cTipoPredio = dato['cTipoPredio'];
            String cSistema = dato['cSistema'];
            String iFolio = dato['iFolio'] ?? '';
            String cImagenURL = dato['cImagenURL'];

            var operacion = ListTile(
              title: Text('Operacion: $cOperacion'),
            );

            var folio = ListTile(
              title: Text('Folio: $iFolio'),
            );

            var referencia = ListTile(
              title: const Text('Referencia:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Libro: $cLibro',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tomo y letra: $cTomoLetra',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Volumen: $cVolumen',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tipo libro: $cTipoPredio',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sistema: $cSistema',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
            var verTomoButton = Container(
              margin: const EdgeInsets.only(top: 8.0),
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                 onPressed: () async {
                  String url = cImagenURL;
                _launch(url);
                },
                icon: const Icon(Icons.search),
                label: const Text('Ver tomo', style: TextStyle(fontSize: 10)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            );

            historialWidgets.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    operacion,
                    referencia,
                    folio,
                    verTomoButton,
                  ],
                ),
              ),
            );
            //Tipo S
            String cOperacionS = dato['cOperacion'] ?? '';
            String cReferencia = dato['cReferencia'] ?? '';
            int iFolioS = dato['iFolio'] ?? '';

            var operacionS = ListTile(
              title: Text('Operacion: $cOperacionS'),
            );

            var folioS = ListTile(
              title: Text('Folio: $iFolioS'),
            );

            var referenciaS = ListTile(
              title: const Text('Referencia:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cReferencia,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );


            historialWidgets.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    operacionS,
                    referenciaS,
                    folioS,
                  ],
                ),
              ),
            );

          } else if (dato['cTipo'] == 'H') {
            String cOperacion = dato['cOperacion'] ?? '';
            String cLibro = dato['cLibro'] ?? '';
            String cTomoLetra = dato['cTomoLetra'];
            String cVolumen = dato['cVolumen'];
            String cTipoPredio = dato['cTipoPredio'];
            String cSistema = dato['cSistema'];
            String iFolio = dato['iFolio'] ?? '';
            String cImagenURL = dato['cImagenURL'];

            var operacion = ListTile(
              title: Text('Operacion: $cOperacion'),
            );

            var folio = ListTile(
              title: Text('Folio: $iFolio'),
            );

            var referencia = ListTile(
              title: const Text('Referencia:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Libro: $cLibro',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tomo y letra: $cTomoLetra',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Volumen: $cVolumen',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tipo libro: $cTipoPredio',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sistema: $cSistema',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
            var verTomoButton = Container(
              margin: const EdgeInsets.only(top: 8.0),
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                 onPressed: () async {
                  String url = cImagenURL;
                  _launch(url);
                },
                icon: const Icon(Icons.search),
                label: const Text('Ver tomo', style: TextStyle(fontSize: 10)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            );

            historialWidgets.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    operacion,
                    referencia,
                    folio,
                    verTomoButton,
                  ],
                ),
              ),
            );
          }else if(dato['cTipo'] == 'S'){
            String cOperacion = dato['cOperacion'] ?? '';
            String cReferencia = dato['cReferencia'] ?? '';
            int iFolio = dato['iFolio'] ?? '';

            var operacionS = ListTile(
              title: Text('Operacion: $cOperacion'),
            );

            var folioS = ListTile(
              title: Text('Folio: $iFolio'),
            );

            var referenciaS = ListTile(
              title: const Text('Referencia:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cReferencia,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );


            historialWidgets.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    operacionS,
                    referenciaS,
                    folioS,
                  ],
                ),
              ),
            );
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial del folio civil'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: historialWidgets,
          ),
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
