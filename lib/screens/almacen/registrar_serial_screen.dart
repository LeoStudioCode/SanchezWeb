import 'package:flutter/material.dart';
import 'package:sanchez_web/models/unidad_almacen.dart';
import 'package:sanchez_web/services/almacen_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearArticuloXUsuarioScreen extends StatefulWidget {
  @override
  _CrearArticuloXUsuarioScreenState createState() =>
      _CrearArticuloXUsuarioScreenState();
}

class _CrearArticuloXUsuarioScreenState
    extends State<CrearArticuloXUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ArticuloXUsuarioService();

  String? _asesorSeleccionado;
  String? _articuloSeleccionado;
  String? _estadoSeleccionado;
  final _noSerieController = TextEditingController();
  final _noActivoController = TextEditingController();
  final _observacionesController = TextEditingController();

  Map<String, String> _usuariosMap = {}; // uid -> nombre
  Map<String, String> _articulosMap = {}; // articuloID -> nombre

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
    _cargarArticulos();
  }

  Future<void> _cargarUsuarios() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _usuariosMap = {
        for (var doc in snapshot.docs) doc.id: doc['name'] ?? 'Sin nombre',
        'Inventario': '📦 Inventario', // Agregar opción Inventario
      };
    });
  }

  Future<void> _cargarArticulos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('articulos').get();
    setState(() {
      _articulosMap = {
        for (var doc in snapshot.docs) doc.id: doc['nombre'] ?? 'Sin nombre'
      };
    });
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final docRef =
          await FirebaseFirestore.instance.collection('articulosXusuario').add({
        'articuloID': _articuloSeleccionado,
        'asesor': _asesorSeleccionado,
        'noSerie': _noSerieController.text,
        'noActivo': _noActivoController.text,
        'estado': _estadoSeleccionado ?? '',
        'observaciones': _observacionesController.text,
        'estatus': 'Activo',
        'fechaAdd': DateTime.now(),
        'fechaUpdate': DateTime.now(),
      });

      // ✅ Agregar el ID generado al campo articulosXusuarioID
      await docRef.update({'articulosXusuarioID': docRef.id});

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asignar Artículo a Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _asesorSeleccionado,
                items: _usuariosMap.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _asesorSeleccionado = v),
                decoration: InputDecoration(labelText: 'Seleccionar Usuario'),
                validator: (v) => v == null ? 'Seleccione un usuario' : null,
              ),
              DropdownButtonFormField<String>(
                value: _articuloSeleccionado,
                items: _articulosMap.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _articuloSeleccionado = v),
                decoration: InputDecoration(labelText: 'Seleccionar Artículo'),
                validator: (v) => v == null ? 'Seleccione un artículo' : null,
              ),
              DropdownButtonFormField<String>(
                value: _estadoSeleccionado,
                items: ['Nuevo', 'Usado']
                    .map((estado) => DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _estadoSeleccionado = v),
                decoration: InputDecoration(labelText: 'Estado del artículo'),
                validator: (v) => v == null ? 'Seleccione el estado' : null,
              ),
              TextFormField(
                controller: _noSerieController,
                decoration: InputDecoration(labelText: 'No. Serie'),
              ),
              TextFormField(
                controller: _noActivoController,
                decoration: InputDecoration(labelText: 'No. Activo'),
              ),
              TextFormField(
                controller: _observacionesController,
                decoration: InputDecoration(labelText: 'Observaciones'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text('Asignar Artículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
