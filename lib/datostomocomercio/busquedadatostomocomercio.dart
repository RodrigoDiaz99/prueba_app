import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/constants.dart';
import 'package:insejupy_multiplatform/datostomocomercio/resultadobusquedatomocomercio.dart';
import 'dart:convert';
import 'package:insejupy_multiplatform/alerts.dart';

const List<String> libroOptions = [
  'Seleccionar Libro',
  'SEPTIMO',
  'OCTAVO',
  'PRIMERO RURAL',
  'TERCERO RURAL(AGRICOLA)',
];

const List<String> tipoLibroOptions = [
  'Seleccionar Tipo Libro',
  'NINGUNO',
  'NINGUNO(AGRICOLA)',

  // Otras opciones...
];

const List<String> volumenOptions = [
  'Seleccionar Volumen',
  'UNICO',
  'BIS',
  'A',
  'B',
  'C',
  'CH',
  'D',
  'E',
  'F',
  'ABIS',
  'BB',
  '1B',
  '1C',
  '1D',
  '2A',
  '2B',
  'A-BIS',
  'A-PRIMERA',
  'A-SEGUNDAS',
  // Otras opciones...
];
const List<String> sistemaOptions = [
  'Seleccionar Sistema',
  'SISTEMA VIGENTE',
  'VIGENTE(AGRICOLA)',

  // Otras opciones...
];

class Busquedadatostomocomercio extends StatefulWidget {
  const Busquedadatostomocomercio({Key? key}) : super(key: key);

  @override
  State<Busquedadatostomocomercio> createState() => _BusquedadatostomocomercioState();

}

class _BusquedadatostomocomercioState extends State<Busquedadatostomocomercio> {
  String selectedLibroOption = 'Seleccionar Libro';
  String selectedTipoLibroOption = 'Seleccionar Tipo Libro';
  String selectedVolumenOption = 'Seleccionar Volumen';
  String selectedSistemaOption = 'Seleccionar Sistema';
  final TextEditingController tomoController = TextEditingController();
  final TextEditingController fojaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> obtenerInformacionDeAPI() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    mostrarAlertDialog(context, 'Buscando información...');
    // Validar que al menos una opción de búsqueda esté seleccionada
    if (selectedLibroOption == 'Seleccionar Libro' &&
        selectedTipoLibroOption == 'Seleccionar Tipo Libro' &&
        selectedVolumenOption == 'Seleccionar Volumen' &&
        selectedSistemaOption == 'Seleccionar Sistema' &&
        tomoController.text.isEmpty &&
        fojaController.text.isEmpty) {
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError(
          'Por favor, selecciona al menos una opción de búsqueda o ingresa un valor en algún campo de texto.', context);
      return;
    }
    int iIDLibro;
    int iIDTipoLibro;
    int iIDVolumen;
    int iIDSistema;
    String apiUrl = '$apiBaseUrl/api/getConsultaTomoComercio';

    if (selectedLibroOption == 'Seleccionar Libro') {
      iIDLibro = 0;
    } else {
      switch (selectedLibroOption) {
        case 'SEPTIMO':
          iIDLibro = 1;
          break;
        case 'OCTAVO':
          iIDLibro = 2;
          break;
        case 'PRIMERO RURAL':
          iIDLibro = 3;
          break;
        case 'TERCERO RURAL(AGRICOLA)':
          iIDLibro = 4;
          break;

        default:
          return;
      }
    }

    if (selectedTipoLibroOption == 'Seleccionar Tipo Libro') {
      iIDTipoLibro = 0;
    } else {
      switch (selectedTipoLibroOption) {
        case 'NINGUNO':
          iIDTipoLibro = 1;
          break;
        case 'NINGUNO(AGRICOLA)':
          iIDTipoLibro = 2;
          break;

        default:
          return;
      }
    }

    if (selectedVolumenOption == 'Seleccionar Volumen') {
      iIDVolumen = 0;
    } else {
      switch (selectedVolumenOption) {
        case 'UNICO':
          iIDVolumen = 1;
          break;
        case 'BIS':
          iIDVolumen = 2;
          break;
        case 'A':
          iIDVolumen = 3;
          break;
        case 'B':
          iIDVolumen = 4;
          break;
        case 'C':
          iIDVolumen = 5;
          break;
        case 'CH':
          iIDVolumen = 6;
          break;
        case 'D':
          iIDVolumen = 7;
          break;
        case 'E':
          iIDVolumen = 8;
          break;
        case 'F':
          iIDVolumen = 9;
          break;
        case 'ABIS':
          iIDVolumen = 10;
          break;
        case 'BB':
          iIDVolumen = 11;
          break;
        case '1B':
          iIDVolumen = 12;
          break;
        case '1C':
          iIDVolumen = 13;
          break;
        case '1D':
          iIDVolumen = 14;
          break;
        case '2A':
          iIDVolumen = 15;
          break;
        case '2B':
          iIDVolumen = 16;
          break;
        case 'A-BIS':
          iIDVolumen = 17;
          break;
        case 'A-PRIMERA':
          iIDVolumen = 18;
          break;
        case 'A-SEGUNDAS':
          iIDVolumen = 19;
          break;
        default:
          return;
      }
    }

    if (selectedSistemaOption == 'Seleccionar Sistema') {
      iIDSistema = 0;
    } else {
      switch (selectedSistemaOption) {
        case 'SISTEMA VIGENTE':
          iIDSistema = 1;
          break;
        case 'VIGENTE(AGRICOLA)':
          iIDSistema = 2;
          break;

        default:
          return;
      }
    }
  try{
    var response = await http.post(Uri.parse(apiUrl), body: {
      'iIDLibro': iIDLibro.toString(),
      'iTomo': tomoController.text,
      'iIDTipoLibro': iIDTipoLibro.toString(),
      'iIDVolumen': iIDVolumen.toString(),
      'iIDSistemaLibro': iIDSistema.toString(),
      'iFolio': fojaController.text,
    });

    if (response.statusCode == 200) {
      var data = response.body;
      // Procesar la respuesta de la API y mostrar los resultados si es necesario.
      mostrarResultados(data);
    } else {
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

  Future<void> mostrarResultados(dynamic data) async {
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
        mostrarError('La lista de resultados está vacía.', context);
        return;
      }
      Navigator.of(context, rootNavigator: true).pop(); 
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Resultadobusquedatomocomercio(informacion: data)),
      );
      // Procesar cada objeto de la lista individualmente (puedes ajustar esto según tus necesidades)
    } else {
      mostrarError('Error: Respuesta de la API inesperada.', context);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta Por Tomo'),
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: tomoController,
                        decoration: const InputDecoration(
                          hintText: 'TOMO',
                          prefixIcon: Icon(Icons.book),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly],
                        validator: (String? value) {
                          if (value == '0') {
                            return 'Por favor, ingresa el tomo';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: fojaController,
                        decoration: const InputDecoration(
                          hintText: 'FOJA',
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedLibroOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLibroOption = newValue ?? 'Seleccionar Libro';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Libro',
                    prefixIcon: Icon(Icons.menu_book),
                  ),
                  items: libroOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  // validator: (String? value) {
                  //   if (value == null ||
                  //       value.isEmpty ||
                  //       value == 'Seleccionar Libro') {
                  //     return 'Por favor, selecciona un libro';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedTipoLibroOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTipoLibroOption =
                          newValue ?? 'Seleccionar Tipo Libro';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tipo Predio',
                    prefixIcon: Icon(Icons.home),
                  ),
                  items:
                      tipoLibroOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedVolumenOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedVolumenOption = newValue ?? 'Seleccionar Volumen';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Volumen',
                    prefixIcon: Icon(Icons.menu),
                  ),
                  items: volumenOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedSistemaOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSistemaOption = newValue ?? 'Seleccionar Sistema';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Sistema',
                    prefixIcon: Icon(Icons.menu),
                  ),
                  items: sistemaOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
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
