import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfReport {
  static Future<List<int>> generate(List<String> lines) async {
    final pdf = Document();
    pdf.addPage(Page(build: (_) {
      return Column(children: lines.map((l) => Text(l)).toList());
    }));
    return pdf.save();
  }
}
