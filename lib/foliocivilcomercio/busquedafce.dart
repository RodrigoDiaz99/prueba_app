import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:insejupy_multiplatform/validators.dart';
import 'package:insejupy_multiplatform/foliocivilcomercio/resultadobusquedafce.dart';
import '../constants.dart';
import '../alerts.dart';

class Busquedafce extends StatefulWidget {
  const Busquedafce({Key? key}) : super(key: key);

  @override
  State<Busquedafce> createState() => _BusquedafceState();

}

class _BusquedafceState extends State<Busquedafce> {
  final TextEditingController fceController = TextEditingController();
  final TextEditingController razonsocialController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

 Future<void> obtenerInformacionAPI() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (fceController.text.isEmpty && razonsocialController.text.isEmpty) {
    mostrarError('Por favor, ingresa al menos un dato.', context);
    return;
  }

  mostrarAlertDialog(context, 'Buscando información...');

  try {
    String apiUrl = '$apiBaseUrl/api/getFolioCivilComercio';

    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'iIDFolioMercantil': fceController.text,
        'cRazonSocial': razonsocialController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = response.body;

      mostrarResultados(data);
    } else {
      //print('Error de la API - Código de estado: ${response.statusCode}');
      Navigator.of(context, rootNavigator: true).pop();
      mostrarError('Error en la solicitud a la API', context);
    }
  } on SocketException {
    //print('Error de red: $e');
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('Error de red: No se pudo conectar al servidor', context);
  } catch (e) {
    //print('Otro error: $e');
    Navigator.of(context, rootNavigator: true).pop();
    mostrarError('Otro error inesperado: $e', context);
  }
}

  Future<void> mostrarResultados(dynamic data) async {
    try {
      var jsonResponse = json.decode(data);
      
      if (jsonResponse is Map) {
        // Caso: Respuesta es un objeto
        bool success = jsonResponse['lSuccess'];
        String message = jsonResponse['cMensaje'];
        if (!success) {
          mostrarError(message, context);
          return;
        }
      } else if (jsonResponse is List) {
        // Caso: Respuesta es una lista de objetos
        if (jsonResponse.isEmpty) {
          Navigator.of(context, rootNavigator: true).pop();
          mostrarError('La lista de resultados está vacía.', context);
          return;
        }
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Resultadobusquedafce(
              informacion: data,
            ),
          ),
        );        
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        mostrarError('Error: Respuesta de la API inesperada.', context);
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      //print('Error al analizar la respuesta de la API: $e');
      mostrarError('Error al procesar la respuesta de la API', context);      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta por folio civil electronico'),
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: fceController,
                  decoration: const InputDecoration(
                    hintText: 'Folio Civil',
                    prefixIcon: Icon(Icons.document_scanner),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly],
                ),
                TextFormField(
                  controller: razonsocialController,
                  decoration: const InputDecoration(
                    hintText: 'Razon social',
                    prefixIcon: Icon(Icons.library_add),
                  ),
                  validator: validarLSN,
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: obtenerInformacionAPI,
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
