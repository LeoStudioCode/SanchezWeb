import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanchez_web/models/unidad_almacen.dart';

class ArticuloXUsuarioService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('articulosXusuario');

  // 🔹 Crear nuevo artículoXusuario
  Future<void> agregar(ArticuloXUsuario articulo) async {
    await _ref.add(articulo.toMap());
  }

  // 🔹 Actualizar artículoXusuario existente
  Future<void> actualizar(String id, Map<String, dynamic> data) async {
    await _ref.doc(id).update(data);
  }

  // 🔹 Eliminar artículoXusuario por ID
  Future<void> eliminar(String id) async {
    await _ref.doc(id).delete();
  }

  // 🔹 Obtener todos (opcional)
  Future<List<ArticuloXUsuario>> obtenerTodos() async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((doc) => ArticuloXUsuario.fromMap(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // 🔹 Obtener por ID (opcional)
  Future<ArticuloXUsuario?> obtenerPorId(String id) async {
    final doc = await _ref.doc(id).get();
    if (doc.exists) {
      return ArticuloXUsuario.fromMap(
          doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
