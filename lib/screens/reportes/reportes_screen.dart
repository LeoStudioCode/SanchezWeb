import 'package:flutter/material.dart';
import '../../services/reporte_service.dart';
import '../../models/reporte.dart';

class ReportesScreen extends StatelessWidget {
  final ReporteService _reporteService = ReporteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFoliosTable(),
            _buildInstaladosTable(),
            _buildRetiradosTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoliosTable() {
    return StreamBuilder<List<Folio>>(
      stream: _reporteService.getFolios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay datos disponibles'));
        } else {
          final folios = snapshot.data!;
          return DataTable(
            columns: [
              DataColumn(label: Text('Asesor')),
              DataColumn(label: Text('Centro')),
              DataColumn(label: Text('Fecha Alta')),
              DataColumn(label: Text('Fecha Folio')),
              DataColumn(label: Text('Fecha Instalado')),
              DataColumn(label: Text('Folio ID')),
              DataColumn(label: Text('Instalado')),
              DataColumn(label: Text('Número Folio')),
              DataColumn(label: Text('Problema')),
              DataColumn(label: Text('Retirado')),
            ],
            rows: folios.map((folio) {
              return DataRow(
                cells: [
                  DataCell(Text(folio.asesor)),
                  DataCell(Text(folio.centro)),
                  DataCell(Text(folio.formatTimestamp(folio.fecAlta))),
                  DataCell(Text(folio.fecFolio)),
                  DataCell(Text(folio.formatTimestamp(folio.fecInstalado))),
                  DataCell(Text(folio.folioID)),
                  DataCell(Text(folio.instalado)),
                  DataCell(Text(folio.numFolio)),
                  DataCell(Text(folio.problema)),
                  DataCell(Text(folio.retirado)),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildInstaladosTable() {
    return StreamBuilder<List<Instalado>>(
      stream: _reporteService.getInstalados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay datos disponibles'));
        } else {
          final instalados = snapshot.data!;
          return DataTable(
            columns: [
              DataColumn(label: Text('Asesor')),
              DataColumn(label: Text('Centro')),
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Folio ID')),
              DataColumn(label: Text('Observaciones')),
              DataColumn(label: Text('Imágenes')),
            ],
            rows: instalados.map((instalado) {
              return DataRow(
                cells: [
                  DataCell(Text(instalado.asesor)),
                  DataCell(Text(instalado.centro)),
                  DataCell(Text(instalado.formatTimestamp(instalado.fecha))),
                  DataCell(Text(instalado.folioID)),
                  DataCell(Text(instalado.observaciones)),
                  DataCell(
                    Row(
                      children: instalado.imagenes
                          .map((url) => _buildImageCell(url))
                          .toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildRetiradosTable() {
    return StreamBuilder<List<Retirado>>(
      stream: _reporteService.getRetirados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay datos disponibles'));
        } else {
          final retirados = snapshot.data!;
          return DataTable(
            columns: [
              DataColumn(label: Text('Asesor')),
              DataColumn(label: Text('Centro')),
              DataColumn(label: Text('Fecha Retiro')),
              DataColumn(label: Text('Folio ID')),
              DataColumn(label: Text('Observaciones')),
              DataColumn(label: Text('Imágenes')),
            ],
            rows: retirados.map((retirado) {
              return DataRow(
                cells: [
                  DataCell(Text(retirado.asesor)),
                  DataCell(Text(retirado.centro)),
                  DataCell(
                      Text(retirado.formatTimestamp(retirado.fechaRetiro))),
                  DataCell(Text(retirado.folioID)),
                  DataCell(Text(retirado.observaciones)),
                  DataCell(
                    Row(
                      children: retirado.imagenes
                          .map((url) => _buildImageCell(url))
                          .toList(),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildImageCell(String imageUrl) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image);
        },
      ),
    );
  }
}
