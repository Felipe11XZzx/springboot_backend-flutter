/*import 'package:inicio_sesion/models/user.dart';

class Logica  {
  static final List<User> listaRegistro = [
    User(nombre: "Rolando", contrasena: "Rolando", edad: 36, imagen: "", lugarNacimiento: "Zaragoza", administrador: false,),
    User(nombre: "admin", contrasena: "admin", edad: 50, imagen: "", lugarNacimiento: "Zaragoza", administrador: true),
  ];

  
  static List<User> listarUsuarios() {
    return listaRegistro.where((user) => !user.administrador).toList();
  }

  get lista {
    return listaRegistro;
  }

  static void aniadirUser (User user) {
    listaRegistro.add(user);
  }

  static void updateUser (User user) {
    int position = listaRegistro.indexWhere((u) => u.nombre == user.nombre);
    if (position != -1) {
      listaRegistro[position] = user;
    }
  }
  

  static User? findUser(String nombre) {
    try {
      return listaRegistro.firstWhere((u) => u.nombre == nombre);
        
    } catch (e) {
      return null;
    }
  }

  static void deleteUser (String nombre) {
    listaRegistro.removeWhere((u) => u.nombre == nombre);
  }

  static String? validarUser (String user1, String password) {
    try {
      User user = listaRegistro.firstWhere(
        (u) => u.nombre == user1 && u.contrasena == password
      );

      if (user.bloqueado) {
        return "Usuario bloqueado, por favor contacta con el administrador";
      }
      return null;     
    } catch (e) {
      return "Datos introducidos no son correctos";
    }
  }

}
*/