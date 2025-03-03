import 'package:flutter/material.dart';
import 'package:inicio_sesion/commons/custombutton.dart';
import 'package:inicio_sesion/screens/pantallacontacto.dart';
import 'package:inicio_sesion/screens/pantallaeditarusuario.dart';
import '../models/user.dart';


class IPage extends StatefulWidget {
  final User usuario;
  final Function(int) onTabChange;

  const IPage({
    super.key,
    required this.usuario,
    required this.onTabChange,
  });

  @override
  State<IPage> createState() => _IPageState();
}

class _IPageState extends State<IPage> {
  late User currentUser;


  @override
  void initState() {
    super.initState();
    currentUser=widget.usuario;
  }

  void openContact (){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> ContactPage())
    );
  }

  void openUpdate () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> EditionUserPage(usuario: currentUser))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFE3F2FD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomEButton(
              text: "Contacto",
              myFunction: openContact,
              icon:Icons.contact_page,
            ),
            const SizedBox(height: 16),
            CustomEButton(
              text: "Editar usuario",
              myFunction: () async {
                final updatedUser = await Navigator.push<User>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    EditionUserPage(usuario: currentUser)
                  ),
                );
                if (updatedUser != null) {
                  setState(() {
                    currentUser = updatedUser;
                  });
                }
              },
              icon:Icons.edit,
            ),
          ],
        ),
      ),
    );
  }
}
