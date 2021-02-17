import 'dart:ui';
import 'package:eventklip/screens/sign_up_screen.dart';
import 'package:eventklip/ui/widgets/animated_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  QRScanner();

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool torchEnabled = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  bool hasTorch = false;
  bool completed = false;

  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: buildScanner(context),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    Future.delayed(Duration(seconds: 2),(){
      _sendToSignUpScreen("4e6deeba-2ef1-4eda-80b1-8ab433261ad9");
    });
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {
        isScanned = true;
        try {
          var uri = Uri.parse(scanData.code);
          final adminId = uri.queryParameters["Id"];
          if (adminId != "" || adminId != null) {
            _sendToSignUpScreen(adminId);
          }
        } catch (e) {
          toast("Invalid QR Code");
          isScanned = false;
        }
      }
    });
  }
  //sign up
  //get token back
  //save token,save user type and user,setis logged in
  //fetch eventDetails from eventId/adminID??
  //fetch videos and images of user+eventId
  //fetch q& a

  _sendToSignUpScreen(String adminId) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return SignUpScreen(adminId: adminId);
    }));
    isScanned = false;
  }

  Widget _renderPreviewWidget() {
    return Stack(
      children: <Widget>[
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
        Column(
          children: <Widget>[
            Flexible(
                child: Container(
              color: Color.fromARGB(170, 0, 0, 0),
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Scanning",
                      style: boldTextStyle()
                          .copyWith(fontSize: 22, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 60),
                    ),
                    Text(
                      "Please wait.",
                      textAlign: TextAlign.center,
                      style: boldTextStyle()
                          .copyWith(fontSize: 12, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 45),
                    ),
                  ],
                ),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                  color: Color.fromARGB(170, 0, 0, 0),
                  height: 300,
                  width: 300,
                )),
                AnimatedScanner(),
                Expanded(
                    child: Container(
                  color: Color.fromARGB(170, 0, 0, 0),
                  height: 300,
                  width: 300,
                )),
              ],
            ),
            Flexible(
                child: Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(170, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 45),
                  ),
                  Text(
                    "Reading your event info.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )),
          ],
        ),
        Positioned(
          top: 40,
          left: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  Widget buildScanner(BuildContext context) {
    return _renderPreviewWidget();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
