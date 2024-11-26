import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:insejupy_multiplatform/constants.dart';
import 'package:insejupy_multiplatform/validators.dart';
import 'package:insejupy_multiplatform/datostomo/resultadobusquedatomo.dart';
import 'dart:convert';
import 'package:insejupy_multiplatform/alerts.dart';

const List<String> libroOptions = [
  'Seleccionar Libro',
  'PRIMERO',
  'SEGUNDO',
  'TERCERO',
  'CUARTO',
  'SEXTO',
  'NOVENO',
  'TERCERO DEL REGISTRO DEL CRÉDITO AGRÍCOLA',
  '2DO COMERCIO',
  '5TO AGRÍCOLA',
  'SEXTO AUXILIAR',
  'TERRENOS NACIONALES',
  'REGISTRO DE CRÉDITO RURAL',
  'Depto. Judicial de Tizimín/Fondo Poder Ejecutivo Sección Registro Público de la Propiedad del AGEY'
];

const List<String> tipoPredioOptions = [
  'Seleccionar Tipo Predio',
  'URBANO',
  'RÚSTICO',
  'COMERCIO'
  // Otras opciones...
];

const List<String> volumenOptions = [
  'Seleccionar Volumen',
  'UNICO',
  'PRIMERO',
  'SEGUNDO',
  'TERCERO',
  'CUARTO',
  'QUINTO',
  'BIS',
  'SEXTO',
  'AUXILIAR ÚNICO'
  // Otras opciones...
];

class Busquedadatostomo extends StatefulWidget {
  const Busquedadatostomo({Key? key}) : super(key: key);

  @override
  State<Busquedadatostomo> createState() => _BusquedadatostomoState();

}

class _BusquedadatostomoState extends State<Busquedadatostomo> {
  String selectedLibroOption = 'Seleccionar Libro';
  String selectedTipoPredioOption = 'Seleccionar Tipo Predio';
  String selectedVolumenOption = 'Seleccionar Volumen';
  final TextEditingController tomoController = TextEditingController();
  final TextEditingController folioController = TextEditingController();
  final TextEditingController letraController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  
  Future<void> obtenerInformacionDeAPI() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    mostrarAlertDialog(context, 'Buscando información...');
    int iLibro;
    int iTipoPredio;
    int iVolumenPredio;
    String apiUrl = '$apiBaseUrl/api/getConsultaTomo';

    switch (selectedLibroOption) {
      case 'PRIMERO':
        iLibro = 1;
        break;
      case 'SEGUNDO':
        iLibro = 6;
        break;
      case 'TERCERO':
        iLibro = 3;
        break;
      case 'CUARTO':
        iLibro = 4;
        break;
      case 'SEXTO':
        iLibro = 7;
        break;
      case 'NOVENO':
        iLibro = 5;
        break;
      case 'TERCERO DEL REGISTRO DEL CRÉDITO AGRÍCOLA':
        iLibro = 11;
        break;
      case '2DO COMERCIO':
        iLibro = 14;
        break;
      case '5TO AGRÍCOLA':
        iLibro = 20;
        break;
      case 'SEXTO AUXILIAR':
        iLibro = 26;
        break;
      case 'TERRENOS NACIONALES':
        iLibro = 29;
        break;
      case 'REGISTRO DE CRÉDITO RURAL':
        iLibro = 30;
        break;
      case 'Depto. Judicial de Tizimín/Fondo Poder Ejecutivo Sección Registro Público de la Propiedad del AGEY':
        iLibro = 32;
        break;
      default:
        return;
    }
    if (selectedTipoPredioOption == 'Seleccionar Tipo Predio') {
      iTipoPredio = 0;
    } else {
      switch (selectedTipoPredioOption) {
        case 'URBANO':
          iTipoPredio = 1;
          break;
        case 'RÚSTICO':
          iTipoPredio = 2;
          break;
        case 'COMERCIO':
          iTipoPredio = 3;
          break;

        default:
          return;
      }
    }

    if (selectedVolumenOption == 'Seleccionar Volumen') {
      iVolumenPredio = 0;
    } else {
      switch (selectedVolumenOption) {
        case 'UNICO':
          iVolumenPredio = 1;
          break;
        case 'PRIMERO':
          iVolumenPredio = 2;
          break;
        case 'SEGUNDO':
          iVolumenPredio = 3;
          break;
        case 'TERCERO':
          iVolumenPredio = 4;
          break;
        case 'CUARTO':
          iVolumenPredio = 5;
          break;
        case 'QUINTO':
          iVolumenPredio = 7;
          break;
        case 'BIS':
          iVolumenPredio = 8;
          break;
        case 'SEXTO':
          iVolumenPredio = 9;
          break;
        case 'AUXILIAR ÚNICO':
          iVolumenPredio = 55;
          break;
        default:
          return;
      }
    }

  try{
    var response = await http.post(Uri.parse(apiUrl), body: {
      'cTipo': 'CONSULTATOMOS',
      'iTipoPredio': iTipoPredio.toString(),
      'iVolumenPredio': iVolumenPredio.toString(),
      'cLetraLibro': letraController.text,
      'cFolioLibro': folioController.text,
      'iLibro': iLibro.toString(),
      'cTomo': tomoController.text,
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
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('La lista de resultados está vacía.',context);
        return;
      }
      Navigator.of(context, rootNavigator: true).pop();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resultadobusquedatomo(
            informacion: data,
          ),
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: tomoController,
                  decoration: const InputDecoration(
                    hintText: 'Tomo',
                    prefixIcon: Icon(Icons.book),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly],
                  validator: (String? value) {
                    if (value == null || value.isEmpty || value == '0') {
                      return 'Por favor, ingresa el tomo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedLibroOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLibroOption =
                          newValue ?? 'Seleccionar Libro';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Libro',
                    prefixIcon: Icon(Icons.home),
                  ),
                 items: libroOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option.length > 26 ? '${option.substring(0, 26)}...' : option),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Seleccionar Libro') {
                      return 'Por favor, selecciona un libro';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(   
                  value: selectedTipoPredioOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTipoPredioOption =
                          newValue ?? 'Seleccionar Tipo Predio';
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tipo Predio',
                    prefixIcon: Icon(Icons.home),
                  ),
                  items:
                      tipoPredioOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: folioController,
                        decoration: const InputDecoration(
                          hintText: 'FOLIO',
                          prefixIcon: Icon(Icons.toc_rounded),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: letraController,
                        decoration: const InputDecoration(
                          hintText: 'LETRA',
                          prefixIcon: Icon(Icons.spellcheck),
                        ),
                        validator: validarLS,
                        inputFormatters: [LengthLimitingTextInputFormatter(3),],
                      ),
                    ),
                  ],
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
