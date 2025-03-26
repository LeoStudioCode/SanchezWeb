import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario.dart';
import '../../services/usuario_service.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Usuario usuario;

  EditarUsuarioScreen({required this.usuario});

  @override
  _EditarUsuarioScreenState createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService(FirebaseFirestore.instance);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nominaController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.usuario.name;
    _emailController.text = widget.usuario.email;
    _nominaController.text = widget.usuario.nomina;
    _rolController.text = widget.usuario.rol;
    _telefonoController.text = widget.usuario.telefono;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un correo electrónico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nominaController,
                decoration: InputDecoration(labelText: 'Nómina'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una nómina';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rolController,
                decoration: InputDecoration(labelText: 'Rol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un rol';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _editarUsuario();
                  }
                },
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editarUsuario() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String nomina = _nominaController.text;
    final String rol = _rolController.text;
    final String telefono = _telefonoController.text;

    final updatedUsuario = Usuario(
      uid: widget.usuario.uid,
      name: name,
      email: email,
      nomina: nomina,
      rol: rol,
      telefono: telefono,
    );

    try {
      await _usuarioService.updateUsuario(updatedUsuario);
      Navigator.pop(context); // Cierra el formulario después de editar
    } catch (e) {
      print('Error al editar usuario: $e');
    }
  }
}
