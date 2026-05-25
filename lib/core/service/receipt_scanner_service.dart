import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScannerService {
  static const double _minAmount = 1.0;
  static const double _maxAmount = 999999.99;
  static const double _bottomSectionStart = 0.70;
  static const int _minMerchantLength = 4;

  static final _phoneRegex = RegExp(r'\b\d{7,}\b');
  static final _amountRegex = RegExp(r'\b\d{1,6}(?:[.,]\d{1,2})?\b');
  static final _dateRegex = RegExp(r'(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{2,4})');
  static final _numbersOnlyRegex = RegExp(r'^\d+$');

  static const _highPriorityKeywords = [
    'grand total',
    'total due',
    'amount due',
    'net amount',
    'total amount',
    'المجموع الكلي',
    'إجمالي المبلغ',
    'المبلغ المستحق',
  ];

  static const _lowPriorityKeywords = [
    'total',
    'المجموع',
    'إجمالي',
    'الإجمالي',
    'مجموع',
    'صافي',
    'مستحق',
  ];

  static const _ignoreKeywords = [
    'tel', 'phone', 'mob', 'fax', 'hotline', 'call', 'cr no', 'vat no',
    'tax', 'vat', 'subtotal', 'sub-total', 'sub total',
    'discount', 'خصم', 'ضريبة', 'رقم',
  ];

  final _imagePicker = ImagePicker();

  Future<File?> pickImage({bool fromCamera = true}) async {
    final picked = await _imagePicker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<String> extractText(File imageFile) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognized = await textRecognizer.processImage(inputImage);
      return recognized.text;
    } finally {
      textRecognizer.close();
    }
  }

  Future<ReceiptData> scanReceipt(File imageFile) async {
    final rawText = await extractText(imageFile);
    return parseReceipt(rawText);
  }

  ReceiptData parseReceipt(String text) {
    final cleanText = text.replaceAll(_phoneRegex, '');
    final lines = cleanText.split('\n');

    final amount = _extractAmount(lines);
    final date = _extractDate(text);
    final merchant = _extractMerchant(lines);

    return ReceiptData(
      amount: amount,
      date: date,
      merchant: merchant,
      rawText: text,
    );
  }

  double? _extractAmount(List<String> lines) {
    final fromHighPriority = _searchByKeywords(lines, _highPriorityKeywords);
    if (fromHighPriority != null) return fromHighPriority;

    final fromLowPriority = _searchByKeywords(lines, _lowPriorityKeywords);
    if (fromLowPriority != null) return fromLowPriority;

    final fromBottom = _largestAmountInSection(
      lines,
      startPercent: _bottomSectionStart,
    );
    if (fromBottom != null) return fromBottom;

    return _largestAmountInSection(lines, startPercent: 0.0);
  }

  double? _searchByKeywords(List<String> lines, List<String> keywords) {
    for (int i = lines.length - 1; i >= 0; i--) {
      final line = lines[i].toLowerCase().trim();

      if (line.isEmpty) continue;
      if (_shouldIgnoreLine(line)) continue;

      final hasKeyword = keywords.any((k) => line.contains(k));
      if (!hasKeyword) continue;

      final amountFromSameLine = _lastValidAmount(line);
      if (amountFromSameLine != null) return amountFromSameLine;

      if (i + 1 < lines.length) {
        final amountFromNextLine = _lastValidAmount(lines[i + 1]);
        if (amountFromNextLine != null) return amountFromNextLine;
      }
    }
    return null;
  }

  double? _lastValidAmount(String line) {
    final matches = _amountRegex.allMatches(line).toList();
    if (matches.isEmpty) return null;

    for (int i = matches.length - 1; i >= 0; i--) {
      final val = _parseAmount(matches[i].group(0)!);
      if (_isValidAmount(val)) return val;
    }
    return null;
  }

  double? _largestAmountInSection(
      List<String> lines, {
        required double startPercent,
      }) {
    final startIndex = (lines.length * startPercent).floor();
    final section = lines
        .sublist(startIndex)
        .where((l) => !_shouldIgnoreLine(l.toLowerCase()))
        .join(' ');

    final amounts = _amountRegex
        .allMatches(section)
        .map((m) => _parseAmount(m.group(0)!))
        .where(_isValidAmount)
        .toList();

    if (amounts.isEmpty) return null;

    amounts.sort((a, b) => b.compareTo(a));
    return amounts.first;
  }

  DateTime? _extractDate(String text) {
    final match = _dateRegex.firstMatch(text);
    if (match == null) return null;

    try {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final rawYear = int.parse(match.group(3)!);
      final year = rawYear < 100 ? 2000 + rawYear : rawYear;

      if (month < 1 || month > 12) return null;
      if (day < 1 || day > 31) return null;

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  String? _extractMerchant(List<String> lines) {
    for (final line in lines) {
      final cleaned = line.trim();

      if (cleaned.length < _minMerchantLength) continue;
      if (_numbersOnlyRegex.hasMatch(cleaned)) continue;
      if (_shouldIgnoreLine(cleaned.toLowerCase())) continue;

      return cleaned;
    }
    return null;
  }

  bool _shouldIgnoreLine(String line) {
    return _ignoreKeywords.any((k) => line.contains(k));
  }

  double _parseAmount(String raw) {
    final normalized = raw.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  bool _isValidAmount(double val) {
    return val >= _minAmount && val <= _maxAmount;
  }
}

class ReceiptData {
  final double? amount;
  final DateTime? date;
  final String? merchant;
  final String rawText;

  const ReceiptData({
    this.amount,
    this.date,
    this.merchant,
    required this.rawText,
  });

  bool get hasAmount => amount != null;
  bool get hasDate => date != null;
  bool get hasMerchant => merchant != null;

  int get confidence => [hasAmount, hasDate, hasMerchant].where((v) => v).length;

}
