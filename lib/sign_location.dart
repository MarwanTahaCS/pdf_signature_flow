import 'package:flutter/material.dart';

class SignLocation extends StatefulWidget {
  final int pageNumber;
  final dynamic updateSignatureLocations;
  final List<int> signatureLocations;
  const SignLocation({
    super.key,
    required this.pageNumber,
    required this.updateSignatureLocations,
    required this.signatureLocations,
  });

  @override
  State<SignLocation> createState() => _SignLocationState();
}

class _SignLocationState extends State<SignLocation> {
  int pressedButton = 0;

  @override
  Widget build(BuildContext context) {
    return (widget.signatureLocations.isEmpty)
        ? Container()
        : ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                    child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // backgroundColor:
                    //     (widget.signatureLocations[widget.pageNumber - 1] == 1)
                    //         ? Colors.green
                    //         : Colors.transparent,
                    fixedSize:
                        Size(60, (MediaQuery.of(context).size.width) / 7),
                    side: BorderSide(
                      color:
                          (widget.signatureLocations[widget.pageNumber - 1] ==
                                  1)
                              ? Colors.green
                              : Colors.grey,
                      width: 4.0,
                    ),
                    shadowColor:
                        (widget.signatureLocations[widget.pageNumber - 1] == 1)
                            ? Colors.green
                            : Colors.grey,
                    elevation:
                        (widget.signatureLocations[widget.pageNumber - 1] == 1)
                            ? 15
                            : 10,
                  ),
                  onPressed: () {
                    setState(
                        () => {pressedButton = (pressedButton == 1) ? 0 : 1});
                    widget.updateSignatureLocations(
                        widget.pageNumber, pressedButton);
                  },
                  child: Text(
                    'Left',
                    style: TextStyle(
                      color:
                          (widget.signatureLocations[widget.pageNumber - 1] ==
                                  1)
                              ? Colors.green
                              : Colors.transparent,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                SizedBox(
                  width: (MediaQuery.of(context).size.width) / 10,
                ),
                Expanded(
                    child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // backgroundColor:
                    //     (widget.signatureLocations[widget.pageNumber - 1] == 2)
                    //         ? Colors.green
                    //         : Colors.transparent,
                    fixedSize:
                        Size(60, (MediaQuery.of(context).size.width) / 7),
                    side: BorderSide(
                      color:
                          (widget.signatureLocations[widget.pageNumber - 1] ==
                                  2)
                              ? Colors.green
                              : Colors.grey,
                      width: 4.0,
                    ),
                    shadowColor:
                        (widget.signatureLocations[widget.pageNumber - 1] == 2)
                            ? Colors.green
                            : Colors.grey,
                    elevation:
                        (widget.signatureLocations[widget.pageNumber - 1] == 2)
                            ? 15
                            : 10,
                  ),
                  onPressed: () {
                    setState(
                        () => {pressedButton = (pressedButton == 2) ? 0 : 2});
                    widget.updateSignatureLocations(
                        widget.pageNumber, pressedButton);
                  },
                  child: Text(
                    'Middle',
                    style: TextStyle(
                      color:
                          (widget.signatureLocations[widget.pageNumber - 1] ==
                                  2)
                              ? Colors.green
                              : Colors.transparent,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                SizedBox(
                  width: (MediaQuery.of(context).size.width) / 10,
                ),
                Expanded(
                    child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // backgroundColor:
                    //     (widget.signatureLocations[widget.pageNumber - 1] == 3)
                    //         ? Colors.green
                    //         : Colors.transparent,
                    fixedSize:
                        Size(60, (MediaQuery.of(context).size.width) / 7),
                    side: BorderSide(
                      color:
                          (widget.signatureLocations[widget.pageNumber - 1] ==
                                  3)
                              ? Colors.green
                              : Colors.grey,
                      width: 4.0,
                    ),
                    shadowColor:
                        (widget.signatureLocations[widget.pageNumber - 1] == 3)
                            ? Colors.green
                            : Colors.grey,
                    elevation:
                        (widget.signatureLocations[widget.pageNumber - 1] == 3)
                            ? 15
                            : 10,
                  ),
                  onPressed: () {
                    setState(
                        () => {pressedButton = (pressedButton == 3) ? 0 : 3});
                    widget.updateSignatureLocations(
                        widget.pageNumber, pressedButton);
                  },
                  child: Text(
                    'Right',
                    style: TextStyle(
                      color:
                          (widget.signatureLocations[widget.pageNumber - 1] ==
                                  3)
                              ? Colors.green
                              : Colors.transparent,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ],
            ),
          );
  }
}
