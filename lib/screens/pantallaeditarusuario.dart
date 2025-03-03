import 'package:flutter/material.dart';
import 'package:inicio_sesion/models/user.dart';
import 'package:inicio_sesion/logica/userlogic.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class EditionUserPage extends StatefulWidget {
  final User usuario;
  const EditionUserPage ({super.key, required this.usuario});
  @override
  State<EditionUserPage> createState() => _EditionUserPageState();
}

class _EditionUserPageState extends State<EditionUserPage> {
  
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String birthplace = "";
  int _selectedAge = 20;
  String _selectedTitle= 'Sr.';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    birthplace = widget.usuario.lugarNacimiento;
    _selectedAge= widget.usuario.edad;
    _userController= TextEditingController(text:widget.usuario.nombre);
    _passwordController= TextEditingController(text: widget.usuario.contrasena);
    _confirmPasswordController = TextEditingController(text: widget.usuario.contrasena);
   // _selectedTitle= widget.usuario.trato;
    if (widget.usuario.imagen.isNotEmpty){
      _image = File(widget.usuario.imagen);
    }
      

  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateUser(User user) {
  if (_formKey.currentState!.validate()) {
    User updatedUser = User(
      nombre: user.nombre,
      contrasena: _passwordController.text.isEmpty ? user.contrasena : _passwordController.text,
      edad: _selectedAge,      
      imagen: _image?.path ?? user.imagen, 
      lugarNacimiento: birthplace,
    );
    
    Logica.updateUser(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos actualizados')),
    );

    Navigator.pop(context, updatedUser);
  }
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Actualizar datos'),
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
                        onChanged: (value) => setState(() => _selectedTitle = value!),
                      ),
                      Text('Sr.'),
                      Radio<String>(
                        value: 'Sra.',
                        groupValue: _selectedTitle,
                        onChanged: (value) => setState(() => _selectedTitle = value!),
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
                  child: _image == null ? Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _userController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Usuario'),
                validator: (value) => value!.isEmpty ? 'Ingrese un usuario' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Repite Contraseña'),
                validator: (value) => value != _passwordController.text ? 'Las contraseñas no coinciden' : null,
              ),
              SizedBox(height: 10),
              Text('Edad', style: TextStyle(fontSize: 18),),
              NumberPicker(
                value: _selectedAge,
                minValue: 18,
                maxValue: 60,
                onChanged: (value) => setState(() => _selectedAge = value),
                textStyle: TextStyle(fontSize: 10),
                selectedTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar')
        ),
        ElevatedButton(
          onPressed: () => _updateUser(widget.usuario),
          style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 15),
              ),
          child: Text('Actulizar')
        ),
      ],
    );
  }
}