import 'dart:io';
import 'package:elesson/share/turmas.dart';
import 'package:elesson/template_questoes/drag_and_drop.dart';
import 'package:elesson/template_questoes/multichoice.dart';
import 'package:elesson/template_questoes/text_question.dart';
import 'package:flutter/material.dart';
import 'package:elesson/share/api.dart';

/**
 * Form de seleção das atividades. A primeira tela após o usuário logar.
 * No momento, só temos a tela básica com dados falsos. Os próximos passos
 * envolvem a conexão com a API para e o polimento da tela em conjunto
 * com os designers do projeto.
 */

class ActivitySelectionForm extends StatefulWidget {
  @override
  _ActivitySelectionFormState createState() => new _ActivitySelectionFormState();
}

class _ActivitySelectionFormState extends State<ActivitySelectionForm> {
  final _formKey = GlobalKey<FormState>();

//<=====================================SELEÇÃO DE TURMAS E ALUNOS===========================================>
  List turmas = new List<dynamic>();
  List alunos = new List<dynamic>();

  String nome_turma_selecionada = "Selecione Sua Turma";
  var id_turma_selecionada;

  String nome_aluno_selecionada = "Selecione Sua Turma";
  var id_aluno_selecionada;
  bool valido;

  bool checkAluno = true;
  bool checkMateria = true;
  //<=======================JOGAR AQUI O ID DO COBJET RECEBIDO===========================>
  String ID_COBJECT = '3976';

  var Cobject = new List<dynamic>();
  var tipo_questao;
  //<===================================JOGAR AQUI O ID DA ESCOLA=============================================>
  String ID_ESCOLA = "51";

  _ActivitySelectionFormState() {
    _getTurmas(ID_ESCOLA);
  }
  //<=================================GETS DA API===============================================>
  _getTurmas(String id_escola) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
    API_TURMA.getTurmas(id_escola).then((response) {
      setState(() {
        turmas = response.data[0]["classroom"];
        //print('EXIBINDO: $turmas');
      });
    });
  }

  _getAlunos(String id_turma_recebido) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>]
    API_ALUNO.getAlunos(id_turma_recebido).then((response) {
      setState(() {
        valido = response.data[0]["valid"];
        alunos = response.data[0]["person"];
        //print(response);
      });
    });
  }

  _getCobject(String id_questao) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
    API_COBJECT.getQuestao(id_questao).then((response) {
      setState(() {
        Cobject = response.data;
        tipo_questao = Cobject[0]["cobjects"][0]["template_code"];
      });
      switch(tipo_questao){
        case 'PRE':
          Navigator.of(context).pushNamedAndRemoveUntil(TextQuestion.routeName, (Route<dynamic> route) => false,arguments: ScreenArguments(Cobject));
          break;
        case 'DDROP':
          Navigator.of(context).pushNamedAndRemoveUntil(DragAndDrop.routeName, (Route<dynamic> route) => false,arguments: ScreenArguments(Cobject));
          break;
        case 'MTE':
           Navigator.of(context).pushNamedAndRemoveUntil(MultipleChoiceQuestion.routeName, (Route<dynamic> route) => false,arguments: ScreenArguments(Cobject));
           break;
        // case 'TXT':
        //   Navigator.of(context).pushNamedAndRemoveUntil(DragAndDrop.routeName, (Route<dynamic> route) => false,arguments: ScreenArguments(Cobject));
        //   break;
      }
    });
  }

  //<=================================WIDGET DE SELEÇÃO DE TURMA E ALUNO===============================================>

  Widget TurmaENome(double alturaTela, double larguraTela) {
    return Column(
      children: [
        //<====TURMA=====>
        GestureDetector(
          onTap: () {
            showAlertDialog_Turma(context);
          },
          child: Container(
            width: larguraTela,
            height: alturaTela * 0.08,
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 3), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nome_turma_selecionada,
                  style: TextStyle(fontSize: alturaTela * 0.02),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(Icons.arrow_drop_down, size: alturaTela * 0.04),
              ],
            ),
          ),
        ),
        //<====NOME=====>
        GestureDetector(
          onTap: () {
            showAlertDialog_Aluno(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: larguraTela,
            height: alturaTela * 0.08,
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 3), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nome_aluno_selecionada,
                  style: TextStyle(fontSize: alturaTela * 0.02),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(Icons.arrow_drop_down, size: alturaTela * 0.04),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //<=================================DIALOG DE SELEÇÃO DE TURMA E ALUNO===============================================>

  showAlertDialog_Turma(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: turmas.length,
              itemBuilder: (context, index) {
                String nome_turma = turmas[index]["name"];
                String id_turma = turmas[index]["id"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      nome_turma_selecionada = nome_turma;
                      id_turma_selecionada = id_turma;
                    });
                    Navigator.of(context).pop();
                    _getAlunos(id_turma_selecionada);
                    print('''
                        Nome selecionado:  $nome_turma_selecionada
                        ID da turma selecionada: $id_turma_selecionada
                      ''');
                  },
                  child: ListTile(
                    title: Text(
                      nome_turma,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  showAlertDialog_Aluno(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                String nome_aluno = alunos[index]["name"];
                String id_aluno = alunos[index]["id"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      nome_aluno_selecionada = nome_aluno;
                      id_aluno_selecionada = id_aluno;
                      checkAluno = true;
                      Direcionar_Para_Questao();
                    });
                    Navigator.of(context).pop();
                    checkAluno = true;
                    Direcionar_Para_Questao();
                    print('''
                        Nome selecionado:  $nome_aluno_selecionada
                        ID o aluno selecionada: $id_aluno_selecionada
                      ''');
                  },
                  child: ListTile(
                    title: Text(
                      nome_aluno,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  //<===============================================================================>

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(
          'Elesson',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => {},
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: new ListView(
              children: [
                Text('Olá, usuário!'),
                SizedBox(
                  height: 10.0,
                ),
                //...getFormWidget(),
                TurmaENome(alturaTela, larguraTela),
                SizedBox(
                  height: 10.0,
                ),
                Text('Selecione a disciplina'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(
                      highlightElevation: 5.0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 24, color: Colors.red),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        setState(() {
                          checkMateria = true;
                          Direcionar_Para_Questao();
                        });
                      },
                      child: Text('Português'),
                    ),
                    OutlineButton(
                      color: Colors.amber,
                      highlightedBorderColor: Colors.red,
                      highlightElevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        setState(() {
                          checkMateria = true;
                          Direcionar_Para_Questao();
                        });
                      },
                      child: Text('Matemática'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('Ou acompanhe os alunos'),
                RaisedButton(
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () => {},
                  child: Text('Relatórios'),
                ),
              ],
            )),
      ),
    );
  }

  // FUNÇÃO PARA RECEBER OS DADOS DO COBJECT QUANDO A TURMA E O ALUNO FOR SELECIONADO
  void Direcionar_Para_Questao() {
    if (checkAluno == true && checkMateria == true) {
      _getCobject(ID_COBJECT);
    }
  }
}

class ScreenArguments {
  final List<dynamic> CObject;
  ScreenArguments(this.CObject);
}