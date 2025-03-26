import 'package:flutter/material.dart';
import 'package:sanchez_web/services/articulo_service.dart';
import 'package:sanchez_web/models/articulo.dart';

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
  final _estatusController = TextEditingController();
  final _imagenController = TextEditingController();

  DateTime? _fechaAlta;
  DateTime? _fechaStock;

  Future<void> _guardarArticulo() async {
    if (_formKey.currentState!.validate() &&
        _fechaAlta != null &&
        _fechaStock != null) {
      final nuevo = Articulo(
        articuloID: '', // Se asigna en el servicio
        cantidad: int.parse(_cantidadController.text),
        descripcion: _descripcionController.text,
        estatus: _estatusController.text,
        fecAlta: _fechaAlta!,
        fecStock: _fechaStock!,
        imagen: _imagenController.text,
        nombre: _nombreController.text,
      );

      await _service.agregarArticulo(nuevo);
      Navigator.pop(context); // Volver a la lista
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esAlta) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (esAlta) {
          _fechaAlta = picked;
        } else {
          _fechaStock = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _cantidadController.dispose();
    _estatusController.dispose();
    _imagenController.dispose();
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
              ),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese la cantidad' : null,
              ),
              TextFormField(
                controller: _estatusController,
                decoration: InputDecoration(labelText: 'Estatus'),
              ),
              TextFormField(
                controller: _imagenController,
                decoration: InputDecoration(labelText: 'URL de Imagen'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(_fechaAlta == null
                    ? 'Seleccionar Fecha de Alta'
                    : 'Alta: ${_fechaAlta!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _seleccionarFecha(context, true),
              ),
              ListTile(
                title: Text(_fechaStock == null
                    ? 'Seleccionar Fecha de Stock'
                    : 'Stock: ${_fechaStock!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _seleccionarFecha(context, false),
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
