import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class UsuarioService {
  final FirebaseFirestore _firestore;

  UsuarioService(this._firestore);

  // Método para agregar un usuario a Firestore
  Future<void> addUsuario(Usuario usuario) async {
    try {
      await _firestore
          .collection('users')
          .doc(usuario.uid)
          .set(usuario.toMap());
    } catch (e) {
      print('Error al agregar usuario: $e');
      rethrow;
    }
  }

  // Método para editar un usuario en Firestore
  Future<void> updateUsuario(Usuario usuario) async {
    try {
      await _firestore
          .collection('users')
          .doc(usuario.uid)
          .update(usuario.toMap());
    } catch (e) {
      print('Error al editar usuario: $e');
      rethrow;
    }
  }

  // Método para eliminar un usuario de Firestore
  Future<void> deleteUsuario(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error al eliminar usuario: $e');
      rethrow;
    }
  }

  // Método para obtener un usuario por su UID
  Future<Usuario?> getUsuarioByUid(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return Usuario.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener usuario: $e');
      rethrow;
    }
  }

  // Método para obtener todos los usuarios
  Stream<List<Usuario>> getUsuarios() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Usuario.fromMap(doc.data())).toList();
    });
  }
}
