import 'package:flutter/material.dart';

class SnaksBar {
  static void showSnackBar(BuildContext context, String message,
      {Color? color}) {
    // Verificar si el contexto sigue siendo válido antes de mostrar el SnackBar
    if (!_isContextValid(context)) return;

    // Usar una zona segura para capturar cualquier error relacionado con el contexto
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Ignorar errores relacionados con el contexto
      debugPrint('Error al mostrar SnackBar: $e');
    }
  }

  // Método para verificar si el contexto sigue siendo válido
  static bool _isContextValid(BuildContext context) {
    try {
      return context.mounted && context.findRenderObject() != null;
    } catch (e) {
      return false;
    }
  }
}
