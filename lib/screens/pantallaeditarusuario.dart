import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inicio_sesion/models/user.dart';
import 'package:inicio_sesion/repositories/UserRepository.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class EditionUserPage extends StatefulWidget {
  final User usuario;
  const EditionUserPage({super.key, required this.usuario});
  @override
  State<EditionUserPage> createState() => _EditionUserPageState();
}

class _EditionUserPageState extends State<EditionUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _userRepository = UserRepository();
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String birthplace = "";
  int _selectedAge = 20;
  String _selectedTitle = 'Sr.';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    birthplace = widget.usuario.lugarNacimiento;
    _selectedAge = widget.usuario.edad;
    _userController = TextEditingController(text: widget.usuario.nombre);
    _passwordController =
        TextEditingController(text: widget.usuario.contrasena);
    _confirmPasswordController =
        TextEditingController(text: widget.usuario.contrasena);
    _selectedTitle = widget.usuario.trato ?? 'Sr.';
    if (!kIsWeb && (widget.usuario.imagen?.isNotEmpty ?? false)) {
      _image = File(widget.usuario.imagen!);
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

  Future<void> _updateUser(User user) async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedUser = User(
          id: user.id,
          nombre: user.nombre,
          contrasena: _passwordController.text.isEmpty
              ? user.contrasena
              : _passwordController.text,
          edad: _selectedAge,
          imagen: _image?.path ?? user.imagen,
          lugarNacimiento: birthplace,
          trato: _selectedTitle,
          administrador: user.administrador,
          bloqueado: user.bloqueado,
        );

        await _userRepository.actualizarUsuario(
            user.id.toString(), updatedUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos actualizados')),
          );
          Navigator.pop(context, updatedUser);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Actualizar datos'),
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
                      const Text('Sr.'),
                      Radio<String>(
                        value: 'Sra.',
                        groupValue: _selectedTitle,
                        onChanged: (value) =>
                            setState(() => _selectedTitle = value!),
                      ),
                      const Text('Sra.'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _image != null && !kIsWeb ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _userController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un usuario' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) => value!.isNotEmpty && value.length < 6
                    ? 'Mínimo 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Repite Contraseña'),
                validator: (value) => _passwordController.text.isNotEmpty &&
                        value != _passwordController.text
                    ? 'Las contraseñas no coinciden'
                    : null,
              ),
              const SizedBox(height: 10),
              const Text('Edad', style: TextStyle(fontSize: 18)),
              NumberPicker(
                value: _selectedAge,
                minValue: 18,
                maxValue: 60,
                onChanged: (value) => setState(() => _selectedAge = value),
                textStyle: const TextStyle(fontSize: 10),
                selectedTextStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        ElevatedButton(
            onPressed: () => _updateUser(widget.usuario),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              textStyle: const TextStyle(fontSize: 15),
            ),
            child: const Text('Actualizar')),
      ],
    );
  }
}
