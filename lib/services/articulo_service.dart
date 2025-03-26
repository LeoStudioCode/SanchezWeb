import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanchez_web/models/articulo.dart'; // Asegúrate de tener el modelo Articulo importado correctamente

class ArticuloService {
  final CollectionReference _articulosRef =
      FirebaseFirestore.instance.collection('articulos');

  // 🔹 Crear nuevo artículo
  Future<void> agregarArticulo(Articulo articulo) async {
    try {
      final docRef = await _articulosRef.add(articulo.toMap());
      await _articulosRef.doc(docRef.id).update({'articuloID': docRef.id});
    } catch (e) {
      throw Exception('Error al agregar artículo: $e');
    }
  }

  // 🔹 Actualizar artículo
  Future<void> actualizarArticulo(Articulo articulo) async {
    try {
      await _articulosRef.doc(articulo.articuloID).update(articulo.toMap());
    } catch (e) {
      throw Exception('Error al actualizar artículo: $e');
    }
  }

  // 🔹 Eliminar artículo
  Future<void> eliminarArticulo(String articuloID) async {
    try {
      await _articulosRef.doc(articuloID).delete();
    } catch (e) {
      throw Exception('Error al eliminar artículo: $e');
    }
  }

  // 🔹 Obtener todos los artículos
  Future<List<Articulo>> obtenerArticulos() async {
    try {
      final snapshot = await _articulosRef.get();
      return snapshot.docs.map((doc) {
        return Articulo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener artículos: $e');
    }
  }
}
