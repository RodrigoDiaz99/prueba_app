import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insejupy_multiplatform/constants.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/datospredio/resultadobusquedapredio.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:insejupy_multiplatform/alerts.dart';

const List<String> tipoConsultaOptions = [
  'Folio electrónico',
  'Nomenclatura',
  'Tablaje',
  'Información Catastral'
];

const List<String> municipiosOptions = [
  'Selecciona',
  'ABALA',
  'ACANCEH',
  'AKIL',
  'BACA',
  'BOKOBA',
  'BUCTZOTZ',
  'CACALCHEN',
  'CALOTMUL',
  'CANSAHCAB',
  'CANTAMAYEC',
  'CELESTUN',
  'CENOTILLO',
  'CONKAL',
  'CUNCUNUL',
  'CUZAMA',
  'CHACSINKIN',
  'CHANKOM',
  'CHAPAB',
  'CHEMAX',
  'CHICXULUB PUEBLO',
  'CHICHIMILA',
  'CHIKINDZONOT',
  'CHOCHOLA ',
  'CHUMAYEL',
  'DZAN',
  'DZEMUL',
  'DZIDZANTUN',
  'DZILAM DE BRAVO',
  'DZILAM GONZALEZ',
  'DZITAS',
  'DZONCAUICH',
  'ESPITA',
  'HALACHO',
  'HOCABA',
  'HOCTUN',
  'HOMUN',
  'HUHI',
  'HUNUCMA',
  'IXIL',
  'IZAMAL',
  'KANASIN',
  'KANTUNIL',
  'KAUA',
  'KINCHIL',
  'KOPOMA',
  'MAMA',
  'MANI',
  'MAXCANU',
  'MAYAPAN',
  'MERIDA',
  'MOCOCHA',
  'MOTUL',
  'MUNA',
  'MUXUPIP ',
  'OPICHEN',
  'OXKUTZCAB',
  'PANABA',
  'PETO',
  'PROGRESO',
  'QUINTANA ROO',
  'RIO LAGARTOS',
  'SACALUM',
  'SAMAHIL',
  'SANAHCAT',
  'SAN FELIPE',
  'SANTE ELENA',
  'SEYE',
  'SINANCHE',
  'SOTUTA',
  'SUCILA',
  'SUDZAL',
  'SUMA DE HIDALGO',
  'TAHDZIU',
  'TAHMEK',
  'TEABO',
  'TECOH',
  'TEKAL DE VENEGAS',
  'TEKANTO',
  'TEKAX',
  'TEKIT',
  'TEKOM',
  'TELCHAC PUEBLO',
  'TELCHAC PUERTO',
  'TEMAX',
  'TEMOZON',
  'TEPAKAN',
  'TETIZ',
  'TEYA',
  'TICUL',
  'TIMUCUY',
  'TINUM',
  'TIXCACALCUPUL',
  'TIXKOKOB',
  'TIXMEHUAC',
  'TIXPEHUAL',
  'TIZIMIN',
  'TUNKAS',
  'TZUCACAB',
  'UAYMA',
  'UCU',
  'UMAN',
  'VALLADOLID',
  'XOCCHEL',
  'YAXCABA',
  'YAXKUKUL',
  'YOBAIN',
];

class Busquedadatospredio extends StatefulWidget {
  const Busquedadatospredio({Key? key}) : super(key: key);

  @override
  State<Busquedadatospredio> createState() => _BusquedadatospredioState();

}

class _BusquedadatospredioState extends State<Busquedadatospredio> {
  String selectedMunicipioOption = 'Selecciona';
  String selectedConsultaOption = 'Folio electrónico';
  final TextEditingController folioeController = TextEditingController();
  final TextEditingController calleController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController tablajeController = TextEditingController();
  final TextEditingController seccionController = TextEditingController();
  final TextEditingController manzanaController = TextEditingController();
  final TextEditingController municipioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showFolioElectronicoInputs = true;
  bool showNomenclaturaInputs = false;
  bool showTablajeInputs = false;
  bool showInfoCatInputs = false;

  Future<void> obtenerInformacionDeAPI() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    mostrarAlertDialog(context, 'Buscando información...');
    String municipio;
    String IDPredio;
    int opcion;
    String apirUrl = '$apiBaseUrl/api/getDatosPredio';
    switch (selectedConsultaOption) {
      case 'Folio electrónico':
        opcion = 1;
        break;
      case 'Nomenclatura':
        opcion = 2;
        break;
      case 'Tablaje':
        opcion = 3;
        break;
      case 'Información Catastral':
        opcion = 4;
        break;
      default:
        return;
    }

    if (selectedMunicipioOption == 'Selecciona') {
      municipio = "";
    } else {
      municipio = selectedMunicipioOption;
    }

    IDPredio = folioeController.text;

  try {
    var response = await http.post(Uri.parse(apirUrl), body: {
      'iIDPredio': folioeController.text,
      'cCalle': calleController.text,
      'cNumero': numeroController.text,
      'cTablaje': tablajeController.text,
      'cSeccion': seccionController.text,
      'cManzana': manzanaController.text,
      'cMunicipio': municipio,
      'opcion': opcion.toString(),
    });

    if (response.statusCode == 200) {
      var data = response.body;
      mostrarResultados(data, IDPredio);
    } else {
      //print('Error de la API - Código de estado: ${response.statusCode}');
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error de la API', context);
    }
  } on SocketException {
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('Error de red: No se pudo conectar al servidor', context);
  } catch (e) {
    //print('Otro error: $e');
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('Otro error inesperado', context);
    }
  }

  Future<void> mostrarResultados(dynamic data, String idPredio) async {
    var jsonResponse = json.decode(data);

    if (jsonResponse is Map) {
      // Caso: Respuesta es un objeto
      bool success = jsonResponse['lSuccess'];
      String message = jsonResponse['cMensaje'];
      if (!success) {
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError(message, context);
        return;
      }
    } else if (jsonResponse is List) {
      // Caso: Respuesta es una lista de objetos
      if (jsonResponse.isEmpty) {
        // Si la lista está vacía, mostrar un mensaje de error
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('La lista de resultados está vacía.', context);
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resultadobusquedapredio(informacion: data),
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error: Respuesta de la API inesperada.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Predio Por'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedConsultaOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedConsultaOption = newValue ?? 'Selecciona';
                      showFolioElectronicoInputs =
                          selectedConsultaOption == 'Folio electrónico';
                      showNomenclaturaInputs =
                          selectedConsultaOption == 'Nomenclatura';
                      showTablajeInputs = selectedConsultaOption == 'Tablaje';
                      showInfoCatInputs =
                          selectedConsultaOption == 'Información Catastral';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Consulta',
                    prefixIcon: Icon(Icons.menu_book),
                  ),
                  items: tipoConsultaOptions
                      .map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                if (showFolioElectronicoInputs)
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: folioeController,
                    decoration: const InputDecoration(
                      hintText: 'Folio electrónico',
                      prefixIcon: Icon(Icons.document_scanner),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el folio';
                      }
                      return null;
                    },
                  ),
                if (showNomenclaturaInputs)
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: calleController,
                        decoration: const InputDecoration(
                          hintText: 'Calle',
                          prefixIcon: Icon(Icons.streetview),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa la calle';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: numeroController,
                        decoration: const InputDecoration(
                          hintText: 'Numero',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa el numero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedMunicipioOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMunicipioOption = newValue ?? 'Selecciona';
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Municipio',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: municipiosOptions
                            .map<DropdownMenuItem<String>>((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (showTablajeInputs)
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: tablajeController,
                        decoration: const InputDecoration(
                          hintText: 'Tablaje',
                          prefixIcon: Icon(Icons.menu_book),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa el tablaje';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedMunicipioOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMunicipioOption = newValue ?? 'Selecciona';
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Municipio',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: municipiosOptions
                            .map<DropdownMenuItem<String>>((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (showInfoCatInputs)
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: seccionController,
                        decoration: const InputDecoration(
                          hintText: 'Sección',
                          prefixIcon: Icon(Icons.location_pin),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa la sección';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: manzanaController,
                        decoration: const InputDecoration(
                          hintText: 'Manzana',
                          prefixIcon: Icon(Icons.location_pin),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa la manzana';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: selectedMunicipioOption,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMunicipioOption = newValue ?? 'Selecciona';
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Municipio',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: municipiosOptions
                            .map<DropdownMenuItem<String>>((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: obtenerInformacionDeAPI,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
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
      ),
    );
  }
}
