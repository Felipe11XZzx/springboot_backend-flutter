import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inicio_sesion/models/user.dart';
//import 'package:inicio_sesion/commons/images.dart';

class ProfilePage extends StatelessWidget {
  final User usuarioActual;

  const ProfilePage({super.key, required this.usuarioActual});

  ImageProvider _getImageProvider() {
    if (usuarioActual.imagen == null || usuarioActual.imagen!.isEmpty) {
      return const AssetImage('assets/images/profile_default.jpg');
    }

    if (kIsWeb) {
      if (usuarioActual.imagen!.startsWith('http') ||
          usuarioActual.imagen!.startsWith('blob:')) {
        return NetworkImage(usuarioActual.imagen!);
      }
      return const AssetImage('assets/images/profile_default.jpg');
    } else {
      try {
        return FileImage(File(usuarioActual.imagen!));
      } catch (e) {
        return const AssetImage('assets/images/profile_default.jpg');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _getImageProvider(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    usuarioActual.nombre,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    usuarioActual.trato ?? 'Sr.',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Column(
                      children: [
                        _buildProfileTile(
                            Icons.person, "Nombre", usuarioActual.nombre),
                        _buildProfileTile(Icons.lock, "Contraseña", "********"),
                        _buildProfileTile(
                            Icons.cake, "Edad", usuarioActual.edad.toString()),
                        _buildProfileTile(
                            Icons.location_on,
                            "Lugar de Nacimiento",
                            usuarioActual.lugarNacimiento),
                        _buildProfileTile(
                          usuarioActual.administrador
                              ? Icons.security
                              : Icons.person_outline,
                          "Rol",
                          usuarioActual.administrador
                              ? "Administrador"
                              : "Usuario",
                        ),
                        _buildProfileTile(
                          usuarioActual.bloqueado
                              ? Icons.block
                              : Icons.check_circle,
                          "Estado",
                          usuarioActual.bloqueado ? "Bloqueado" : "Activo",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}
