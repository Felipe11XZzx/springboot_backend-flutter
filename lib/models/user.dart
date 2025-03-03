class User {
  final int? id;
  final String nombre;
  final String contrasena;
  final String? contrasena2;
  final String? imagen;
  final int edad;
  final String? trato;
  final String lugarNacimiento;
  final bool administrador;
  final bool bloqueado;

  User({
    this.id,
    required this.nombre,
    required this.contrasena,
    this.contrasena2,
    this.imagen = "",
    required this.edad,
    this.trato = "Sr.",
    required this.lugarNacimiento,
    this.administrador = false,
    this.bloqueado = false,
  });

  int? getId() => id;
  String getNombre() => nombre;
  String getPass() => contrasena;
  String? getImage() => imagen;
  int getEdad() => edad;
  String getLugarNacimiento() => lugarNacimiento;
  String? getTrato() => trato;
  bool getAdministrador() => administrador;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      contrasena: json['contrasena'],
      contrasena2: json['contrasena2'],
      edad: json['edad'],
      trato: json['trato'],
      imagen: json['imagen'],
      lugarNacimiento: json['lugarNacimiento'],
      administrador: json['administrador'] ?? false,
      bloqueado: json['bloqueado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      "nombre": nombre,
      "contrasena": contrasena,
      if (contrasena2 != null) "contrasena2": contrasena2,
      if (imagen != null) "imagen": imagen,
      "edad": edad,
      if (trato != null) "trato": trato,
      "lugarNacimiento": lugarNacimiento,
      "administrador": administrador,
      "bloqueado": bloqueado,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, nombre: $nombre, edad: $edad, trato: $trato)';
  }
}
