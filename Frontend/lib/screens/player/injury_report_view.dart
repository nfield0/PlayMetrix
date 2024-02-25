import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:play_metrix/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InjuryReportView extends StatelessWidget {
  final Uint8List? data;

  const InjuryReportView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Injury Report",
              style: TextStyle(
                color: AppColours.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
        ),
        body: SfPdfViewer.memory(data!));
  }
}
