import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../main.dart'; // Global state access

import 'dart:typed_data';

class PdfScreen extends StatelessWidget {
  const PdfScreen({super.key});

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    
    // Fetch data
    final problem = appState.problemDescription ?? 'Sin descripción';
    final criteria = appState.criteria;
    final ranking = appState.getRanking();
    final explanation = appState.getDecisionExplanation();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Informe de Decisión - CRITERIA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
            ),
            pw.SizedBox(height: 20),
            
            pw.Header(level: 1, child: pw.Text('1. Definición del Problema')),
            pw.Paragraph(text: problem),
            pw.SizedBox(height: 10),

            pw.Header(level: 1, child: pw.Text('2. Criterios de Evaluación')),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Criterio', 'Peso (1-5)'],
              data: criteria.map((c) => [c.name, c.weight.toString()]).toList(),
            ),
            pw.SizedBox(height: 20),

            pw.Header(level: 1, child: pw.Text('3. Ranking de Alternativas')),
            pw.TableHelper.fromTextArray(
              context: context,
              headers: ['Orden', 'Alternativa', 'Puntaje'],
              data: ranking.asMap().entries.map((e) {
                final index = e.key + 1;
                final item = e.value;
                return ['#$index', item.alternative.name, '${item.score} pts'];
              }).toList(),
            ),
            pw.SizedBox(height: 20),

            pw.Header(level: 1, child: pw.Text('4. Conclusión Automática')),
            pw.Paragraph(
              text: explanation,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic),
            ),
            
            pw.SizedBox(height: 40),
            pw.Divider(),
            pw.Center(
              child: pw.Text('Generado por CRITERIA - Tu asistente de decisiones.', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ),
          ];
        },
      ),
    );

    return pdf.save(); // Returns Future<Uint8List>
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informe PDF'),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        actions: [
          // Printing handles share natively via standard share sheet
        ],
      ),
    );
  }
}
