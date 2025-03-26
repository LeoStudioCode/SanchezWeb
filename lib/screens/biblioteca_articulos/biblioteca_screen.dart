import 'package:flutter/material.dart';
import 'package:sanchez_web/services/articulo_service.dart';
import 'package:sanchez_web/models/articulo.dart';
import 'editar_articulo_screen.dart'; // Asegúrate de crear esta pantalla
import 'agregar_articulo_screen.dart'; // Asegúrate de crear esta también

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
              _cargarArticulos(); // Refresh on return
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
              child: Text(
                'Error al cargar artículos:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay artículos'));
          }

          final articulos = snapshot.data!;

          return ListView.builder(
            itemCount: articulos.length,
            itemBuilder: (context, index) {
              final articulo = articulos[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 150, // Puedes subir más si quieres aún más grande
                      height: 200,
                      color: Colors.grey[
                          200], // Fondo para relleno si la imagen no llena
                      child: Image.network(
                        articulo.imagen,
                        fit: BoxFit
                            .fill, // Mostrar la imagen completa sin recortarla
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'images/default_image.png',
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(articulo.nombre),
                  subtitle: Text(
                      '${articulo.descripcion}\nCantidad: ${articulo.cantidad}'),
                  isThreeLine: true,
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
                                  EditarArticuloScreen(articulo: articulo),
                            ),
                          );
                          _cargarArticulos(); // Refresh
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmarEliminacion(context, articulo),
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
        title: Text('¿Eliminar artículo?'),
        content: Text('¿Estás seguro de eliminar "${articulo.nombre}"?'),
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
