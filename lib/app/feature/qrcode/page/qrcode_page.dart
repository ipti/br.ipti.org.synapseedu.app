import 'dart:convert';

import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../settings/settings_screen.dart';
import '../../../core/auth/domain/entity/login_response_entity.dart';
import '../../../core/qrcode/domain/entity/block_parameters_entity.dart';
import '../controller/qrcode_controller.dart';


class QrCodePage extends StatefulWidget {
  static const routeName = '/qr_code';

  final QrCodeController qrCodeController;

  QrCodePage({required this.qrCodeController});

  @override
  State<StatefulWidget> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  bool showLoading = false;
  var qrText = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Color colorToTimerOut = Colors.white;
  String textToTimeout = "APONTE PARA A CHAVE \n DE ACESSO";

  void timerOut() {
    setState(() {
      colorToTimerOut = Colors.red;
      textToTimeout = "NÃO FOI POSSÍVEL \nVALIDAR O CÓGIGO QR";
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: heightScreen * 0.77,
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
                Stack(
                  children: [

                    Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height * 0.23,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        margin: EdgeInsets.only(top: 24),
                        child: Text(
                          widget.qrCodeController.screenMessage,
                          style: TextStyle(
                            color: colorToTimerOut,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        alignment: Alignment.topLeft,
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(),)),
                        icon: Icon(Icons.settings,color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(top: heightScreen * 0.77 - 100, left: widthScreen / 2 - 50),
            child: showLoading == true ? loadingAnimation() : null,
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      qrText = scanData.code ?? '';
      controller.pauseCamera();
      Map<String, dynamic> jsonMaped = json.decode(qrText);
      BlockParameterEntity blockParameterEntity = BlockParameterEntity.fromJson(jsonMaped);
      print("FROMM QR CODE: ${blockParameterEntity.toJson()}");
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(LoginResponseEntity(id: blockParameterEntity.studentId,name: "Aluno", user_name: "Aluno", user_type_id: 3));
      widget.qrCodeController.getBlock(context, blockParameterEntity);
    });
  }
}
