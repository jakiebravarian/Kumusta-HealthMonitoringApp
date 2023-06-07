import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_app/providers/log_provider.dart';
import 'package:project_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/log_model.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // if (result?.code != null || result?.code == "") {
    //   try {
    //     final map = jsonDecode(result!.code!);
    //     print(map);
    //   } catch (e) {

    //       return ApiResponse.failed<ResultType>(Error(e.response.statusCode,
    //           e.response.statusMessage, jsonEncode(e.response.data)));

    //   }
    // }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  // Text(
                  //   'Var Type: ${result!.code!}   Data: ${result!.code}')

                  // Map<String, dynamic> map = jsonDecode(result!.code!);
                  // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  // _showScannedDataDialog(map);
                  // context.read<LogsProvider>().addLog(Log.fromJson(map));

                  // print(map);
                  // Perform your desired actions with the scanned map here

                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Future _showScannedDataDialog(Map<String, dynamic> scannedData) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Data'),
          content: Column(children: [
            ...scannedData.entries
                .map((entry) => ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    ))
                .toList(),
            (scannedData["date"] == currentDate)
                ? const Text("Valid QR Pass")
                : const Text("Invalid QR Pass"),
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                if (scannedData["date"] == currentDate) {
                  context
                      .read<LogsProvider>()
                      .addLog(Log.fromJson(scannedData));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    if (!context.read<UserProvider>().hasScanned) {
      controller.scannedDataStream.listen((scanData) {
        controller.pauseCamera();
        context.read<UserProvider>().setHasScanned(true);
        Map<String, dynamic> stringData = jsonDecode(scanData.code!);
        _showScannedDataDialog(stringData);
      });

      // _showScannedDataDialog(map);
    }
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     if (!hasScanned) {
  //       setState(() {
  //         hasScanned = true;
  //       });
  //     }

  //     result = scanData;
  //     try {
  //       Map<String, dynamic> map = jsonDecode(result!.code!);
  //       String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //       _showScannedDataDialog(map);
  //       // context.read<LogsProvider>().addLog(Log.fromJson(map));

  //       print(map);
  //       // Perform your desired actions with the scanned map here
  //     } catch (e) {
  //       print('Error parsing JSON: $e');
  //     }
  //   });
  // }

  // void _onQRViewCreated(QRViewController controller) {
  //   bool hasScanned = false;

  //   controller.scannedDataStream.listen((scanData) {
  //     if (!hasScanned) {
  //       setState(() {
  //         hasScanned = true;
  //         result = scanData;
  //         Map<String, dynamic> map = jsonDecode(result!.code!);
  //         String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //         print(map);
  //         // Perform your desired actions with the scanned map here
  //       });
  //     }
  //   });
  // }

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //       Map<String, dynamic> map = jsonDecode(result!.code!);
  //       // Log log = Log();
  //       // log = Log.fromJson(result!.code as Map<String, dynamic>);
  //       String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //       print(map);
  //       // controller.pauseCamera();
  //       // if (log.date == currentDate) {
  //       //   context.read<LogsProvider>().addLog(log);
  //       // } else {
  //       //   print("INVALID");
  //       // }
  //     });
  //   });
  //   controller.resumeCamera();
  // }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
