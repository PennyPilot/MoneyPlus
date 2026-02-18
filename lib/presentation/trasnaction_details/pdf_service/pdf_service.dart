import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:moneyplus/design_system/theme/money_extension_context.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../design_system/assets/app_assets.dart';
import '../../../domain/entity/transaction.dart';
import '../../../domain/entity/transaction_type.dart';

const _pdfTitle = PdfColor.fromInt(0xDE1F1F1F);
const _pdfRed = PdfColor.fromInt(0xFFE54F40);
const _pdfGreen = PdfColor.fromInt(0xFF51AC46);

Future<TransactionPdfAssets> loadTransactionPdfAssets() async {
  Future<pw.ImageProvider> load(String path) async {
    final data = await rootBundle.load(path);
    return pw.MemoryImage(data.buffer.asUint8List());
  }

  Future<pw.Font> loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  return TransactionPdfAssets(
    background: await load(AppAssets.transactionDetailsBackground),
    coinStack: await load(AppAssets.transactionCoinStack),
    lineSeparator: await load(AppAssets.lineSeparator),
    font: await loadFont(),
  );
}

class TransactionPdfAssets {
  final pw.ImageProvider background;
  final pw.ImageProvider coinStack;
  final pw.ImageProvider lineSeparator;
  final pw.Font font;

  const TransactionPdfAssets({
    required this.background,
    required this.coinStack,
    required this.lineSeparator,
    required this.font,
  });
}

pw.Widget pdfContent(
  Transaction transaction,
  TransactionPdfAssets assets,
  BuildContext context,
) {
  final isIncome = transaction.type == TransactionType.income;
  final transactionSign = isIncome ? '+' : '-';
  final transactionColor = isIncome ? _pdfGreen : _pdfRed;
  final localizations = context.localizations;
  final locale = Localizations.localeOf(context).toString();
  final formattedDate = DateFormat.yMMMMd(locale).format(transaction.date);
  final font = assets.font;

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
                  isIncome
                      ? localizations.income_details
                      : localizations.expense_details,
                style: pw.TextStyle(
                  font: font,
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
                  font: font,
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
                pdfInfoRow(localizations.date, formattedDate, font, context),

                pw.SizedBox(height: 10),

                pw.SizedBox(
                  height: 1,
                  child: pw.Image(assets.lineSeparator, fit: pw.BoxFit.fill),
                ),

                pw.SizedBox(height: 10),

                pdfInfoRow(
                  localizations.category,
                  transaction.category.name,
                  font,
                  context,
                ),

                pw.SizedBox(height: 10),

                pw.SizedBox(
                  height: 1,
                  child: pw.Image(assets.lineSeparator, fit: pw.BoxFit.fill),
                ),

                pw.SizedBox(height: 10),

                pdfInfoRow(localizations.note, transaction.note, font, context),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

pw.Widget pdfInfoRow(
  String firstValue,
  String secondValue,
  pw.Font font,
  BuildContext context,
) {
  return pw.Row(
    children: [
      pw.Text(
        firstValue,
        style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
      ),
      pw.Spacer(),
      pw.Expanded(
        child: pw.Text(
          secondValue,
          textAlign: pw.TextAlign.right,
          style: pw.TextStyle(font: font),
        ),
      ),
    ],
  );
}