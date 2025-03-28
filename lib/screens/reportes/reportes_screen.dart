import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/reporte_service.dart';
import '../../models/reporte.dart';
import '../../styles/app_colors.dart';
import '../../services/reporte_excel.dart'; // Asegúrate de importar el servicio ExcelService

class ReportesScreen extends StatelessWidget {
  final ReporteService _reporteService = ReporteService();
  final ExcelService _excelService =
      ExcelService(); // Instancia del servicio ExcelService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes'),
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0, // Sin sombra
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await _excelService.generateAndDownloadExcel();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard(_buildFoliosTable(), 'Folios'),
              SizedBox(height: 16),
              _buildCard(_buildInstaladosTable(), 'Instalados'),
              SizedBox(height: 16),
              _buildCard(_buildRetiradosTable(), 'Retirados'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Widget child, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            SizedBox(height: 8),
            child,
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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return AppColors.secondary.withOpacity(0.7);
              }),
              columns: [
                DataColumn(label: Text('Asesor')),
                DataColumn(label: Text('Nombre')),
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
                    DataCell(FutureBuilder<String>(
                      future: _reporteService.getUserName(folio.asesor),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return Text(snapshot.data ?? 'N/A');
                        }
                      },
                    )),
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
            ),
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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return AppColors.secondary.withOpacity(0.7);
              }),
              columns: [
                DataColumn(label: Text('Asesor')),
                DataColumn(label: Text('Nombre')),
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
                    DataCell(FutureBuilder<String>(
                      future: _reporteService.getUserName(instalado.asesor),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return Text(snapshot.data ?? 'N/A');
                        }
                      },
                    )),
                    DataCell(Text(instalado.centro)),
                    DataCell(Text(instalado.formatTimestamp(instalado.fecha))),
                    DataCell(Text(instalado.folioID)),
                    DataCell(Text(instalado.observaciones)),
                    DataCell(
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: instalado.imagenes
                              .map((url) => _buildImageCell(url))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return AppColors.secondary.withOpacity(0.7);
              }),
              columns: [
                DataColumn(label: Text('Asesor')),
                DataColumn(label: Text('Nombre')),
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
                    DataCell(FutureBuilder<String>(
                      future: _reporteService.getUserName(retirado.asesor),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return Text(snapshot.data ?? 'N/A');
                        }
                      },
                    )),
                    DataCell(Text(retirado.centro)),
                    DataCell(
                        Text(retirado.formatTimestamp(retirado.fechaRetiro))),
                    DataCell(Text(retirado.folioID)),
                    DataCell(Text(retirado.observaciones)),
                    DataCell(
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: retirado.imagenes
                              .map((url) => _buildImageCell(url))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
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
