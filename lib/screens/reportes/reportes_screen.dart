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
        title: SelectableText('Reportes'),
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
            SelectableText(
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
      builder: (conSelectableText, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: SelectableText('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: SelectableText('No hay datos disponibles'));
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
                DataColumn(label: SelectableText('Asesor')),
                DataColumn(label: SelectableText('Nombre')),
                DataColumn(label: SelectableText('Centro')),
                DataColumn(label: SelectableText('Fecha Alta')),
                DataColumn(label: SelectableText('Fecha Folio')),
                DataColumn(label: SelectableText('Fecha Instalado')),
                DataColumn(label: SelectableText('Folio ID')),
                DataColumn(label: SelectableText('Instalado')),
                DataColumn(label: SelectableText('Número Folio')),
                DataColumn(label: SelectableText('Problema')),
                DataColumn(label: SelectableText('Retirado')),
              ],
              rows: folios.map((folio) {
                return DataRow(
                  cells: [
                    DataCell(SelectableText(folio.asesor)),
                    DataCell(FutureBuilder<String>(
                      future: _reporteService.getUserName(folio.asesor),
                      builder: (conSelectableText, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return SelectableText('Error');
                        } else {
                          return SelectableText(snapshot.data ?? 'N/A');
                        }
                      },
                    )),
                    DataCell(SelectableText(folio.centro)),
                    DataCell(
                        SelectableText(folio.formatTimestamp(folio.fecAlta))),
                    DataCell(SelectableText(folio.fecFolio)),
                    DataCell(SelectableText(
                        folio.formatTimestamp(folio.fecInstalado))),
                    DataCell(SelectableText(folio.folioID)),
                    DataCell(SelectableText(folio.instalado)),
                    DataCell(SelectableText(folio.numFolio)),
                    DataCell(SelectableText(folio.problema)),
                    DataCell(SelectableText(folio.retirado)),
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
      builder: (conSelectableText, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: SelectableText('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: SelectableText('No hay datos disponibles'));
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
                DataColumn(label: SelectableText('Asesor')),
                DataColumn(label: SelectableText('Nombre')),
                DataColumn(label: SelectableText('Centro')),
                DataColumn(label: SelectableText('Fecha')),
                DataColumn(label: SelectableText('Folio ID')),
                DataColumn(label: SelectableText('Observaciones')),
                DataColumn(label: SelectableText('Imágenes')),
              ],
              rows: instalados.map((instalado) {
                return DataRow(
                  cells: [
                    DataCell(SelectableText(instalado.asesor)),
                    DataCell(FutureBuilder<String>(
                      future: _reporteService.getUserName(instalado.asesor),
                      builder: (conSelectableText, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return SelectableText('Error');
                        } else {
                          return SelectableText(snapshot.data ?? 'N/A');
                        }
                      },
                    )),
                    DataCell(SelectableText(instalado.centro)),
                    DataCell(SelectableText(
                        instalado.formatTimestamp(instalado.fecha))),
                    DataCell(SelectableText(instalado.folioID)),
                    DataCell(SelectableText(instalado.observaciones)),
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
      builder: (conSelectableText, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: SelectableText('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: SelectableText('No hay datos disponibles'));
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
                DataColumn(label: SelectableText('Asesor')),
                DataColumn(label: SelectableText('Nombre')),
                DataColumn(label: SelectableText('Centro')),
                DataColumn(label: SelectableText('Fecha Retiro')),
                DataColumn(label: SelectableText('Folio ID')),
                DataColumn(label: SelectableText('Observaciones')),
                DataColumn(label: SelectableText('Imágenes')),
              ],
              rows: retirados.map((retirado) {
                return DataRow(
                  cells: [
                    DataCell(SelectableText(retirado.asesor)),
                    DataCell(FutureBuilder<String>(
                      future: _reporteService.getUserName(retirado.asesor),
                      builder: (conSelectableText, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return SelectableText('Error');
                        } else {
                          return SelectableText(snapshot.data ?? 'N/A');
                        }
                      },
                    )),
                    DataCell(SelectableText(retirado.centro)),
                    DataCell(SelectableText(
                        retirado.formatTimestamp(retirado.fechaRetiro))),
                    DataCell(SelectableText(retirado.folioID)),
                    DataCell(SelectableText(retirado.observaciones)),
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
        errorBuilder: (conSelectableText, error, stackTrace) {
          return Icon(Icons.broken_image);
        },
      ),
    );
  }
}
