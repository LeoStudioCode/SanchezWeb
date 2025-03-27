import 'package:flutter/material.dart';
import 'package:sanchez_web/services/articulo_service.dart';
import 'package:sanchez_web/models/articulo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class EditarArticuloScreen extends StatefulWidget {
  final Articulo articulo;

  const EditarArticuloScreen({required this.articulo});

  @override
  _EditarArticuloScreenState createState() => _EditarArticuloScreenState();
}

class _EditarArticuloScreenState extends State<EditarArticuloScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ArticuloService();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _cantidadController;
  late String _estatus;
  String? _imagenUrl;

  late DateTime _fechaAlta;
  late DateTime _fechaStock;

  @override
  void initState() {
    super.initState();
    final a = widget.articulo;
    _nombreController = TextEditingController(text: a.nombre);
    _descripcionController = TextEditingController(text: a.descripcion);
    _cantidadController = TextEditingController(text: a.cantidad.toString());
    _estatus = a.estatus;
    _imagenUrl = a.imagen;
    _fechaAlta = a.fecAlta;
    _fechaStock = a.fecStock;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _subirImagen() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // importante para WEB
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = result.files.single.name;

        final storageRef =
            FirebaseStorage.instance.ref().child('articulos/$fileName');
        await storageRef.putData(fileBytes);

        final downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          _imagenUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Imagen cargada correctamente")),
        );
      }
    } catch (e) {
      debugPrint('🔥 Error al subir imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al subir imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final actualizado = Articulo(
        articuloID: widget.articulo.articuloID,
        cantidad: int.parse(_cantidadController.text),
        descripcion: _descripcionController.text,
        estatus: _estatus,
        fecAlta: _fechaAlta,
        fecStock: _fechaStock,
        imagen: _imagenUrl ?? '',
        nombre: _nombreController.text,
      );

      // Guardar campo fecUpdate
      final map = actualizado.toMap();
      map['fecUpdate'] = DateTime.now();

      await _service.actualizarArticuloConMap(widget.articulo.articuloID, map);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Artículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el nombre' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la cantidad' : null,
              ),
              DropdownButtonFormField<String>(
                value: _estatus,
                decoration: InputDecoration(labelText: 'Estatus'),
                items: ['Activo', 'Inactivo']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _estatus = value);
                },
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _subirImagen,
                    child: Text('Subir Imagen'),
                  ),
                  SizedBox(width: 10),
                  _imagenUrl != null
                      ? Expanded(child: Text('Imagen cargada'))
                      : SizedBox(),
                ],
              ),
              if (_imagenUrl != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(_imagenUrl!, height: 100),
                ),
              SizedBox(height: 10),
              Text('Alta: ${_fechaAlta.toLocal().toString().split(' ')[0]}'),
              Text('Stock: ${_fechaStock.toLocal().toString().split(' ')[0]}'),
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
