// import 'dart:typed_data';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'mobile.dart' if (dart.library.html) 'web.dart';
import 'pdf_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400.0,
          alignment: Alignment.center,
          child: Column(
            children: const [
              // SizedBox(
              //   height: 50.0,
              //   child: ElevatedButton(
              //     onPressed: _createPDF,
              //     child: const Text('Create PDF'),
              //   ),
              // ),
              SizedBox(
                height: 300.0,
                child: PDFviewer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _createPDF() async {
  //   PdfDocument document = PdfDocument();
  //   final page = document.pages.add();

  //   page.graphics.drawString(
  //     'Welcome to the PDF',
  //     PdfStandardFont(
  //       PdfFontFamily.helvetica,
  //       30,
  //     ),
  //   );

  //   page.graphics.drawImage(
  //       PdfBitmap(await _readImageData('DSC00169Cropped.jpg')),
  //       const Rect.fromLTWH(50, 50, 400, 250));

  //   // add a table to the PDF file
  //   PdfGrid grid = PdfGrid();
  //   grid.style = PdfGridStyle(
  //     font: PdfStandardFont(PdfFontFamily.helvetica, 30),
  //     cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2),
  //   );

  //   grid.columns.add(count: 3);
  //   grid.headers.add(1);

  //   PdfGridRow header = grid.headers[0];
  //   header.cells[0].value = 'Roll No';
  //   header.cells[1].value = 'Name';
  //   header.cells[2].value = 'Class';

  //   PdfGridRow row = grid.rows.add();
  //   row.cells[0].value = '1';
  //   row.cells[1].value = 'Arya';
  //   row.cells[2].value = '6';

  //   row = grid.rows.add();
  //   row.cells[0].value = '2';
  //   row.cells[1].value = 'Arya';
  //   row.cells[2].value = '8';

  //   row = grid.rows.add();
  //   row.cells[0].value = '3';
  //   row.cells[1].value = 'Arya';
  //   row.cells[2].value = '9';

  //   grid.draw(
  //       page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

  //   List<int> bytes = await document.save();
  //   document.dispose();

  //   saveAndLaunchFile(bytes, 'Output.pdf');
  // }
}

// Future<Uint8List> _readImageData(String name) async {
//   final data = await rootBundle.load('images/$name');
//   return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// }
