import 'package:flutter/material.dart';
import 'dart:io';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:performance/performance.dart';

import './sign_location.dart';
import './sign_parent_page.dart';

class PdfParser extends StatelessWidget {
  final File pdfFile;
  const PdfParser({super.key, required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return MyApp(pdfFile: pdfFile);
  }
}

class MyApp extends StatefulWidget {
  final File pdfFile;
  MyApp({required this.pdfFile, Key? key}) : super(key: key);

  @override
  _PdfPage createState() => _PdfPage(pdfFile as File);
}

class _PdfPage extends State<StatefulWidget> {
  final File pdfFile;
  static const int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = false;
  late PdfController _pdfController;
  List<int> signatureLocations = List<int>.filled(0, 0);

  _PdfPage(this.pdfFile);

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openData(pdfFile.readAsBytesSync()),
      initialPage: _initialPage,
    );

    super.initState();
  }

  void updateSignatureLocations(int numOfPage, int location) {
    final newSignatureLocations = signatureLocations;
    newSignatureLocations[numOfPage - 1] = location;
    setState(() {
      signatureLocations = newSignatureLocations;
    });
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
            title: const Text('Teacher view'),
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
              // IconButton(
              //   icon: const Icon(Icons.refresh),
              //   onPressed: () {
              //     if (isSampleDoc) {
              //       _pdfController.loadDocument(
              //           PdfDocument.openData(pdfFile.readAsBytesSync()));
              //     } else {
              //       _pdfController.loadDocument(
              //           PdfDocument.openData(pdfFile.readAsBytesSync()));
              //     }
              //     isSampleDoc = !isSampleDoc;
              //   },
              // ),
              SizedBox(
                child: OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    child: const Text("Send"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignParentPage(
                            pdfFile: pdfFile,
                            signatureLocations: signatureLocations,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child:
                //   Column(
                // children: <Widget>[
                Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 80,
              alignment: Alignment.center,
              // child: Expanded(
              child: PdfView(
                documentLoader:
                    const Center(child: CircularProgressIndicator()),
                pageLoader: const Center(child: CircularProgressIndicator()),
                controller: _pdfController,
                onDocumentLoaded: (document) {
                  setState(() {
                    _allPagesCount = document.pagesCount;
                  });
                  signatureLocations = List<int>.filled(_allPagesCount, 0);
                },
                onPageChanged: (page) {
                  setState(() {
                    _actualPageNumber = page;
                  });
                },
                pageBuilder: (
                  Future<PdfPageImage> pageImage,
                  int index,
                  PdfDocument document,
                ) =>
                    //     PhotoViewGalleryPageOptions(
                    //   imageProvider: PdfPageImageProvider(
                    //     pageImage,
                    //     index,
                    //     document.id,
                    //   ),
                    //   minScale: PhotoViewComputedScale.contained * 1,
                    //   maxScale: PhotoViewComputedScale.contained * 3.0,
                    //   initialScale: PhotoViewComputedScale.contained * 1.0,
                    //   heroAttributes: PhotoViewHeroAttributes(
                    //       tag: '${document.id}-$index'),
                    // ),
                    PhotoViewGalleryPageOptions.customChild(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height -
                            80, //* (11 / 8),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          // fit: BoxFit.cover,
                          image: PdfPageImageProvider(
                            pageImage,
                            index,
                            document.id,
                          ),
                        )),
                        child: StatefulBuilder(builder: (context, setState) {
                          return Container(
                              alignment: const Alignment(0.5, 0.7),
                              // width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 80,
                              child: SignLocation(
                                pageNumber: _actualPageNumber,
                                updateSignatureLocations:
                                    updateSignatureLocations,
                                signatureLocations: signatureLocations,
                              ));
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Text("Signature location of page $_actualPageNumber"),
            // StatefulBuilder(builder: (context, setState) {
            //   return SignLocation(
            //     pageNumber: _actualPageNumber,
            //     updateSignatureLocations: updateSignatureLocations,
            //     signatureLocations: signatureLocations,
            //   );
            // }),
            // ],
            // )),
          ),
        ),
      );
}
