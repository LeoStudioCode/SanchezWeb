import 'package:excel/excel.dart';
import 'dart:html' as html;
import '../../models/reporte.dart';
import 'reporte_service.dart';

class ExcelService {
  final ReporteService _reporteService = ReporteService();

  Future<void> generateAndDownloadExcel() async {
    var excel = Excel.createExcel();

    Future<void> addSheetData(
        String sheetName, List<dynamic> dataList, List<String> headers) async {
      Sheet sheetObject = excel[sheetName];
      sheetObject.appendRow(headers.map(TextCellValue.new).toList());

      for (var data in dataList) {
        List<CellValue?> rowData = [
          TextCellValue(data.asesor),
          TextCellValue(await _reporteService.getUserName(data.asesor)),
        ];

        if (data is Folio) {
          rowData.addAll([
            TextCellValue(data.centro),
            TextCellValue(data.formatTimestamp(data.fecAlta)),
            TextCellValue(data.fecFolio),
            TextCellValue(data.formatTimestamp(data.fecInstalado)),
            TextCellValue(data.folioID),
            TextCellValue(data.instalado),
            TextCellValue(data.numFolio),
            TextCellValue(data.problema),
            TextCellValue(data.retirado),
          ]);
        } else if (data is Instalado) {
          rowData.addAll([
            TextCellValue(data.centro),
            TextCellValue(data.formatTimestamp(data.fecha)),
            TextCellValue(data.folioID),
            TextCellValue(data.observaciones),
            TextCellValue(data.imagenes.join(", ")),
          ]);
        } else if (data is Retirado) {
          rowData.addAll([
            TextCellValue(data.centro),
            TextCellValue(data.formatTimestamp(data.fechaRetiro)),
            TextCellValue(data.folioID),
            TextCellValue(data.observaciones),
            TextCellValue(data.imagenes.join(", ")),
          ]);
        }

        sheetObject.appendRow(rowData);
      }
    }

    await addSheetData('Folios', await _reporteService.getFolios().first, [
      'Asesor ID',
      'Nombre Asesor',
      'Centro',
      'Fecha Alta',
      'Fecha Folio',
      'Fecha Instalado',
      'Folio ID',
      'Instalado',
      'Número Folio',
      'Problema',
      'Retirado',
    ]);

    await addSheetData(
        'Instalados', await _reporteService.getInstalados().first, [
      'Asesor ID',
      'Nombre Asesor',
      'Centro',
      'Fecha',
      'Folio ID',
      'Observaciones',
      'Imágenes',
    ]);

    await addSheetData(
        'Retirados', await _reporteService.getRetirados().first, [
      'Asesor ID',
      'Nombre Asesor',
      'Centro',
      'Fecha Retiro',
      'Folio ID',
      'Observaciones',
      'Imágenes',
    ]);

    var bytes = excel.save();
    final blob = html.Blob([bytes], 'application/octet-stream');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "reportes.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
