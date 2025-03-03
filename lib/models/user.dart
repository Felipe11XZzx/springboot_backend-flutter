class User {
  final int id;
  final String nombre;
  final String contrasena;
  final String contrasena2;
  final String imagen;
  final int edad;
  final String trato;
  final String lugarNacimiento;
  final bool administrador;
  late final bool bloqueado;

  User(
      {required this.id,
      required this.nombre,
      required this.contrasena,
      required this.contrasena2,
      required this.edad,
      required this.trato,
      required this.imagen,
      required this.lugarNacimiento,
      required this.administrador,
      required this.bloqueado});

  int getId() {
    return id;
  }

  String getNombre() {
    return nombre;
  }

  String getPass() {
    return contrasena;
  }

  String getImage() {
    return imagen;
  }

  int getEdad() {
    return edad;
  }

  String getLugarNacimiento() {
    return lugarNacimiento;
  }

  String getTrato() {
    return trato;
  }

  bool getAdministrador() {
    return administrador;
  }

// IMPLEMENTACION DE CASTEO DE JSON A OBJETO USER
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
      administrador: json['administrador'],
      bloqueado: json['bloqueado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "contrasena": contrasena,
      "contrasena2": contrasena2,
      "imagen": imagen,
      "edad": edad,
      "lugarNacimiento": lugarNacimiento,
      "administrador": administrador,
    };
  }

  @override
  String toString() {
    return 'User(nombre: $nombre, contrasena: $contrasena, contrasena2: $contrasena2, $trato trato: )';
  }
}
