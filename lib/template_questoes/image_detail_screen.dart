import '../share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'model.dart';

class ImageDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  //ProductDetailScreen(this.title, this.price);
  static const routeName = '/image-detail';

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as DetailScreenArguments;
    final grouping = arguments.grouping;
    Question question = arguments.question;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonHeight =
        48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
    double buttonWidth =
        133 > screenWidth * 0.3236 ? 133 : screenWidth * 0.3236;

    if (question.pieces[grouping]["image"].isEmpty)
      print('IMAGEM É VAZIA:${question.pieces[grouping]["image"]}');
    // final loadedProduct = Provider.of<Products>(
    //   context,
    //   listen: false,
    // ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
            top: 60,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Card(
                borderOnForeground: true,
                // color: Colors.blue[900],
                // margin: EdgeInsets.all(22),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0x3300004C), width: 2),
                ),
                child: Hero(
                  tag: grouping,
                  child: question.pieces[grouping]["image"].isNotEmpty
                      ? Image.network(
                          BASE_URL +
                              '/image/' +
                              question.pieces[grouping]["image"],
                          fit: BoxFit.fill,
                          width: screenWidth,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            question.pieces[grouping]["text"].toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fonteDaLetra,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ),
                ),
              ),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if (soundButton(context, question) != null)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: buttonBackground),
                      child: OutlineButton(
                        padding: EdgeInsets.all(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(0, 0, 255, 1),
                        ),
                        color: buttonBackground,
                        textColor: Color(0xFF0000FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Icon(
                          soundButton(context, question) != null
                              ? Icons.volume_up
                              : Icons.volume_off,
                          size: 40,
                          color: Color(0xFF0000FF),
                        ),
                        onPressed: () {
                          if (soundButton(context, question) != null) {
                            setState(() {
                              buttonBackground =
                                  Color(0xFF0000FF).withOpacity(0.2);
                            });
                            playSoundDetailScreen(question.header["sound"]);
                          }
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: buttonWidth,
                      height: buttonHeight,
                      child: OutlineButton(
                        padding: const EdgeInsets.all(6),
                        borderSide: BorderSide(
                          color: const Color.fromRGBO(0, 0, 255, 1),
                        ),
                        color: Colors.red,
                        textColor: const Color(0xFF0000FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'VOLTAR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFFF3300),
                              ),
                            ),
                            Icon(
                              Icons.close,
                              size: 32,
                              color: const Color(0xFFFF3300),
                            )
                          ],
                        ),
                        onPressed: () => {
                          player.stop(),
                          Navigator.of(context).pop(),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void playSoundDetailScreen(String sound) async {
    await player.play(BASE_URL + '/sound/' + sound);
    player.onPlayerCompletion.listen((event) {
      setState(() {
        buttonBackground = Colors.white;
      });
    });
  }
}

class DetailScreenArguments {
  Question question;
  String grouping;

  DetailScreenArguments({this.question, this.grouping});
}
