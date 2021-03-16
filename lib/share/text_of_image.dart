import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class TextOfImage extends StatefulWidget {
  @override
  _TextOfImageState createState() => _TextOfImageState();
}

class _TextOfImageState extends State<TextOfImage> {
  String base64Image;

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  Response retorno;
  String resultado = 'Texto de retorno';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.3,
            margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: imageFile != null
                  ? Image.file(imageFile)
                  : FlatButton(
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                ),
                onPressed: pickImage,
              ),
            ),
          ),
          Text(
            resultado,
            style: TextStyle(fontSize: size.height * 0.05),
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: TextButton(
              child: Text("ENVIAR"),
              onPressed: () async {
                await extractText();
                setState(() {
                  resultado = retorno.data["responses"][0]['textAnnotations'][0]['description'];
                });
              },
            ),
          )
        ],
      ),
    );
  }

  String privateKey;

  // função para receber token do google vision
  Future<void> getToken() async {
    try {
      Response response = await Dio().post(
        "https://oauth2.googleapis.com/token",
        options: Options(headers: {'user-agent': "google-oauth-playground"}, contentType: "application/x-www-form-urlencoded"),
        data: {
          "client_secret": "lbdHDSJaTT_E5DIWyBmHbNUY",
          "grant_type": "refresh_token",
          "refresh_token": "1//04bEr7OGoasT0CgYIARAAGAQSNwF-L9Ir3Ybq33sET3MqvVJHDz_bHtCMTU7HiVzQqzVJdrJ6dMx14qWZJs316-bRC3NQ3sLWlIA",
          "client_id": "552897848894-flkhs2oqtf7oofdqisusdgbbari82i2n.apps.googleusercontent.com"
        },
      );
      privateKey = "Bearer ${response.data['access_token']}";
    } catch (e) {
      print(e);
    }
  }

  // função para extrair texto da imagem enviando o base64 dela
  Future<void> extractText() async {
    try {
      retorno = await Dio().post(
        "https://vision.googleapis.com/v1/images:annotate",
        options: Options(headers: {'Authorization': privateKey}, contentType: "application/json"),
        data: {
          "requests": [
            {
              "image": {
                "content": base64Image,
              },
              "features": [
                {"type": "DOCUMENT_TEXT_DETECTION"}
              ]
            }
          ]
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // função para tirar foto
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front,);

    setState(() {
      imageFile = File(pickedFile.path);
    });

    base64Image = await converter();
  }

  File imageFile;

  final picker = ImagePicker();

  // função para converter imagem para base64
  Future<String> converter() async {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String convertido = base64Encode(imageBytes);
    return convertido;
  }
}
