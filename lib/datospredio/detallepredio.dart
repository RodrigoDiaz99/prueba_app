import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class Detallepredio extends StatelessWidget {
  final String detalles;
  final String detallesC;
  final String detallesN;

  const Detallepredio({
    Key? key,
    required this.detalles,
    required this.detallesC,
    required this.detallesN,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> datos = json.decode(detallesC);
    final List<dynamic> datosIns = json.decode(detalles);
    final List<dynamic> datosN = json.decode(detallesN);

    List<Widget> cedulaWidgets = [];
    if (datos is List) {
      if (datos.isEmpty) {
        cedulaWidgets.add(
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
                Text('No hay cédulas disponibles'),
              ],
            ),
          ),
        );
      } else {
        for (var dato in datos) {
          String FOLIO_CEDULA = dato['FOLIO_CEDULA'];
          String FECHA_CEDULA = dato['FECHA_CEDULA'];
          String MOTIVO = dato['MOTIVO'];
          String estado = dato['ESTATUS'];
          String VALOR_CATASTRAL = dato['VALOR_CATASTRAL'];

          if (estado == "VIGENTE") {
            var listItem = ListTile(
              title: Text('Folio cédula: $FOLIO_CEDULA'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha: $FECHA_CEDULA',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Motivo expedicion: $MOTIVO',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Estado: $estado',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Valor catastral: $VALOR_CATASTRAL',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
            // Agregar los widgets a la lista con el diseño de rectángulo blanco
            cedulaWidgets.add(
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
                  children: [listItem],
                ),
              ),
            );
          }
        }
      }
    }

    List<Widget> inscripcionesWidgets = [];
    if (datosIns is List) {
      if (datosIns.isEmpty) {
        inscripcionesWidgets.add(
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
                Text('No hay inscripciones disponibles'),
              ],
            ),
          ),
        );
      } else {
        for (var datoI in datosIns) {
          String didInscripcion = datoI['didInscripcion'] ?? '';
          String dtFechaInscripcion = datoI['dtFechaInscripcion'] ?? '';
          String cOperacion = datoI['cOperacion'] ?? '';
          String cGestoria = datoI['cGestoria'] ?? '';
          String cGestor = datoI['cGestor'] ?? '';
          String cReferenciaLibro = datoI['cReferenciaLibro'] ?? '';
          String estado =
              datoI['lVigente'] == "TRUE " ? 'Vigente' : 'No vigente';
          String cRutaImagen = datoI['cRutaImagen'] ?? '';
          String cVisor = datoI['cVisor'] ?? '';
          String cVerPDF = datoI['cVerPDF'] ?? '';

          var listItem = ListTile(
            title: Text('Inscripción: $didInscripcion'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estado,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fecha: $dtFechaInscripcion',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Operación: $cOperacion',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Entidad otorgante: $cGestoria',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nombre otorgante: $cGestor',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Referencia: $cReferenciaLibro',
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
                String url = cVisor;
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

          var verPdfButton = Container(
            margin: const EdgeInsets.only(top: 8.0),
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () async {
                String url = cVerPDF;
             _launch(url);
              },
              icon: const Icon(Icons.search),
              label: const Text('Ver pdf', style: TextStyle(fontSize: 10)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          );

          // Agregar los widgets a la lista con el diseño de rectángulo blanco
          inscripcionesWidgets.add(
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
                  listItem,
                  if (cRutaImagen != "CERO/CERO/CERO/000M/CERO/AAA000AA000.tif")
                    verTomoButton,
                  if (didInscripcion != '0') verPdfButton,
                ],
              ),
            ),
          );
        }
      }
    }

    List<Widget> nomenclaturaWidgets = [];
    if (datosN is List) {
      if (datosN.isEmpty) {
        nomenclaturaWidgets.add(
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
                Text('No hay nomenclaturas disponibles'),
              ],
            ),
          ),
        );
      } else {
        for (var datoN in datosN) {
          String cTipo = datoN['cTipo'] ?? '';
          String cNomenclatura = datoN['cNomenclatura'] ?? '';
          String cTablaje = datoN['cTablaje'] ?? '';
          String cDepartamento = datoN['cDepartamento'] ?? '';
          String cEdificio = datoN['cEdificio'] ?? '';
          String cNivel = datoN['cNivel'] ?? '';
          String cCondominio = datoN['cCondominio'] ?? '';
          String cSeccion = datoN['cSeccion'] ?? '';
          String cManzana = datoN['cManzana'] ?? '';
          String cLote = datoN['cLote'] ?? '';

          if (cTipo == 'R') {
            // Si cTipo es igual a 'R', mostrar información en el rectángulo Registral
            nomenclaturaWidgets.add(
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
                    ListTile(
                      title: const Text('Registral'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nomenclatura: $cNomenclatura',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Tablaje: $cTablaje',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Departamento: $cDepartamento',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Edificio: $cEdificio',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Nivel: $cNivel',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Condominio: $cCondominio',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sección: $cSeccion',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manzana: $cManzana',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Lote: $cLote',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 8.0), // Espacio en blanco entre los rectángulos
                  ],
                ),
              ),
            );
          } else if (cTipo == 'C') {
            // Si cTipo es igual a 'C', mostrar información en el rectángulo Catastral
            nomenclaturaWidgets.add(
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
                    ListTile(
                      title: const Text('Catastral'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nomenclatura: $cNomenclatura',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Tablaje: $cTablaje',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Departamento: $cDepartamento',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Edificio: $cEdificio',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Nivel: $cNivel',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Condominio: $cCondominio',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sección: $cSeccion',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Manzana: $cManzana',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Lote: $cLote',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 8.0), // Espacio en blanco entre los rectángulos
                  ],
                ),
              ),
            );
          }
        }
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del predio'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cédula'),
              Tab(text: 'Inscripción'),
              Tab(text: 'Nomenclatura'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cedulaWidgets,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: inscripcionesWidgets,
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nomenclaturaWidgets,
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
