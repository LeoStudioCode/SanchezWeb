import 'package:flutter/material.dart';
import 'package:sanchez_web/services/articulo_service.dart';
import 'package:sanchez_web/models/articulo.dart';
import 'editar_articulo_screen.dart';
import 'agregar_articulo_screen.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  final ArticuloService _articuloService = ArticuloService();
  late Future<List<Articulo>> _articulosFuture;

  @override
  void initState() {
    super.initState();
    _cargarArticulos();
  }

  void _cargarArticulos() {
    setState(() {
      _articulosFuture = _articuloService.obtenerArticulos();
    });
  }

  void _eliminarArticulo(String id) async {
    await _articuloService.eliminarArticulo(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Artículo eliminado')),
    );
    _cargarArticulos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca de Artículos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AgregarArticuloScreen()),
              );
              _cargarArticulos();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Articulo>>(
        future: _articulosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: SelectableText(
                'Error al cargar artículos:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: SelectableText('No hay artículos'));
          }

          final articulos = snapshot.data!;

          return ListView.builder(
            itemCount: articulos.length,
            itemBuilder: (context, index) {
              final articulo = articulos[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 300,
                            height: 300,
                            color: Colors.grey[200],
                            child: Image.network(
                              articulo.imagen,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/default_image.png',
                                  fit: BoxFit.contain,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        articulo.nombre,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      SelectableText(
                        articulo.descripcion,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      SelectableText(
                        'Cantidad: ${articulo.cantidad}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditarArticuloScreen(articulo: articulo),
                                ),
                              );
                              _cargarArticulos();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmarEliminacion(context, articulo),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, Articulo articulo) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: SelectableText('¿Eliminar artículo?'),
        content:
            SelectableText('¿Estás seguro de eliminar "${articulo.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _eliminarArticulo(articulo.articuloID);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
