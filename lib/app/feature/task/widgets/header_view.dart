import 'package:elesson/app/core/task/data/model/container_model.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/share/snackbar_widget.dart';
import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  final ContainerModel containerModel;
  HeaderView({Key? key, required this.containerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double heightTopScreen = size.height - 24;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: size.width,
      height: heightTopScreen,
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                containerModel.description ?? "",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: fonteDaLetra, fontFamily: 'Mulish'),
              ),
            ),
            height: ((size.height - 24) * 0.145) - 12,
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(top: 12),
          ),
          true
              ? Expanded(
            child: Container(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: heightTopScreen,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      width: 2,
                      color: Color.fromRGBO(110, 114, 145, 0.2),
                    ),
                  ),
                  child: Image.network(
                    "https://www.google.com/url?sa=i&url=http%3A%2F%2Fcbissn.ibict.br%2Findex.php%2Fimagens%2F1-galeria-de-imagens-01%2Fdetail%2F3-imagem-3-titulo-com-ate-45-caracteres&psig=AOvVaw1NTgONRQcPqsabgcNrGkKf&ust=1684463637119000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCKDYyK7q_f4CFQAAAAAdAAAAABAE",
                    fit: BoxFit.cover,
                    errorBuilder: (context, exception, stackTrace) {
                      callSnackBar(context);
                      return Container();
                    },
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              padding: EdgeInsets.only(left: 16, right: 16),
              height: heightTopScreen * 0.70,
            ),
          )
              : Container(
            height: size.width,
          ),
          Container(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  //kevenny aqui
                  // playerTituloSegundaTela.resume();
                },
                child: Container(padding: EdgeInsets.only(right: 20, left: 20), child: Text("widget.text")),
              ),
            ),
            height: size.height * 0.145,
            padding: EdgeInsets.only(left: 16, right: 16),
          ),
        ],
      ),
    );
  }
}