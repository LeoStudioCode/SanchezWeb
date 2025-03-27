import 'package:cloud_firestore/cloud_firestore.dart';

class ArticuloXUsuario {
  String articulosXusuarioID;
  String articuloID;
  String asesor;
  String estado;
  String estatus;
  DateTime fechaAdd;
  DateTime fechaUpdate;
  String noActivo;
  String noSerie;
  String observaciones;

  ArticuloXUsuario({
    required this.articulosXusuarioID,
    required this.articuloID,
    required this.asesor,
    required this.estado,
    required this.estatus,
    required this.fechaAdd,
    required this.fechaUpdate,
    required this.noActivo,
    required this.noSerie,
    required this.observaciones,
  });

  factory ArticuloXUsuario.fromMap(Map<String, dynamic> map, String docId) {
    return ArticuloXUsuario(
      articulosXusuarioID: docId,
      articuloID: map['articuloID'] ?? '',
      asesor: map['asesor'] ?? '',
      estado: map['estado'] ?? '',
      estatus: map['estatus'] ?? '',
      fechaAdd: _toDate(map['fechaAdd']),
      fechaUpdate: _toDate(map['fechaUpdate']),
      noActivo: map['noActivo'] ?? '',
      noSerie: map['noSerie'] ?? '',
      observaciones: map['observaciones'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articuloID': articuloID,
      'asesor': asesor,
      'estado': estado,
      'estatus': estatus,
      'fechaAdd': fechaAdd,
      'fechaUpdate': fechaUpdate,
      'noActivo': noActivo,
      'noSerie': noSerie,
      'observaciones': observaciones,
    };
  }

  static DateTime _toDate(dynamic value) {
    if (value == null) {
      return DateTime(2000); // o DateTime.now(), según lo que prefieras
    }
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    throw Exception('Formato de fecha inválido: $value');
  }
}
