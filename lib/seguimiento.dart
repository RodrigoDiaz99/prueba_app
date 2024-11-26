// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientocomerciocertificados.dart';
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientorpp.dart';
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientocomercio.dart';
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientocomerciosiger.dart';
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientocomercioconstancias.dart';
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientocatastro.dart';
import 'package:insejupy_multiplatform/resultadosSeguimiento/resultadoseguimientoavaluo.dart';

import 'dart:convert';
import 'constants.dart';
import 'package:insejupy_multiplatform/alerts.dart';
import 'package:intl/intl.dart';

import 'webview.dart';

class Seguimiento extends StatefulWidget {
  const Seguimiento({Key? key}) : super(key: key);

  @override
  _SeguimientoState createState() => _SeguimientoState();
}

class _SeguimientoState extends State<Seguimiento> {
  late int selectedYear;
  late int selectedDate;
  late List<int> years;
  late String selectedOption;
  late String selectedTipo;
  final solicitudController = TextEditingController();
  final anioFiscalController = TextEditingController();
  final cActaController = TextEditingController();
  final dtFechaActaController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showInputs = true;
  bool showComercioSigerInputs = false;
  bool showTipoDropdown = false;

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    selectedYear = DateTime.now().year;
    selectedDate = currentDate.year;
    selectedOption = 'Seleccionar';
    selectedTipo = 'Seleccionar';
    years = List.generate(10, (index) => selectedYear - 5 + index);
  }

  @override
  void dispose() {
    solicitudController.dispose();
    anioFiscalController.dispose();
    super.dispose();
  }

  Future<void> obtenerInformacionDeAPI() async {
    mostrarAlertDialog(context, 'Buscando información...');

    String apiUrl = '';
    String iIDSolicitud = '';
    int iIDAnioFiscal = 0;
    String cActa = '';
    String dtFechaActa = '';
    String cTipo = '';
    var response;

    if (selectedTipo != 'Seleccionar') {
      switch (selectedTipo) {
        case 'Mercantil':
          cTipo = 'Mercantil';
          break;
        case 'Civil':
          cTipo = 'nCivil';
          break;
        case 'Rural':
          cTipo = 'cRural';
          break;
        case 'PDU':
          cTipo = 'cPDU';
          break;
        default:
          return;
      }
    }
    if (selectedOption == 'Seleccionar') {
      mostrarError('Seleccione una opcion');
    } else {
      switch (selectedOption) {
        case 'Ciudadano':
        case 'Notaria':
          iIDSolicitud = solicitudController.text;
          iIDAnioFiscal = selectedYear;
          apiUrl = '$baseUrl/rpp/getSolicitudes';
          break;
        case 'Comercio PMNC y CR':
          iIDSolicitud = solicitudController.text;
          iIDAnioFiscal = selectedYear;
          apiUrl = '$baseUrl/comercio/getSolicitudes';
          break;
        case 'Catastro':
          iIDSolicitud = solicitudController.text;
          iIDAnioFiscal = selectedYear;
          apiUrl = '$baseUrl/catastro/getSolicitudes';
          break;
        case 'Avaluo':
          iIDSolicitud = solicitudController.text;
          iIDAnioFiscal = selectedYear;
          apiUrl = '$baseUrl/avaluo/getSolicitudes';
          break;
        case 'Comercio SIGER':
          cActa = cActaController.text;
          dtFechaActa = dateController.text;
          apiUrl = '$baseUrl/comercio/getSolicitudessiger';
          break;
        case 'Comercio Certificados':
          iIDSolicitud = solicitudController.text;
          iIDAnioFiscal = selectedYear;
          cTipo = cTipo;
          if (kDebugMode) {
            print(cTipo);
          }
          apiUrl = '$baseUrl/comercio/getSolicitudesCertificados';
          if (kDebugMode) {
            print(apiUrl);
          }
          break;
        case 'Comercio Constancias':
          iIDSolicitud = solicitudController.text;
          iIDAnioFiscal = selectedYear;
          cTipo = cTipo;
          apiUrl = '$baseUrl/comercio/getSolicitudesConstancias';
          break;
        default:
          return;
      }
    }
    if (kDebugMode) {
      print('ola4');
      print(cTipo);
      print(apiUrl);
    }

    try {
      if (selectedOption == 'Comercio SIGER') {
        if (kDebugMode) {
          print('entrando');
        }
        response = await http.post(Uri.parse(apiUrl), body: {
          'cActa': cActa,
          'dtFechaActa': dtFechaActa,
        });
      }

      if (selectedOption == 'Comercio Certificados' ||
          selectedOption == 'Comercio Constancias') {
        response = await http.post(Uri.parse(apiUrl), body: {
          'iIDSolicitud': iIDSolicitud,
          'iIDAnioFiscal': iIDAnioFiscal.toString(),
          'cTipo': cTipo,
        });
      }

      if (selectedOption == 'Notaria' ||
          selectedOption == 'Ciudadano' ||
          selectedOption == 'Catastro' ||
          selectedOption == 'Avaluo' ||
          selectedOption == 'Comercio PMNC y CR') {
        response = await http.post(Uri.parse(apiUrl), body: {
          'iIDSolicitud': iIDSolicitud,
          'iIDAnioFiscal': iIDAnioFiscal.toString(),
        });
      }
      if (kDebugMode) {
        print(apiUrl);
      }
      if ((response.statusCode == 200)) {
        var data = response.body;
        mostrarResultados(data, cTipo, iIDSolicitud, iIDAnioFiscal, cActa,
            dtFechaActa, selectedOption);
      } else {
        if (kDebugMode) {
          print('Error de la API - Código de estado: ${response.statusCode}');
        }
      }
    } on SocketException {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error de red: No se pudo conectar al servidor');
    } catch (e) {
      //print('Otro error: $e');
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Otro error inesperado');
    }
  }

  void mostrarError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> mostrarResultados(
      dynamic data,
      String cTipo,
      String iIDSolicitud,
      int iIDAnioFiscal,
      String cActa,
      String dtFechaActa,
      String selectedOption) async {
    var jsonResponse = json.decode(data);
    if (kDebugMode) {
      print(jsonResponse);
    }
    if (jsonResponse is Map) {
      // Caso: Respuesta es un objeto
      if (kDebugMode) {
        print('aqui entro');
      }
      bool success = jsonResponse['lSuccess'];
      String message = jsonResponse['cMensaje'];

      if (!success) {
        if (kDebugMode) {
          print('aqui entro tambien');
        }
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError(message);
        return;
      }
    } else if (jsonResponse is List) {
      // Caso: Respuesta es una lista de objetos
      if (jsonResponse.isEmpty) {
        // Si la lista está vacía, mostrar un mensaje de error
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('La lista de resultados está vacía.');
        return;
      }
      if (kDebugMode) {
        print(selectedOption);
      }
      // Procesar cada objeto de la lista individualmente (puedes ajustar esto según tus necesidades)
      switch (selectedOption) {
        case 'Ciudadano':
        case 'Notaria':
          if (kDebugMode) {
            print("entrando2");
          }
          try {
            if (kDebugMode) {
              print("entro prunt");
            }
            Navigator.of(context, rootNavigator: true).pop();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadosSeguimientoRPP(
                  informacion: data,
                  iIDSolicitud: iIDSolicitud,
                  iIDAnioFiscal: iIDAnioFiscal,
                ),
              ),
            );
          } catch (e) {
            if (kDebugMode) {
              print("Error al cambiar de vista: $e");
            }
          }
          break;
        case 'Comercio PMNC y CR':
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadosSeguimientoComercio(
                informacion: data,
                iIDSolicitud: iIDSolicitud,
                iIDAnioFiscal: iIDAnioFiscal,
              ),
            ),
          );
          break;
        case 'Catastro':
          try {
            Navigator.of(context, rootNavigator: true).pop();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultadosSeguimientoCatastro(
                  informacion: data,
                  iIDSolicitud: iIDSolicitud,
                  iIDAnioFiscal: iIDAnioFiscal,
                ),
              ),
            );
          } catch (e) {
            if (kDebugMode) {
              print("Error al cambiar de vista: $e");
            }
          }
          break;
        case 'Avaluo':
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadosSeguimientoAvaluo(
                informacion: data,
                iIDSolicitud: iIDSolicitud,
                iIDAnioFiscal: iIDAnioFiscal,
              ),
            ),
          );
          break;
        case 'Comercio SIGER':
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadoSeguimientoComercioSiger(
                informacion: data,
                cActa: cActa,
                dtFechaActa: dtFechaActa,
              ),
            ),
          );
          break;
        case 'Comercio Constancias':
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadoSeguimientoComercioConstancias(
                informacion: data,
                iIDSolicitud: iIDSolicitud,
                iIDAnioFiscal: iIDAnioFiscal,
                cTipo: cTipo,
              ),
            ),
          );
          break;
        case 'Comercio Certificados':
          Navigator.of(context, rootNavigator: true).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultadoSeguimientoComercioCertificados(
                informacion: data,
                iIDSolicitud: iIDSolicitud,
                iIDAnioFiscal: iIDAnioFiscal,
                cTipo: cTipo,
              ),
            ),
          );
          break;
        default:
          return;
      }
    } else {
      mostrarError('Error: Respuesta de la API inesperada.');
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  List<String> opciones = [
    'Seleccionar',
    'Notaria',
    'Ciudadano',
    'Catastro',
    'Avaluo',
    'Comercio PMNC y CR',
    'Comercio SIGER',
    'Comercio Certificados',
    'Comercio Constancias',
  ];

  List<String> tipos = [
    'Seleccionar',
    'Mercantil',
    'Civil',
    'Rural',
    'PDU',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento'),
        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back), // Cambia el icono según tus preferencias
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const WebViewApp(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: DropdownButton<String>(
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue ?? 'Seleccionar';
                      showInputs = [
                        'Ciudadano',
                        'Comercio PMNC y CR',
                        'Notaria',
                        'Catastro',
                        'Avaluo'
                      ].contains(selectedOption);
                      showComercioSigerInputs =
                          selectedOption == 'Comercio SIGER';
                      showTipoDropdown = [
                        'Comercio Certificados',
                        'Comercio Constancias'
                      ].contains(selectedOption);
                    });
                  },
                  items: opciones.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'EpicaPro', // Cambia la fuente aquí
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (showTipoDropdown || showInputs)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: solicitudController,
                        decoration: const InputDecoration(
                          hintText: 'Solicitud',
                          prefixIcon: Icon(Icons.description),
                          labelStyle: TextStyle(
                            // Agrega aquí el estilo del label
                            fontFamily: 'EpicaPro',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (showTipoDropdown || showInputs)
                      SizedBox(
                        width: 250,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButton<int>(
                                value: selectedYear,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedYear = newValue!;
                                  });
                                },
                                items: years.map((int year) {
                                  return DropdownMenuItem<int>(
                                    value: year,
                                    child: Text(year.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (showTipoDropdown)
                      DropdownButton<String>(
                        value: selectedTipo,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTipo = newValue!;
                          });
                        },
                        items:
                            tipos.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'EpicaPro', // Cambia la fuente aquí
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              if (showComercioSigerInputs)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: cActaController,
                        decoration: const InputDecoration(
                          hintText: 'Acta',
                          prefixIcon: Icon(Icons.description),
                          labelStyle: TextStyle(
                            // Agrega aquí el estilo del label
                            fontFamily: 'EpicaPro',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un valor';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          hintText: 'Fecha',
                          prefixIcon: Icon(Icons.calendar_month),
                          labelStyle: TextStyle(
                            // Agrega aquí el estilo del label
                            fontFamily: 'EpicaPro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat("yyyy-MM-dd").format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate.toString();
                            });
                          } else {
                            if (kDebugMode) {
                              print("Selecciona una fecha");
                            }
                          }
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un valor';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedOption == 'Seleccionar' ||
                          (showTipoDropdown && selectedTipo == 'Seleccionar')) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Por favor, selecciona una opción válida.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        obtenerInformacionDeAPI();
                      }
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(
                        142, 44, 72, 1), // Cambia el color de fondo aquí
                    foregroundColor:
                        Colors.white, // Cambia el color del texto y del icono
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    // await http.init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(const MaterialApp(
      home: Seguimiento(),
    ));
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) {
        return true;
      };
  }
}
