import 'package:flutter/material.dart';

import '../../components/custom_app_bar.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer ({Key? key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewer();
}

class _PdfViewer extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Termos de Uso", isVisibleBackButton: true),
        body: Container());
  }
}




