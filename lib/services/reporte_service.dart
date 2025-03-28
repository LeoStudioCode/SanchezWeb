import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reporte.dart';

class ReporteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Folio>> getFolios() {
    return _db.collection('folios').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Folio.fromMap(doc.data())).toList();
    });
  }

  Stream<List<Instalado>> getInstalados() {
    return _db.collection('instalado').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Instalado.fromMap(doc.data())).toList();
    });
  }

  Stream<List<Retirado>> getRetirados() {
    return _db.collection('retirado').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Retirado.fromMap(doc.data())).toList();
    });
  }
}
