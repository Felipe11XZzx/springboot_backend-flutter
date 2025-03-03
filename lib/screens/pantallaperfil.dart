import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inicio_sesion/models/user.dart';

class ProfilePage extends StatelessWidget {
  final User usuarioActual; // Usuario conectado

  const ProfilePage({super.key, required this.usuarioActual});

  @override
  Widget build(BuildContext context) {
    print("Ruta de la imagen: ${usuarioActual.imagen}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
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
                    backgroundImage: usuarioActual.imagen.isNotEmpty
                        ? (usuarioActual.imagen.startsWith("blob:")
                            ? NetworkImage(usuarioActual.imagen)
                            : FileImage(File(usuarioActual.imagen))
                        ) as ImageProvider
                      : AssetImage('assets/images/profile_default.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    usuarioActual.nombre,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    usuarioActual.trato,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Column(
                      children: [
                        _buildProfileTile(Icons.person, "Nombre", usuarioActual.nombre),
                        _buildProfileTile(Icons.lock, "Contraseña", "********"),
                        _buildProfileTile(Icons.cake, "Edad", usuarioActual.edad.toString()),
                        _buildProfileTile(Icons.location_on, "Lugar de Nacimiento", usuarioActual.lugarNacimiento),
                        _buildProfileTile(
                          usuarioActual.administrador ? Icons.security : Icons.person_outline,
                          "Rol",
                          usuarioActual.administrador ? "Administrador" : "Usuario",
                        ),
                        _buildProfileTile(
                          usuarioActual.bloqueado ? Icons.block : Icons.check_circle,
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
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: TextStyle(fontSize: 16)),
    );
  }
}
