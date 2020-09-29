import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _templateController = TextEditingController();
  final _2templateController = TextEditingController();
  final _3templateController = TextEditingController();
  final _4templateController = TextEditingController();
  //CRIAR TEXTCONTROLLERS PARA CADA ENTRADA

  String colegioValue = null;
  String serieValue = null;

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Logo(),
          Entrada(_templateController, 'Nome Do Responsavel'),
          Entrada(_2templateController, 'Nome do Aluno'),
          EscolaESerie(larguraTela),
          Entrada(_3templateController, 'Email'),
          Entrada(_4templateController, 'Senha'),
          BtnCadastrar(larguraTela, alturaTela),
        ],
      ),
    );
  }

  Widget Logo() {
    return Expanded(
      child: Image(
        image: NetworkImage('https://avatars2.githubusercontent.com/u/64334312?s=200&v=4', scale: 0.7),
      ),
    );
  }

  Widget BtnCadastrar(double larguraTela, double alturaTela) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: larguraTela * 0.5,
      height: alturaTela * 0.08,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: Center(
        child: Text(
          'CADASTRAR!',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  Widget EscolaESerie(double larguraTela) {
    return Row(
      children: [
        SchoolList(larguraTela),
        Expanded(child: Serie(larguraTela)),
      ],
    );
  }

  Widget SchoolList(double larguraTela) {
    return Container(
      width: larguraTela * 0.7,
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
          style: TextStyle(color: Colors.black,fontSize: 20),
          onChanged: (String newValue) {
            setState(() {
              colegioValue = newValue;
            });
          },
          //<=============== OS DADOS COM NOME DAS ESCOLAS DEVEM SER DEIXADOS AQUI =====================>
          items: <String>['Colégio 1', 'Colégio 2', 'Colégio 3'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget Serie(double larguraTela) {
    return Container(
      width: larguraTela * 0.7,
      margin: EdgeInsets.only(top: 10,bottom: 10,right: 10),
      padding: EdgeInsets.only(top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green, width: 5),
      ),
      child: DropdownButton<String>(
        hint: Text(
          'Série',
          style: TextStyle(color: Colors.black,fontSize: 20),
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
        items: <String>['9º ano', '8º ano', '7º ano'].map<DropdownMenuItem<String>>(
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

  //<====parametros(controller , texto inicial)====>
  Widget Entrada(TextEditingController controller, String hintText) {
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
