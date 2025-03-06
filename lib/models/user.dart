import 'package:logger/logger.dart';

class User {
  final int? id;
  final String nombre;
  final String contrasena;
  final String? contrasena2;
  final String? imagen;
  final int edad;
  final String? trato;
  final String? lugarNacimiento;
  final bool administrador;
  final bool? bloqueado;
  static final logger = Logger();

  User({
    this.id,
    required this.nombre,
    required this.contrasena,
    this.contrasena2,
    this.imagen = "",
    required this.edad,
    this.trato = "Sr.",
    this.lugarNacimiento = "",
    this.administrador = false,
    this.bloqueado = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      logger.d('Parseando JSON de usuario: $json');
      return User(
        id: json['id'] as int?,
        nombre: json['nombre']?.toString() ?? '',
        contrasena: json['contrasena']?.toString() ?? '',
        contrasena2: json['contrasena2']?.toString(),
        edad: (json['edad'] is String)
            ? int.tryParse(json['edad']) ?? 0
            : json['edad'] as int? ?? 0,
        trato: json['trato']?.toString(),
        imagen: json['imagen']?.toString(),
        lugarNacimiento: json['lugarNacimiento']?.toString(),
        administrador: json['administrador'] as bool? ?? false,
        bloqueado: json['bloqueado'] as bool? ?? false,
      );
    } catch (e, stackTrace) {
      logger.e('Error al parsear JSON de usuario:',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      final Map<String, dynamic> data = {
        "nombre": nombre,
        "contrasena": contrasena,
        "edad": edad,
        "administrador": administrador,
        "bloqueado": bloqueado,
        "lugarNacimiento": lugarNacimiento ?? "",
      };

      if (id != null) data["id"] = id;
      if (contrasena2 != null) data["contrasena2"] = contrasena2;
      if (imagen != null && imagen!.isNotEmpty) data["imagen"] = imagen;
      if (trato != null) data["trato"] = trato;

      logger.d('Generando JSON de usuario: $data');
      return data;
    } catch (e, stackTrace) {
      logger.e('Error al generar JSON de usuario:',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  String toString() {
    return 'User(id: $id, nombre: $nombre, edad: $edad)';
  }
}
