import 'package:flutter/material.dart';

class DrawerPrincipal extends StatelessWidget {
  final VoidCallback onPantallaPrincipal;
  final VoidCallback? onMiPerfil;
  final VoidCallback onSalir;

  const DrawerPrincipal({
    super.key,
    required this.onPantallaPrincipal,
    this.onMiPerfil,
    required this.onSalir,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 213, 223, 228),
            ),
            child: Image.asset('assets/images/logo_coldman.png'),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: const Text('Pantalla principal',
                style: TextStyle(color: Colors.black)),
            onTap: onPantallaPrincipal,
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title:
                const Text('Mi perfil', style: TextStyle(color: Colors.black)),
            onTap: onMiPerfil,
          ),
          ListTile(
            leading: Icon(Icons.login, color: Colors.black),
            title: const Text('Salir', style: TextStyle(color: Colors.black)),
            onTap: onSalir,
          ),
        ],
      ),
    );
  }
}
