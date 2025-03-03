import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inicio_sesion/models/user.dart';
import 'package:inicio_sesion/logica/userlogic.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import '../commons/snacksbar.dart';
import '../commons/constants.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key});
  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthplaceController = TextEditingController();
  int _selectedAge = 20;
  String _selectedTitle = 'Sr.';
  File? _image;
  bool _acceptTerms = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = kIsWeb ? null : File(pickedFile.path);
        //_image = File(pickedFile.path);
      });
      print("Imagen seleccionada: ${pickedFile.path}");
      
    }
  }

  void _registerUser() {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      Logica.aniadirUser(User(
          id: ,
          nombre: _userController.text,
          contrasena: _passwordController.text,
          edad: _selectedAge,
          imagen: _image?.path ?? '',
          bloqueado: false,
          lugarNacimiento: _birthplaceController.text));
      SnaksBar.showSnackBar(context, "Usuario registrado exitosamente",
            color: Constants.successColor);
      Navigator.pop(context);
    } else if (_formKey.currentState!.validate() && !_acceptTerms) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(''),
                content: Text('Debes aceptar los términos y condiciones'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Volver')),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registro de Usuario'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'Sr.',
                        groupValue: _selectedTitle,
                        onChanged: (value) =>
                            setState(() => _selectedTitle = value!),
                      ),
                      Text('Sr.'),
                      Radio<String>(
                        value: 'Sra.',
                        groupValue: _selectedTitle,
                        onChanged: (value) =>
                            setState(() => _selectedTitle = value!),
                      ),
                      Text('Sra.'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child:
                      _image == null ? Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _userController,
                decoration: InputDecoration(labelText: 'Usuario'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un usuario' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) =>
                    value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Repite Contraseña'),
                validator: (value) => value != _passwordController.text
                    ? 'Las contraseñas no coinciden'
                    : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: 'Zaragoza',
                decoration: InputDecoration(labelText: 'Lugar de Nacimiento'),
                items: [
                  'A Coruña',
                  'Albacete',
                  'Alicante',
                  'Almería',
                  'Ávila',
                  'Badajoz',
                  'Barcelona',
                  'Bilbao',
                  'Burgos',
                  'Cáceres',
                  'Cádiz',
                  'Castellón',
                  'Ciudad Real',
                  'Córdoba',
                  'Cuenca',
                  'Girona',
                  'Granada',
                  'Guadalajara',
                  'Huelva',
                  'Huesca',
                  'Jaén',
                  'La Rioja',
                  'Las Palmas',
                  'León',
                  'Lleida',
                  'Lugo',
                  'Madrid',
                  'Málaga',
                  'Murcia',
                  'Ourense',
                  'Oviedo',
                  'Palencia',
                  'Pamplona',
                  'Pontevedra',
                  'Salamanca',
                  'San Sebastián',
                  'Santander',
                  'Segovia',
                  'Sevilla',
                  'Soria',
                  'Tarragona',
                  'Teruel',
                  'Toledo',
                  'Valencia',
                  'Valladolid',
                  'Vitoria',
                  'Zamora',
                  'Zaragoza'
                ].map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (value) =>
                    setState(() => _birthplaceController.text = value!),
              ),
              SizedBox(height: 10),
              Text(
                'Edad',
                style: TextStyle(fontSize: 18),
              ),
              NumberPicker(
                value: _selectedAge,
                minValue: 18,
                maxValue: 60,
                onChanged: (value) => setState(() => _selectedAge = value),
                textStyle: TextStyle(fontSize: 10),
                selectedTextStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) => setState(() => _acceptTerms = value!),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                      child: Text('Acepto los términos y condiciones',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        ElevatedButton(
          onPressed: _registerUser,
          style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 15),
              ),
          child: Text('Registrar')
        ),
      ],
    );
  }
}
