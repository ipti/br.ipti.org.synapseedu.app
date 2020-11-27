import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'elesson_icon_lib_icons.dart';

class QrCodeReader extends StatefulWidget {
  const QrCodeReader({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  var qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.white,
                    borderRadius: 10,
                    borderWidth: 0,
                    cutOutSize: 200,
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Text(
                    'APONTE PARA O CÓDIGO \nQR PRESENTE NO SEU KIT',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(top: 24, left: 24),
              width: 50,
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(width: 2, color: Colors.white.withOpacity(0.4))),
              child: Icon(
                ElessonIconLib.chevron_left,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        controller.dispose();
        Navigator.pop(context,qrText);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
