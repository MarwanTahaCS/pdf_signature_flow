import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import 'mobile.dart' if (dart.library.html) 'web.dart';
import './pdf_parser.dart';

class PDFviewer extends StatelessWidget {
  const PDFviewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('PDFreader'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: () async {
                File pdfFile = await _pickFile();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfParser(pdfFile: pdfFile),
                  ),
                );
              },
              child: const Text(
                'File picker',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: () async {
                File pdfFile = await _pickImages();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfParser(pdfFile: pdfFile),
                  ),
                );
              },
              child: const Text(
                'Image picker',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue)),
              onPressed: () async {
                File pdfFile = await _shootImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfParser(pdfFile: pdfFile),
                  ),
                );
              },
              child: const Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<File> _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'png', 'jpng'],
  );
  if (result != null) {
    if (p.extension(result.names[0]!) == ".pdf") {
      File file = File(result.files.single.path as String);
      return file;
    } else {
      List<int> imageData = File(result.files.single.path as String)
          .readAsBytesSync()
          .buffer
          .asUint8List();
      return _convertImageToPDF(imageData);
    }
  } else {
    // User canceled the picker
  }
  return _pickFile();
}

Future<File> _pickImages() async {
  // open image picker
  final ImagePicker picker = ImagePicker();
  final List<XFile> images = await picker.pickMultiImage();
  List<List<int>> imageData = [];
  if (images.isNotEmpty) {
    for (int i = 0; i < images.length; i++) {
      imageData
          .add(File(images[i].path).readAsBytesSync().buffer.asUint8List());
    }

    return _convertImagesToPDF(imageData);
  } else {
    // User canceled the picker
  }
  return _pickImages();
}

Future<File> _shootImage() async {
  // open image picker
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  if (photo != null) {
    return _convertImageToPDF(
        File(photo.path).readAsBytesSync().buffer.asUint8List());
  } else {
    // User canceled the picker
  }
  return _shootImage();
}

Future<File> _convertImageToPDF(List<int> imageData) async {
  //Create the PDF document
  PdfDocument document = PdfDocument();

  //Add the page
  PdfPage page = document.pages.add();

  //Load the image
  final PdfImage image = PdfBitmap(imageData);

  //draw image to the first page
  page.graphics.drawImage(image,
      Rect.fromLTWH(0, 0, page.size.width * 0.9, page.size.height * 0.9));

  //Save the document
  List<int> bytes = await document.save();

  // Dispose the document
  document.dispose();

  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$path/documentImage.pdf');
  return await file.writeAsBytes(bytes, flush: true);
}

Future<File> _convertImagesToPDF(List<List<int>> imageData) async {
  //Create the PDF document
  PdfDocument document = PdfDocument();

  for (int i = 0; i < imageData.length; i++) {
    //Add the page
    PdfPage page = document.pages.add();

    //Load the image
    final PdfImage image = PdfBitmap(imageData[i]);

    //draw image to the first page
    page.graphics.drawImage(image,
        Rect.fromLTWH(0, 0, page.size.width * 0.9, page.size.height * 0.9));
  }
  //Save the document
  List<int> bytes = await document.save();

  // Dispose the document
  document.dispose();

  final path = (await getExternalStorageDirectory())?.path;
  final file = File('$path/documentImage.pdf');
  return await file.writeAsBytes(bytes, flush: true);
}
