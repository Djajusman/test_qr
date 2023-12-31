import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test_qr/services/api.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  String statusData = "";
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
                    // Text(
                    //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    Text(statusData)
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
                              // await postAchievement(result!.code ?? "No Data");
                              setState(() {});
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(101, 74, 94, 1)),
                            ),
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(101, 74, 94, 1)),
                            ),
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
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.pauseCamera();
//                             // Connect to Odoo and insert a record
//                             UserLoggedIn user = await odoo.connect(
//                                 Credential("ridwan@enviu.org", "Pl@stics123"));
//                             String tableName =
//                                 "hr.attendance.daily.achievement";
//                             Map<String, dynamic> args = {
//                               "employee_id": 1,
//                               "check_out_date": DateTime.now().toString(),
//                               "comment": "200",
//                             };
//                             // String tableName = "res.users";
//                             // Map<String, dynamic> args = {
//                             //   "login": "tester",
//                             //   "name": "tester"
//                             // };
// // await odoo.insert(tableName, args);
//                             print('Daily achievement created successfully!');
//                             await odoo.insert(tableName, args);

//                             try {
//                               // await odoo.callKW(tableName, 'create_daily_achievement', [args]);
//                               // String tableName = "res.users";
//                               // Map<String, dynamic> args = {"login": "tester", "name": "tester"};
//                               print('Daily achievement created successfully!');
//                             } catch (e) {
//                               print('Error creating daily achievement: $e');
//                             }
//                           },
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Color.fromRGBO(101, 74, 94, 1)),
//                           ),
//                           child: const Text('pause',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.all(8),
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await controller?.resumeCamera();
//                           },
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Color.fromRGBO(101, 74, 94, 1)),
//                           ),
//                           child: const Text('resume',
//                               style: TextStyle(fontSize: 20)),
//                         ),
//                       )
//                     ],
//                   ),
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
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: CameraFacing.back,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    await controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      // print(result!.code.toString());
      await controller.pauseCamera();
      var responString = await postAchievement(result!.code ?? "No Data");
      setState(() {
        statusData = responString;
      });
      await controller.resumeCamera();
      // // Connect to Odoo and insert a record
      // UserLoggedIn user =
      //     await odoo.connect(Credential("ridwan@enviu.org", "Pl@stics123"));
      // String tableName = "hr.attendance.daily.achievement";
      // Map<String, dynamic> args = {
      //   "employee_id": 1,
      //   "check_out_date": DateTime.now().toString(),
      //   "comment": "200",
      // };
      // print('Daily achievement created successfully!');
      // await odoo.insert(tableName, args);

      // try {
      //   // await odoo.callKW(tableName, 'create_daily_achievement', [args]);
      //   // String tableName = "res.users";
      //   // Map<String, dynamic> args = {"login": "tester", "name": "tester"};
      //   print('Daily achievement created successfully!');
      // } catch (e) {
      //   print('Error creating daily achievement: $e');
      // }
    });
  }

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
