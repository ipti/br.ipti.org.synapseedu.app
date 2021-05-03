import 'package:elesson/share/general_widgets.dart';
import 'package:flutter/material.dart';

class DegreeSelectionView extends StatefulWidget {
  int cobjectIdIndex;
  String disciplineId;
  String discipline;
  String blockId;

  DegreeSelectionView(
      {Key key,
      int cobjectIdIndex,
      String disciplineId,
      String discipline,
      String blockId})
      : super(key: key);
  static const routeName = '/degree-selection';

  @override
  _DegreeSelectionViewState createState() => _DegreeSelectionViewState();
}

class _DegreeSelectionViewState extends State<DegreeSelectionView> {
  String dropdownYear = null;

  void getTrialBlockByYear() {
    print(widget.discipline);
    // redirectToQuestion();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(
                text: "Selecione o seu ano",
                heightScreen: size.height,
                bottomMargin: 36),
            DropdownButton<String>(
              value: dropdownYear,
              icon: const Icon(
                Icons.arrow_downward,
                color: Color.fromRGBO(0, 0, 255, 1),
              ),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),
              underline: Container(
                height: 2,
                color: Color.fromRGBO(0, 0, 255, 0.4),
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownYear = newValue;
                });
              },
              hint: Text('Escolha o ano'),
              items: <String>['1', '2', '3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value + 'º ANO'),
                );
              }).toList(),
            ),
            ButtonTheme(
              // minWidth: size.height < 823 ? 48 : 64,
              // height: size.height < 823 ? 48 : 64,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: const BorderSide(
                    color: Color.fromRGBO(0, 0, 255, 0.2),
                  ),
                ),
                // padding: const EdgeInsets.all(0),
                // borderSide: const BorderSide(
                //   color: Color.fromRGBO(0, 0, 255, 0.2),
                // ),
                // color: Colors.white,
                // textColor: const Color(0xFF0000FF),

                child: Text(
                  'CONFIRMAR',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(0, 0, 255, 1),
                  ),
                ),
                onPressed: () {
                  getTrialBlockByYear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
