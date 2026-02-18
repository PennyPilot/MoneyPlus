import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:moneyplus/presentation/trasnaction_details/pdf_service/pdf_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../domain/entity/transaction.dart';

Future<void> createAndSharePdf(Transaction transaction, BuildContext context) async {
  try {
    final pdf = pw.Document();
    final assets = await loadTransactionPdfAssets();

    final isRtl = Localizations.localeOf(context).languageCode == 'ar';


    pdf.addPage(
      pw.Page(
        textDirection: isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pwContext) {
          return pdfContent(transaction, assets, context);
        },
      ),
    );

    final pdfByteArray = await pdf.save();

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/transaction details.pdf');
    await file.writeAsBytes(pdfByteArray);

    final params = ShareParams(
      files: [XFile(file.path)],
    );

    await SharePlus.instance.share(params);
  } catch (e) {
    print("Error creating or sharing PDF: $e");
  }
}