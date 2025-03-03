import 'package:flutter/material.dart';
import 'package:inicio_sesion/logica/userlogic.dart';
import '../models/user.dart';
import '../commons/images.dart';
import '../commons/validations.dart';
import '../commons/constants.dart';
import '../widgets/formusuario.dart';
import '../commons/dialogs.dart';
import '../providers/UserProvider.dart';

class AdministerManagementPage extends StatefulWidget {
  final User currentAdmin;
  const AdministerManagementPage({super.key, required this.currentAdmin});

  @override
  _AdministerManagementPageState createState() =>
      _AdministerManagementPageState();
}

class _AdministerManagementPageState extends State<AdministerManagementPage> {
  void _bloquearUsuario(BuildContext context, User usuario, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Función de bloqueo aún no implementada")),
    );
  }

  void _editarUsuario(BuildContext context, User usuario, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Función de edición aún no implementada")),
    );
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
                onTratementChanged: (value) =>
                    setDialogState(() => selectedTreatment = value!),
                onImageChanged: (value) =>
                    setDialogState(() => imagePath = value),
                onAdminChanged: (value) =>
                    setDialogState(() => isAdmin = value!),
                onModifiedUser: (user) {},
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validación de campos
                  String? userError =
                      Validations.validateRequired(userController.text);
                  String? passwordError =
                      Validations.validatePassword(passwordController.text);
                  String? ageError =
                      Validations.validateAge(ageController.text);

                  if (userError != null) {
                    Dialogs.showSnackBar(context, userError,
                        color: Constants.errorColor);
                    return;
                  }
                  if (passwordError != null) {
                    Dialogs.showSnackBar(context, passwordError,
                        color: Constants.errorColor);
                    return;
                  }
                  if (ageError != null) {
                    Dialogs.showSnackBar(context, ageError,
                        color: Constants.errorColor);
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  User newUser = User(
                    id: 0,
                    imagen: imagePath ?? Images.getDefaultImage(isAdmin),
                    edad: int.parse(ageController.text),
                    nombre: userController.text,
                    contrasena: passwordController.text,
                    contrasena2: passwordController.text,
                    bloqueado: false,
                    lugarNacimiento: "Madrid",
                    administrador: isAdmin,
                  );
                  var userProvider;
                  await userProvider.anadirUsuario(newUser);

                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(context, "Usuario creado correctamente",
                      color: Constants.successColor);
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
    TextEditingController userController =
        TextEditingController(text: user.nombre);
    TextEditingController passwordController =
        TextEditingController(text: user.contrasena);
    TextEditingController ageController =
        TextEditingController(text: user.edad.toString());
    String selectedTreatment = user.trato;
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
                onTratementChanged: (value) =>
                    setDialogState(() => selectedTreatment = value!),
                onImageChanged: (value) =>
                    setDialogState(() => imagePath = value),
                onAdminChanged: (value) =>
                    setDialogState(() => isAdmin = value!),
                onModifiedUser: (user) {},
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? passwordError =
                      Validations.validatePassword(passwordController.text);
                  String? ageError =
                      Validations.validateAge(ageController.text);

                  if (passwordError != null) {
                    Dialogs.showSnackBar(context, passwordError,
                        color: Constants.errorColor);
                    return;
                  }
                  if (ageError != null) {
                    Dialogs.showSnackBar(context, ageError,
                        color: Constants.errorColor);
                    return;
                  }

                  await Dialogs.showLoadingSpinner(context);

                  user.trato = selectedTreatment;
                  user.pass = passwordController.text;
                  user.edad = int.parse(ageController.text);
                  user.imagen = imagePath ?? '';
                  user.administrador = isAdmin;
                  Logica.updateUser(user);

                  Navigator.pop(dialogContext);
                  setState(() {});
                  Dialogs.showSnackBar(
                      context, "Usuario actualizado correctamente",
                      color: Constants.successColor);
                },
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    List<User> listUsers = userProvider.listarUsuarios
        .where((u) =>
            u.nombre != "admin" && u.nombre != widget.currentAdmin.nombre)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Usuarios"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: listUsers.length,
        itemBuilder: (context, index) {
          User user = listUsers[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: Images.getImageProvider(user.imagen),
                backgroundColor: Colors.grey[200],
              ),
              title: Row(
                children: [
                  userProvider.users.isEmpty
                      ? const Center(
                          child:
                              const Text('No se ha encontrado ningun usuario'))
                      : Text(user.nombre),
                  if (user.administrador) const SizedBox(width: 4),
                  if (user.administrador) Constants.adminBadge,
                ],
              ),
              subtitle: Text("${user.edad} años - ${user.lugarNacimiento}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarUsuario(
                        context, userProvider.users[index], index),
                  ),
                  IconButton(
                    icon: Icon(
                      user.bloqueado ? Icons.lock : Icons.lock_open,
                      color: user.bloqueado ? Colors.red : Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        user.bloqueado = !user.bloqueado;
                        userProvider.actualizarUsuario(user.id, user);
                      });
                      Dialogs.showSnackBar(
                          context,
                          user.bloqueado
                              ? "Usuario bloqueado"
                              : "Usuario desbloqueado",
                          color: user.bloqueado
                              ? Constants.errorColor
                              : Constants.successColor);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool? confirm = await Dialogs.showConfirmDialog(
                          context: context,
                          title: "Confirmar eliminación",
                          content: "¿Está seguro de eliminar a ${user.nombre}?",
                          style: Text(''));

                      if (confirm == true) {
                        await Dialogs.showLoadingSpinner(context);
                        userProvider.deleteUser(user.id);
                        setState(() {});
                        Dialogs.showSnackBar(
                            context, "Usuario eliminado correctamente",
                            color: Constants.successColor);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createUser,
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
