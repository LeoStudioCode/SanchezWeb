import 'package:flutter/material.dart';
import 'package:sanchez_web/services/articulo_service.dart';
import 'package:sanchez_web/models/articulo.dart';

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
  late TextEditingController _asesorController;
  late TextEditingController _estatusController;
  late TextEditingController _imagenController;

  late DateTime _fechaAlta;
  late DateTime _fechaStock;

  @override
  void initState() {
    super.initState();
    final a = widget.articulo;
    _nombreController = TextEditingController(text: a.nombre);
    _descripcionController = TextEditingController(text: a.descripcion);
    _cantidadController = TextEditingController(text: a.cantidad.toString());
    _estatusController = TextEditingController(text: a.estatus);
    _imagenController = TextEditingController(text: a.imagen);
    _fechaAlta = a.fecAlta;
    _fechaStock = a.fecStock;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _cantidadController.dispose();
    _asesorController.dispose();
    _estatusController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final actualizado = Articulo(
        articuloID: widget.articulo.articuloID,
        cantidad: int.parse(_cantidadController.text),
        descripcion: _descripcionController.text,
        estatus: _estatusController.text,
        fecAlta: _fechaAlta,
        fecStock: _fechaStock,
        imagen: _imagenController.text,
        nombre: _nombreController.text,
      );

      await _service.actualizarArticulo(actualizado);
      Navigator.pop(context);
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esAlta) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: esAlta ? _fechaAlta : _fechaStock,
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
                title: Text(
                    'Alta: ${_fechaAlta.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _seleccionarFecha(context, true),
              ),
              ListTile(
                title: Text(
                    'Stock: ${_fechaStock.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _seleccionarFecha(context, false),
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
