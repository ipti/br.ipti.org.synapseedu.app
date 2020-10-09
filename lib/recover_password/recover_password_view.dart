import 'package:flutter/material.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final _nameTemplateController = TextEditingController();
  final _emailTemplateController = TextEditingController();
  String colegioValue;
  String serieValue;

//Navigator.of(context).pop();
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                child: Icon(
                  Icons.arrow_back,
                  size: _screenHeight * 0.05,
                ),
                margin: EdgeInsets.all(10),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              logo(),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Text(
                    "RECUPERAR SENHA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: _screenHeight * 0.05,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )),
              recoverInput(_nameTemplateController, 'Nome do Aluno'),
              schoolAndGrade(_screenWidth),
              recoverInput(_emailTemplateController, 'Email'),
              recoverPasswordButton(_screenWidth, _screenHeight),
            ],
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Expanded(
      child: Image(
        image: NetworkImage(
            'https://avatars2.githubusercontent.com/u/64334312?s=200&v=4',
            scale: 0.6),
      ),
    );
  }

  Widget recoverPasswordButton(double _screenWidth, double _screenHeight) {
    return GestureDetector(
      onTap: () {
        //todo criar função para recuperar senha do usuário
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        width: _screenWidth * 0.5,
        height: _screenHeight * 0.08,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: Center(
          child: Text(
            'RECUPERAR!',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget schoolAndGrade(double _screenWidth) {
    return Row(
      children: [
        schoolList(_screenWidth),
        Expanded(child: grade(_screenWidth)),
      ],
    );
  }

  Widget schoolList(double _screenWidth) {
    return Container(
      width: _screenWidth * 0.7,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green, width: 5),
      ),
      child: Center(
        child: DropdownButton<String>(
          hint: Text(
            'Selecione Um Colégio',
            style: TextStyle(color: Colors.black),
          ),
          value: colegioValue,
          icon: Expanded(
              child: Icon(
            Icons.arrow_drop_down,
            size: 40,
          )),
          elevation: 16,
          style: TextStyle(color: Colors.black, fontSize: 20),
          onChanged: (String newValue) {
            setState(() {
              colegioValue = newValue;
            });
          },
          //<=============== OS DADOS COM NOME DAS ESCOLAS DEVEM SER DEIXADOS AQUI =====================>
          items: <String>['Colégio 1', 'Colégio 2', 'Colégio 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget grade(double _screenWidth) {
    return Container(
      width: _screenWidth * 0.7,
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
      padding: EdgeInsets.only(top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green, width: 5),
      ),
      child: DropdownButton<String>(
        hint: Text(
          'Série',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        value: serieValue,
        icon: Expanded(
            child: Icon(
          Icons.arrow_drop_down,
          size: 40,
        )),
        elevation: 16,
        style: TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
            serieValue = newValue;
          });
        },
        //<=============== OS DADOS COM NOME DAS ESCOLAS DEVEM SER DEIXADOS AQUI =====================>
        items: <String>['9º ano', '8º ano', '7º ano']
            .map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget recoverInput(TextEditingController controller, String hintText) {
    return Container(
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 20),
        ),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.green,
            width: 5,
          )),
    );
  }
}
