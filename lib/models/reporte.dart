import 'package:cloud_firestore/cloud_firestore.dart';

class Folio {
  final String asesor;
  final String centro;
  final Timestamp? fecAlta;
  final String fecFolio;
  final Timestamp? fecInstalado;
  final String folioID;
  final String instalado;
  final String numFolio;
  final String problema;
  final String retirado;

  Folio({
    required this.asesor,
    required this.centro,
    required this.fecAlta,
    required this.fecFolio,
    required this.fecInstalado,
    required this.folioID,
    required this.instalado,
    required this.numFolio,
    required this.problema,
    required this.retirado,
  });

  factory Folio.fromMap(Map<String, dynamic> map) {
    return Folio(
      asesor: map['asesor'],
      centro: map['centro'],
      fecAlta: map['fecAlta'] != null ? map['fecAlta'] as Timestamp : null,
      fecFolio: map['fecFolio'] as String,
      fecInstalado:
          map['fecInstalado'] != null ? map['fecInstalado'] as Timestamp : null,
      folioID: map['folioID'],
      instalado: map['instalado'],
      numFolio: map['numFolio'],
      problema: map['problema'],
      retirado: map['retirado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'asesor': asesor,
      'centro': centro,
      'fecAlta': fecAlta,
      'fecFolio': fecFolio,
      'fecInstalado': fecInstalado,
      'folioID': folioID,
      'instalado': instalado,
      'numFolio': numFolio,
      'problema': problema,
      'retirado': retirado,
    };
  }

  String formatTimestamp(Timestamp? timestamp) {
    return timestamp?.toDate().toString() ?? 'N/A';
  }
}

class Instalado {
  final List<String> articulosXusuarioID;
  final String asesor;
  final String centro;
  final Timestamp fecha;
  final String folioID;
  final List<String> imagenes;
  final String instaladosID;
  final String observaciones;

  Instalado({
    required this.articulosXusuarioID,
    required this.asesor,
    required this.centro,
    required this.fecha,
    required this.folioID,
    required this.imagenes,
    required this.instaladosID,
    required this.observaciones,
  });

  factory Instalado.fromMap(Map<String, dynamic> map) {
    return Instalado(
      articulosXusuarioID: List<String>.from(map['articulosXusuarioID']),
      asesor: map['asesor'],
      centro: map['centro'],
      fecha: map['fecha'],
      folioID: map['folioID'],
      imagenes: List<String>.from(map['imagenes']),
      instaladosID: map['instaladosID'],
      observaciones: map['observaciones'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articulosXusuarioID': articulosXusuarioID,
      'asesor': asesor,
      'centro': centro,
      'fecha': fecha,
      'folioID': folioID,
      'imagenes': imagenes,
      'instaladosID': instaladosID,
      'observaciones': observaciones,
    };
  }

  String formatTimestamp(Timestamp timestamp) {
    return timestamp.toDate().toString();
  }
}

class Retirado {
  final List<String> articuloXusuarioID;
  final String asesor;
  final String centro;
  final Timestamp fechaRetiro;
  final String folioID;
  final List<String> imagenes; // Añade la lista de imágenes
  final String observaciones;
  final String retiradoID;

  Retirado({
    required this.articuloXusuarioID,
    required this.asesor,
    required this.centro,
    required this.fechaRetiro,
    required this.folioID,
    required this.imagenes, // Inicializa la lista de imágenes
    required this.observaciones,
    required this.retiradoID,
  });

  factory Retirado.fromMap(Map<String, dynamic> map) {
    return Retirado(
      articuloXusuarioID: List<String>.from(map['articuloXusuarioID'] ?? []),
      asesor: map['asesor'] ?? 'N/A',
      centro: map['centro'] ?? 'N/A',
      fechaRetiro: map['fechaRetiro'],
      folioID: map['folioID'] ?? 'N/A',
      imagenes: List<String>.from(map['imagenes'] ?? []), // Maneja null
      observaciones: map['observaciones'] ?? 'N/A',
      retiradoID: map['retiradoID'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articuloXusuarioID': articuloXusuarioID,
      'asesor': asesor,
      'centro': centro,
      'fechaRetiro': fechaRetiro,
      'folioID': folioID,
      'imagenes': imagenes, // Incluye la lista de imágenes
      'observaciones': observaciones,
      'retiradoID': retiradoID,
    };
  }

  String formatTimestamp(Timestamp timestamp) {
    return timestamp.toDate().toString();
  }
}

class UnifiedModel {
  final String? asesor;
  final String? centro;
  final Timestamp? fecha;
  final String? folioID;
  final String? observaciones;
  final List<String>? imagenes;
  final String? tipo; // Para identificar el tipo de registro

  UnifiedModel({
    this.asesor,
    this.centro,
    this.fecha,
    this.folioID,
    this.observaciones,
    this.imagenes,
    this.tipo,
  });

  factory UnifiedModel.fromFolio(Folio folio) {
    return UnifiedModel(
      asesor: folio.asesor,
      centro: folio.centro,
      fecha: folio.fecAlta,
      folioID: folio.folioID,
      observaciones: folio.problema,
      imagenes: [],
      tipo: 'Folio',
    );
  }

  factory UnifiedModel.fromInstalado(Instalado instalado) {
    return UnifiedModel(
      asesor: instalado.asesor,
      centro: instalado.centro,
      fecha: instalado.fecha,
      folioID: instalado.folioID,
      observaciones: instalado.observaciones,
      imagenes: instalado.imagenes,
      tipo: 'Instalado',
    );
  }

  factory UnifiedModel.fromRetirado(Retirado retirado) {
    return UnifiedModel(
      asesor: retirado.asesor,
      centro: retirado.centro,
      fecha: retirado.fechaRetiro,
      folioID: retirado.folioID,
      observaciones: retirado.observaciones,
      imagenes: retirado.imagenes,
      tipo: 'Retirado',
    );
  }

  String formatTimestamp(Timestamp? timestamp) {
    return timestamp?.toDate().toString() ?? 'N/A';
  }
}
