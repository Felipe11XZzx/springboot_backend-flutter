import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/user.dart';
import '../commons/images.dart';
import '../commons/validations.dart';
import '../commons/constants.dart';
import '../widgets/formusuario.dart';
import '../commons/dialogs.dart';
import '../repositories/UserRepository.dart';

class AdministerManagementPage extends StatefulWidget {
  final User currentAdmin;
  const AdministerManagementPage({super.key, required this.currentAdmin});

  @override
  _AdministerManagementPageState createState() => _AdministerManagementPageState();
}

class _AdministerManagementPageState extends State<AdministerManagementPage> {
  final UserRepository _userRepository = UserRepository();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final loadedUsers = await _userRepository.listarUsuarios();
      setState(() {
        users = loadedUsers;
      });
    } catch (e) {
      if (mounted) {
        Dialogs.showSnackBar(context, "Error al cargar usuarios: $e", color: Constants.errorColor);
      }
    }
  }

  Future<void> _bloquearUsuario(BuildContext context, User usuario, int index) async {
    try {
      final updatedUser = User(
        id: usuario.id,
        nombre: usuario.nombre,
        contrasena: usuario.contrasena,
        edad: usuario.edad,
        trato: usuario.trato,
        imagen: usuario.imagen,
        lugarNacimiento: usuario.lugarNacimiento,
        administrador: usuario.administrador,
        bloqueado: !usuario.bloqueado,
      );

      await _userRepository.actualizarUsuario(usuario.id.toString(), updatedUser);
      await _loadUsers();
      
      if (mounted) {
        Dialogs.showSnackBar(
          context, 
          usuario.bloqueado ? "Usuario desbloqueado" : "Usuario bloqueado",
          color: Constants.successColor
        );
      }
    } catch (e) {
      if (mounted) {
        Dialogs.showSnackBar(context, "Error al cambiar estado: $e", color: Constants.errorColor);
      }
    }
  }

  void _createUser() {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    String selectedTreatment = "Sr.";
    String? imagePath;
    bool isAdmin = false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Crear Nuevo Usuario"),
            content: SingleChildScrollView(
              child: FormUsuario(
                isModified: false,
                userController: userController,
                passwordController: passwordController,
                ageController: ageController,
                selectedTratement: selectedTreatment,
                imagenPath: imagePath,
                isAdmin: isAdmin,
                onTratementChanged: (value) => setDialogState(() => selectedTreatment = value!),
                onImageChanged: (value) => setDialogState(() => imagePath = value),
                onAdminChanged: (value) => setDialogState(() => isAdmin = value!),
                onModifiedUser: (user) {},
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validación de campos
                  String? userError = Validations.validateRequired(userController.text);
                  String? passwordError = Validations.validatePassword(passwordController.text);
                  String? ageError = Validations.validateAge(ageController.text);

                  if (userError != null) {
                    Dialogs.showSnackBar(context, userError, color: Constants.errorColor);
                    return;
                  }
                  if (passwordError != null) {
                    Dialogs.showSnackBar(context, passwordError, color: Constants.errorColor);
                    return;
                  }
                  if (ageError != null) {
                    Dialogs.showSnackBar(context, ageError, color: Constants.errorColor);
                    return;
                  }

                  try {
                    await Dialogs.showLoadingSpinner(context);

                    final newUser = User(
                      nombre: userController.text,
                      contrasena: passwordController.text,
                      contrasena2: passwordController.text,
                      edad: int.parse(ageController.text),
                      trato: selectedTreatment,
                      imagen: imagePath ?? Images.getDefaultImage(isAdmin),
                      lugarNacimiento: "Madrid",
                      administrador: isAdmin,
                      bloqueado: false,
                    );

                    await _userRepository.anadirUsuario(newUser);
                    await _loadUsers();
                    
                    Navigator.pop(dialogContext);
                    if (mounted) {
                      Dialogs.showSnackBar(context, "Usuario creado correctamente", color: Constants.successColor);
                    }
                  } catch (e) {
                    if (mounted) {
                      Dialogs.showSnackBar(context, "Error al crear usuario: $e", color: Constants.errorColor);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Crear"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editUser(User user) {
    TextEditingController userController = TextEditingController(text: user.nombre);
    TextEditingController passwordController = TextEditingController(text: user.contrasena);
    TextEditingController ageController = TextEditingController(text: user.edad.toString());
    String selectedTreatment = user.trato ?? "Sr.";
    String? imagePath = user.imagen;
    bool isAdmin = user.administrador;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text("Editar Usuario"),
            content: SingleChildScrollView(
              child: FormUsuario(
                isModified: true,
                userController: userController,
                passwordController: passwordController,
                ageController: ageController,
                selectedTratement: selectedTreatment,
                imagenPath: imagePath,
                isAdmin: isAdmin,
                onTratementChanged: (value) => setDialogState(() => selectedTreatment = value!),
                onImageChanged: (value) => setDialogState(() => imagePath = value),
                onAdminChanged: (value) => setDialogState(() => isAdmin = value!),
                onModifiedUser: (user) {},
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? passwordError = Validations.validatePassword(passwordController.text);
                  String? ageError = Validations.validateAge(ageController.text);

                  if (passwordError != null) {
                    Dialogs.showSnackBar(context, passwordError, color: Constants.errorColor);
                    return;
                  }
                  if (ageError != null) {
                    Dialogs.showSnackBar(context, ageError, color: Constants.errorColor);
                    return;
                  }

                  try {
                    await Dialogs.showLoadingSpinner(context);

                    final updatedUser = User(
                      id: user.id,
                      nombre: user.nombre,
                      contrasena: passwordController.text,
                      edad: int.parse(ageController.text),
                      trato: selectedTreatment,
                      imagen: imagePath,
                      lugarNacimiento: user.lugarNacimiento,
                      administrador: isAdmin,
                      bloqueado: user.bloqueado,
                    );

                    await _userRepository.actualizarUsuario(user.id.toString(), updatedUser);
                    await _loadUsers();

                    Navigator.pop(dialogContext);
                    if (mounted) {
                      Dialogs.showSnackBar(context, "Usuario actualizado correctamente", color: Constants.successColor);
                    }
                  } catch (e) {
                    if (mounted) {
                      Dialogs.showSnackBar(context, "Error al actualizar usuario: $e", color: Constants.errorColor);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Actualizar"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user.imagen != null && user.imagen!.isNotEmpty && !kIsWeb
                  ? FileImage(File(user.imagen!))
                  : null,
              child: user.imagen == null || user.imagen!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(user.nombre),
            subtitle: Text('Edad: ${user.edad}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    user.bloqueado ? Icons.lock : Icons.lock_open,
                    color: user.bloqueado ? Colors.red : Colors.green,
                  ),
                  onPressed: () => _bloquearUsuario(context, user, index),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editUser(user),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createUser,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
