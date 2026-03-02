import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'expense_model.dart';

class ExportService {
  static Future<void> exportPDF(List<Expense> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Expense Report",
                style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            ...expenses.map(
              (e) =>
                  pw.Text("${e.title}   ₹${e.amount}   ${e.category}"),
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/expenses.pdf");

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  static Future<void> exportExcel(List<Expense> expenses) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets.values.first;

    sheet.appendRow([
      TextCellValue("Title"),
      TextCellValue("Amount"),
      TextCellValue("Category"),
    ]);

    for (var e in expenses) {
      sheet.appendRow([
        TextCellValue(e.title),
        DoubleCellValue(e.amount),
        TextCellValue(e.category),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/expenses.xlsx");

    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }
}