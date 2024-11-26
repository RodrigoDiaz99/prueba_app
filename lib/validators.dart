// validators.dart
String? validarLS(String? value) {
  final RegExp regex = RegExp(r'^[a-zA-Z\s.,]+$');
  
  // Si el valor es nulo o está vacío, no se realiza ninguna validación.
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  if (!regex.hasMatch(value)) {
    return 'Por favor, ingresa un valor adecuado.';
  }
  if (value.startsWith(' ')) {
    return 'El valor no debe iniciar con espacios en blanco.';
  }
  return null; // La validación fue exitosa
}

String? validarLSN(String? value) {
  final RegExp regex = RegExp(r'^[a-zA-Z0-9\s.,]+$');
  
  // Si el valor es nulo o está vacío, no se realiza ninguna validación.
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  if (!regex.hasMatch(value)) {
    return 'Por favor, ingresa un valor adecuado.';
  }
  if (value.startsWith(' ')) {
    return 'El valor no debe iniciar con espacios en blanco.';
  }
  return null; // La validación fue exitosa
}
