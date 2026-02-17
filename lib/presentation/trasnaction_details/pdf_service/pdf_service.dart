import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../design_system/assets/app_assets.dart';
import '../../../domain/entity/transaction.dart';
import '../../../domain/entity/transaction_type.dart';

const _pdfTitle = PdfColor.fromInt(0xDE1F1F1F);
const _pdfBody = PdfColor.fromInt(0xA81F1F1F);
const _pdfRed = PdfColor.fromInt(0xFFE54F40);
const _pdfGreen = PdfColor.fromInt(0xFF51AC46);

Future<TransactionPdfAssets> loadTransactionPdfAssets() async {
  Future<pw.ImageProvider> load(String path) async {
    final data = await rootBundle.load(path);
    return pw.MemoryImage(data.buffer.asUint8List());
  }

  return TransactionPdfAssets(
    background: await load(AppAssets.transactionDetailsBackground),
    coinStack: await load(AppAssets.transactionCoinStack),
    flowerShape3: await load(AppAssets.flowerShape3),
    flowerShape4: await load(AppAssets.flowerShape4),
    lineSeparator: await load(AppAssets.lineSeparator),
  );
}

class TransactionPdfAssets {
  final pw.ImageProvider background;
  final pw.ImageProvider coinStack;
  final pw.ImageProvider flowerShape3;
  final pw.ImageProvider flowerShape4;
  final pw.ImageProvider lineSeparator;

  const TransactionPdfAssets({
    required this.background,
    required this.coinStack,
    required this.flowerShape3,
    required this.flowerShape4,
    required this.lineSeparator,
  });
}

pw.Widget pdfContent(Transaction transaction, TransactionPdfAssets assets) {
  final isIncome = transaction.type == TransactionType.income;
  final transactionSign = isIncome ? '+' : '-';
  final transactionColor = isIncome ? _pdfGreen : _pdfRed;

  const cardWidth = 500.0;
  const cardHeight = 420.0;

  return pw.Center(
    child: pw.SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: pw.Stack(
        children: [
          pw.Positioned.fill(
            child: pw.Image(assets.background, fit: pw.BoxFit.fill),
          ),

          pw.Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: pw.Center(
              child: pw.SizedBox(
                width: 96,
                height: 112,
                child: pw.Image(assets.coinStack, fit: pw.BoxFit.fill),
              ),
            ),
          ),

          pw.Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: pw.Center(
              child: pw.Text(
                isIncome ? 'Income details' : 'Expense details',
                style: pw.TextStyle(
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                  color: _pdfTitle,
                ),
              ),
            ),
          ),

          pw.Positioned(
            top: 172,
            left: 0,
            right: 0,
            child: pw.Center(
              child: pw.Text(
                '$transactionSign${transaction.amount} ${transaction.currency}',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: transactionColor,
                ),
              ),
            ),
          ),

          pw.Positioned(
            left: 28,
            right: 28,
            top: 252,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                simplePdfInfoRow('Date', _formatDate(transaction.date)),


                pw.SizedBox(height: 10),

                pw.SizedBox(
                  height: 1,
                  child: pw.Image(assets.lineSeparator, fit: pw.BoxFit.fill),
                ),

                pw.SizedBox(height: 10),


                simplePdfInfoRow('Category', transaction.category.name),

                pw.SizedBox(height: 10),

                pw.SizedBox(
                  height: 1,
                  child: pw.Image(assets.lineSeparator, fit: pw.BoxFit.fill),
                ),

                pw.SizedBox(height: 10),

                simplePdfInfoRow('Note', transaction.note),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

pw.Widget _pdfInfoRow({
  required String label,
  required String value,
  pw.ImageProvider? categoryIcon,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(label, style: pw.TextStyle(fontSize: 12, color: _pdfBody)),
      pw.Row(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _pdfTitle,
            ),
          ),
          if (categoryIcon != null) ...[
            pw.SizedBox(width: 4),
            pw.SizedBox(width: 20, height: 20, child: pw.Image(categoryIcon)),
          ],
        ],
      ),
    ],
  );
}

pw.Widget simplePdfContent(Transaction transaction) {
  final isIncome = transaction.type == TransactionType.income;
  final transactionSign = isIncome ? '+' : '-';

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Text(
          isIncome ? "Income details" : "Expense details",
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 16),

      pw.Center(
        child: pw.Text(
          "$transactionSign${transaction.amount} ${transaction.currency}",
          style: pw.TextStyle(
            fontSize: 18,
            color: isIncome ? PdfColors.green : PdfColors.red,
          ),
        ),
      ),
      pw.SizedBox(height: 24),

      pw.Divider(),

      pw.SizedBox(height: 12),
      simplePdfInfoRow("Date", _formatDate(transaction.date)),

      pw.SizedBox(height: 12),
      pw.Divider(),

      pw.SizedBox(height: 12),
      simplePdfInfoRow("Category", transaction.category.name),

      pw.SizedBox(height: 12),
      pw.Divider(),

      pw.SizedBox(height: 12),
      simplePdfInfoRow("Note", transaction.note),

      pw.SizedBox(height: 12),
    ],
  );
}

pw.Widget simplePdfInfoRow(String firstValue, String secondValue) {
  return pw.Row(
    children: [
      pw.Text(firstValue, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Spacer(),
      pw.Expanded(child: pw.Text(secondValue, textAlign: pw.TextAlign.right)),
    ],
  );
}

String _formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
