import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SigningPad extends StatefulWidget {
  final dynamic updateSignature;
  final dynamic signPdf;
  const SigningPad({
    Key? key,
    required this.updateSignature,
    required this.signPdf,
  }) : super(key: key);

  @override
  State<SigningPad> createState() => _SigningPadState();
}

class _SigningPadState extends State<SigningPad> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 4.5);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    List<int> imageData =
        bytes!.buffer.asUint8List(); //PdfBitmap(bytes!.buffer.asUint8List());

    //send image back to parent
    widget.updateSignature(PdfBitmap(imageData));
    widget.signPdf(PdfBitmap(imageData));

    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //         appBar: AppBar(),
    //         body: Center(
    //           child: Container(
    //             color: Colors.grey[300],
    //             child: Image.memory(bytes!.buffer.asUint8List()),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: SfSignaturePad(
                    key: signatureGlobalKey,
                    backgroundColor: Colors.transparent,
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 3.0,
                    maximumStrokeWidth: 5.0),
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () => {_handleSaveButtonPressed()},
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: _handleClearButtonPressed,
                child: const Text('Clear'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
