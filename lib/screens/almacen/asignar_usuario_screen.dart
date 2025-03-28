import 'package:flutter/material.dart';
import 'package:sanchez_web/models/unidad_almacen.dart';
import 'package:sanchez_web/services/almacen_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarArticuloXUsuarioScreen extends StatefulWidget {
  final ArticuloXUsuario articulo;

  const EditarArticuloXUsuarioScreen({required this.articulo});

  @override
  _EditarArticuloXUsuarioScreenState createState() =>
      _EditarArticuloXUsuarioScreenState();
}

class _EditarArticuloXUsuarioScreenState
    extends State<EditarArticuloXUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ArticuloXUsuarioService();

  late TextEditingController _noSerieController;
  late TextEditingController _noActivoController;
  late TextEditingController _estadoController;
  late TextEditingController _observacionesController;

  String? _asesorSeleccionado;
  Map<String, String> _usuariosMap = {}; // uid -> nombre

  @override
  void initState() {
    super.initState();
    final a = widget.articulo;
    _noSerieController = TextEditingController(text: a.noSerie);
    _noActivoController = TextEditingController(text: a.noActivo);
    _estadoController = TextEditingController(text: a.estado);
    _observacionesController = TextEditingController(text: a.observaciones);
    _asesorSeleccionado = a.asesor;
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _usuariosMap = {
        for (var doc in snapshot.docs) doc.id: doc['name'] ?? 'Sin nombre',
        'Inventario': '📦 Inventario' // 👈 agregar este valor por defecto
      };
    });
  }

  @override
  void dispose() {
    _noSerieController.dispose();
    _noActivoController.dispose();
    _estadoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final actualizado = widget.articulo;
      final map = actualizado.toMap();

      map['noSerie'] = _noSerieController.text;
      map['noActivo'] = _noActivoController.text;
      map['estado'] = _estadoController.text;
      map['observaciones'] = _observacionesController.text;
      map['asesor'] = _asesorSeleccionado;
      map['fechaUpdate'] = DateTime.now();

      await _service.actualizar(actualizado.articulosXusuarioID, map);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Artículo Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _usuariosMap.containsKey(_asesorSeleccionado)
                    ? _asesorSeleccionado
                    : null,
                items: _usuariosMap.entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _asesorSeleccionado = value),
                decoration: InputDecoration(labelText: 'Asignar a usuario'),
                validator: (value) =>
                    value == null ? 'Seleccione un usuario' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _noSerieController,
                decoration: InputDecoration(labelText: 'No. Serie'),
              ),
              TextFormField(
                controller: _noActivoController,
                decoration: InputDecoration(labelText: 'No. Activo'),
              ),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
              ),
              TextFormField(
                controller: _observacionesController,
                decoration: InputDecoration(labelText: 'Observaciones'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
