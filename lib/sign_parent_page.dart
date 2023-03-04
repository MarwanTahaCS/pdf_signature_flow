import 'package:flutter/material.dart';
import 'dart:io';
import 'package:native_pdf_view/native_pdf_view.dart' as viewer;
import 'package:performance/performance.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as signing;
// import 'dart:ui' as ui;

import 'mobile.dart' if (dart.library.html) 'web.dart';
import './signing_pad.dart';

class SignParentPage extends StatefulWidget {
  final File pdfFile;
  final List<int> signatureLocations;

  const SignParentPage({
    super.key,
    required this.pdfFile,
    required this.signatureLocations,
  });

  @override
  State<SignParentPage> createState() => _SignParentPageState();
}

class _SignParentPageState extends State<SignParentPage> {
  static const int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = false;
  late viewer.PdfControllerPinch _pdfController;
  signing.PdfImage? signature;

  @override
  void initState() {
    _pdfController = viewer.PdfControllerPinch(
      document: viewer.PdfDocument.openData(widget.pdfFile.readAsBytesSync()),
      initialPage: _initialPage,
    );

    super.initState();
  }

  void updateSignature(signing.PdfImage image) {
    setState(() {
      signature = image;
    });
  }

  void signPdf(signing.PdfImage image) {
    _readPDF(widget.pdfFile, widget.signatureLocations, image);
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: const Text('Parent Flow'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () {
                  _pdfController.previousPage(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$_actualPageNumber/$_allPagesCount',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  _pdfController.nextPage(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (isSampleDoc) {
                    _pdfController.loadDocument(viewer.PdfDocument.openData(
                        widget.pdfFile.readAsBytesSync()));
                  } else {
                    _pdfController.loadDocument(viewer.PdfDocument.openData(
                        widget.pdfFile.readAsBytesSync()));
                  }
                  isSampleDoc = !isSampleDoc;
                },
              ),
            ],
          ),
          body: CustomPerformanceOverlay(
              enabled: false,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: viewer.PdfViewPinch(
                      documentLoader:
                          const Center(child: CircularProgressIndicator()),
                      pageLoader:
                          const Center(child: CircularProgressIndicator()),
                      controller: _pdfController,
                      onDocumentLoaded: (document) {
                        setState(() {
                          _allPagesCount = document.pagesCount;
                        });
                      },
                      onPageChanged: (page) {
                        setState(() {
                          _actualPageNumber = page;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _readPDF(widget.pdfFile, widget.signatureLocations);
                  //   },
                  //   child: const Text("Sign here"),
                  // ),
                  SizedBox(
                    height: 350,
                    child: SigningPad(
                        updateSignature: updateSignature, signPdf: signPdf),
                  ),
                ],
              )),
        ),
      );
}

Future<void> _readPDF(
    File pdfFile, signatureLocations, signing.PdfImage image) async {
  //Load the PDF document
  final signing.PdfDocument document =
      signing.PdfDocument(inputBytes: pdfFile.readAsBytesSync());

  //Get the pages count
  int count = document.pages.count;

  //Create the PDF standard font
  signing.PdfFont font =
      signing.PdfStandardFont(signing.PdfFontFamily.helvetica, 10);

  for (int i = 1; i <= count; i++) {
    //Draw signature to the page
    if (signatureLocations[i - 1] > 0 && signatureLocations[i - 1] < 4) {
      document.pages[i - 1].graphics.drawImage(
        image,
        Rect.fromLTWH(
          10 + _getSignWidth(signatureLocations, i - 1, document),
          document.pages[i - 1].size.height - 85,
          image.width * 0.07,
          image.height * 0.07,
        ),
      );
    }
    // document.pages[0].graphics.drawImage(image, bounds)
  }

  //Save the document.
  List<int> bytes = await document.save();
  //convert bytes to File type
  // File signedDocument = await convertBytesToFile(bytes, "newName");
  // Dispose the document.
  document.dispose();

  //Save the file and launch/download.
  saveAndLaunchFile(bytes, 'output.pdf');
}

double _getSignWidth(
    List<int> signatureLocations, int index, signing.PdfDocument document) {
  double width = document.pages[index].size.width;
  switch (signatureLocations[index]) {
    case 0:
      {
        return -1;
      }

    case 1:
      {
        return 0;
      }
    case 2:
      {
        return (width / 2) - 60;
      }
    case 3:
      {
        return width - 140;
      }

    default:
      {
        return -1;
      }
  }
}

Future<File> convertBytesToFile(List<int> bytes, String fileName) async {
  // final path = (await getExternalStorageDirectory())?.path;
  final file = File(bytes.toString());
  return await file.writeAsBytes(bytes, flush: true);
}
