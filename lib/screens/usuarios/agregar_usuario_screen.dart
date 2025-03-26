import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario.dart';
import '../../services/usuario_service.dart';

class AgregarUsuarioScreen extends StatefulWidget {
  @override
  _AgregarUsuarioScreenState createState() => _AgregarUsuarioScreenState();
}

class _AgregarUsuarioScreenState extends State<AgregarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService(FirebaseFirestore.instance);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nominaController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Usuario'),
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
                    _agregarUsuario();
                  }
                },
                child: Text('Agregar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarUsuario() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String nomina = _nominaController.text;
    final String rol = _rolController.text;
    final String telefono = _telefonoController.text;

    final newUsuario = Usuario(
      uid: DateTime.now().toString(), // Puedes generar un UID único aquí
      name: name,
      email: email,
      nomina: nomina,
      rol: rol,
      telefono: telefono,
    );

    try {
      await _usuarioService.addUsuario(newUsuario);
      Navigator.pop(context); // Cierra el formulario después de agregar
    } catch (e) {
      print('Error al agregar usuario: $e');
    }
  }
}
