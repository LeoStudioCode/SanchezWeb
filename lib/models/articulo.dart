import 'package:cloud_firestore/cloud_firestore.dart';

class Articulo {
  String articuloID;
  int cantidad;
  String descripcion;
  String estatus;
  DateTime fecAlta;
  DateTime fecStock;
  String imagen;
  String nombre;

  Articulo({
    required this.articuloID,
    required this.cantidad,
    required this.descripcion,
    required this.estatus,
    required this.fecAlta,
    required this.fecStock,
    required this.imagen,
    required this.nombre,
  });

  factory Articulo.fromMap(Map<String, dynamic> map, String docId) {
    return Articulo(
      articuloID: docId,
      cantidad: map['cantidad'] ?? 0,
      descripcion: map['descripcion'] ?? '',
      estatus: map['estatus'] ?? '',
      fecAlta: _toDate(map['fecAlta']),
      fecStock: _toDate(map['fecStock']),
      imagen: map['imagen'] ?? '',
      nombre: map['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cantidad': cantidad,
      'descripcion': descripcion,
      'estatus': estatus,
      'fecAlta': fecAlta.toIso8601String(),
      'fecStock': fecStock.toIso8601String(),
      'imagen': imagen,
      'nombre': nombre,
    };
  }
}

// Helper para manejar Timestamp o String
DateTime _toDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  throw Exception('Formato de fecha inválido: $value');
}
