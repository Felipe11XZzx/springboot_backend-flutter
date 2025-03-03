import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inicio_sesion/screens/pantallacompras.dart';
import 'package:inicio_sesion/screens/pantallapedidos.dart';
import 'package:inicio_sesion/screens/pantallayo.dart';
import 'package:inicio_sesion/widgets/drawer.dart';
import '../screens/pantallaprincipal.dart';
import '../models/user.dart';
import '../widgets/bottomnavigationbar.dart';
import '../screens/pantallaperfil.dart';


class MyStartedPage extends StatefulWidget {
  final User user;
  const MyStartedPage ({super.key, required this.user});
  @override
  _MyStartedPageState createState() => _MyStartedPageState();
}

class _MyStartedPageState extends State<MyStartedPage> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  void pantallaPrincipal() {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Pantalla Principal')),
    );
  }

  void miPerfil () {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => ProfilePage(usuarioActual: widget.user)),
    );
  }

  void salir(){
    exit(0);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex=index;
    });
  }
  
  @override
  void initState() {
    super.initState();
    pages = [
      ShoppingPage(usuario: widget.user),
      OrdersPage(usuario: widget.user),
      IPage(usuario: widget.user, onTabChange: onItemTapped)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Bienvenido ${widget.user.nombre}"),
      ),
      drawer: DrawerPrincipal(
        onPantallaPrincipal: pantallaPrincipal,
        onMiPerfil: miPerfil,
        onSalir: salir,
      ),
      body: pages [selectedIndex],
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped
      ),
    );
  }
}