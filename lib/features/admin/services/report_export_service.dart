import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportExportService {
  /// Generate Excel file bytes for attendance report
  static List<int>? exportAttendanceToExcel(List<Map<String, dynamic>> records) {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Laporan Absensi FENSI'];

    // Header Row
    sheetObject.appendRow([
      TextCellValue('ID'),
      TextCellValue('Nama Karyawan'),
      TextCellValue('Departemen'),
      TextCellValue('Tanggal'),
      TextCellValue('Jam Masuk'),
      TextCellValue('Jam Keluar'),
      TextCellValue('Status'),
      TextCellValue('Jarak (m)'),
    ]);

    for (var row in records) {
      sheetObject.appendRow([
        TextCellValue(row['id'] ?? ''),
        TextCellValue(row['name'] ?? ''),
        TextCellValue(row['department'] ?? ''),
        TextCellValue(row['date'] ?? ''),
        TextCellValue(row['clock_in'] ?? ''),
        TextCellValue(row['clock_out'] ?? ''),
        TextCellValue(row['status'] ?? ''),
        TextCellValue('${row['distance']} m'),
      ]);
    }

    return excel.encode();
  }

  /// Generate PDF document for attendance report
  static Future<List<int>> exportAttendanceToPDF(List<Map<String, dynamic>> records) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PT FENHAM INDONESIA - LAPORAN ABSENSI KARYAWAN',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text('Dicetak pada: 14 Agustus 2026', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: ['Nama', 'Dept', 'Tanggal', 'Masuk', 'Keluar', 'Status'],
                data: records.map((r) => [
                  r['name'] ?? '',
                  r['department'] ?? '',
                  r['date'] ?? '',
                  r['clock_in'] ?? '',
                  r['clock_out'] ?? '',
                  r['status'] ?? '',
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    return await pdf.save();
  }
}
