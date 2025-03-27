import 'package:flutter/material.dart';
import 'package:sanchez_web/services/articulo_service.dart';
import 'package:sanchez_web/models/articulo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class AgregarArticuloScreen extends StatefulWidget {
  @override
  _AgregarArticuloScreenState createState() => _AgregarArticuloScreenState();
}

class _AgregarArticuloScreenState extends State<AgregarArticuloScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ArticuloService();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _cantidadController = TextEditingController();
  String _imagenUrl = '';
  DateTime? _fechaStock;

  Future<void> _subirImagen() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final Uint8List fileBytes = result.files.single.bytes!;
      final String fileName = result.files.single.name;

      final ref = FirebaseStorage.instance.ref('articulos/$fileName');
      await ref.putData(fileBytes);
      final url = await ref.getDownloadURL();

      setState(() {
        _imagenUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen subida correctamente')),
      );
    }
  }

  Future<void> _guardarArticulo() async {
    if (_formKey.currentState!.validate() && _fechaStock != null) {
      final nuevo = Articulo(
        articuloID: '',
        cantidad: int.parse(_cantidadController.text),
        descripcion: _descripcionController.text,
        estatus: 'Activo',
        fecAlta: DateTime.now(),
        fecStock: _fechaStock!,
        imagen: _imagenUrl,
        nombre: _nombreController.text,
      );

      await _service.agregarArticulo(nuevo);
      Navigator.pop(context);
    }
  }

  Future<void> _seleccionarFechaStock(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fechaStock = picked;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Artículo')),
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
                maxLines: 4,
              ),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la cantidad' : null,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _subirImagen,
                    child: Text('Subir Imagen'),
                  ),
                  SizedBox(width: 10),
                  _imagenUrl.isNotEmpty
                      ? Expanded(child: Text('Imagen cargada'))
                      : SizedBox(),
                ],
              ),
              if (_imagenUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(_imagenUrl, height: 100),
                ),
              SizedBox(height: 10),
              ListTile(
                title: Text(_fechaStock == null
                    ? 'Seleccionar Fecha de Stock'
                    : 'Stock: ${_fechaStock!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _seleccionarFechaStock(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarArticulo,
                child: Text('Guardar Artículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
