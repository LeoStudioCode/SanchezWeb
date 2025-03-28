import 'package:flutter/material.dart';
import 'package:sanchez_web/models/unidad_almacen.dart';
import 'package:sanchez_web/services/almacen_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanchez_web/screens/almacen/asignar_usuario_screen.dart';
import 'package:sanchez_web/screens/almacen/registrar_serial_screen.dart';

class ArticulosXUsuarioScreen extends StatefulWidget {
  @override
  _ArticulosXUsuarioScreenState createState() =>
      _ArticulosXUsuarioScreenState();
}

class _ArticulosXUsuarioScreenState extends State<ArticulosXUsuarioScreen> {
  final _service = ArticuloXUsuarioService();
  late Future<List<ArticuloXUsuario>> _futureArticulos;

  String _asesorSeleccionado = 'Inventario';
  Map<String, String> _nombresUsuarios = {}; // uid -> nombre
  Map<String, Map<String, String>> _datosArticulo =
      {}; // articuloID -> {nombre, descripcion, imagen}

  @override
  void initState() {
    super.initState();
    _futureArticulos = _service.obtenerTodos();
    _cargarNombresUsuarios();
    _cargarDatosArticulos();
  }

  Future<void> _cargarNombresUsuarios() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    setState(() {
      _nombresUsuarios = {
        for (var doc in snapshot.docs) doc.id: doc['name'] ?? 'Sin nombre'
      };
    });
  }

  Future<void> _cargarDatosArticulos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('articulos').get();

    setState(() {
      _datosArticulo = {
        for (var doc in snapshot.docs)
          doc.id: {
            'nombre': doc['nombre'] ?? '',
            'descripcion': doc['descripcion'] ?? '',
            'imagen': doc['imagen'] ?? ''
          }
      };
    });
  }

  void _confirmarEliminacion(BuildContext context, ArticuloXUsuario articulo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar artículo?'),
        content: Text(
            '¿Estás seguro de eliminar el artículo con No. Serie ${articulo.noSerie}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _service.eliminar(articulo.articulosXusuarioID);
              setState(() {
                _futureArticulos = _service.obtenerTodos();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Artículo eliminado')),
              );
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artículos por Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CrearArticuloXUsuarioScreen(),
                ),
              );
              setState(() {
                _futureArticulos = _service.obtenerTodos();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ArticuloXUsuario>>(
        future: _futureArticulos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final todos = snapshot.data ?? [];

          final activos =
              todos.where((a) => a.estatus.toLowerCase() == 'activo').toList();

          final asesores = activos.map((a) => a.asesor).toSet().toList()
            ..sort();

          final articulosFiltrados =
              activos.where((a) => a.asesor == _asesorSeleccionado).toList();

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: asesores.map((asesor) {
                    final esSeleccionado = asesor == _asesorSeleccionado;
                    final nombreVisible = asesor == 'Inventario'
                        ? '📦 Inventario'
                        : _nombresUsuarios[asesor] ?? asesor;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          nombreVisible,
                          style: TextStyle(
                            color: esSeleccionado ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: esSeleccionado,
                        selectedColor: Colors.blue,
                        onSelected: (_) {
                          setState(() {
                            _asesorSeleccionado = asesor;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Divider(height: 0),
              Expanded(
                child: articulosFiltrados.isEmpty
                    ? Center(child: Text('No hay artículos para este asesor.'))
                    : ListView.builder(
                        itemCount: articulosFiltrados.length,
                        itemBuilder: (context, index) {
                          final a = articulosFiltrados[index];
                          final datos = _datosArticulo[a.articuloID] ?? {};
                          final nombre = datos['nombre'] ?? 'Sin nombre';
                          final descripcion =
                              datos['descripcion'] ?? 'Sin descripción';
                          final imagen = datos['imagen'];

                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: imagen != null && imagen.isNotEmpty
                                  ? Image.network(imagen,
                                      width: 50, height: 50, fit: BoxFit.cover)
                                  : Icon(Icons.inventory, size: 40),
                              title: SelectableText('No. Serie: ${a.noSerie}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText('Nombre: $nombre'),
                                  SelectableText('Descripción: $descripcion'),
                                  SelectableText('Estado: ${a.estado}'),
                                  SelectableText('Activo: ${a.noActivo}'),
                                  if (a.observaciones.isNotEmpty)
                                    SelectableText('Obs: ${a.observaciones}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditarArticuloXUsuarioScreen(
                                                  articulo: a),
                                        ),
                                      );
                                      setState(() {
                                        _futureArticulos =
                                            _service.obtenerTodos();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        _confirmarEliminacion(context, a),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
