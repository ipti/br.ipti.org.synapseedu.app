// import 'package:elesson/share/turmas.dart';
import 'package:elesson/template_questoes/drag_and_drop.dart';
import 'package:elesson/template_questoes/multichoice.dart';
import 'package:elesson/template_questoes/text.dart';
import 'package:elesson/template_questoes/question_and_answer.dart';
import 'package:flutter/material.dart';
import 'package:elesson/share/api.dart';

// Form de seleção das atividades. A primeira tela após o usuário logar.
// No momento, só temos a tela básica com dados falsos. Os próximos passos
// envolvem a conexão com a API para e o polimento da tela em conjunto
// com os designers do projeto.

class ActivitySelectionForm extends StatefulWidget {
  @override
  _ActivitySelectionFormState createState() =>
      new _ActivitySelectionFormState();
}

class _ActivitySelectionFormState extends State<ActivitySelectionForm> {
  final _formKey = GlobalKey<FormState>();

//<=====================================SELEÇÃO DE TURMAS E ALUNOS===========================================>
  List classes = new List<dynamic>();
  List students = new List<dynamic>();

  String selectedNameClass = "Selecione Sua Turma";
  var selectedIdClass;

  String selectedNamestudents = "Selecionar aluno(a)";
  var selectedIdstudents;
  bool valid;

  bool checkStudent = true;
  bool checkDiscipline = true;
  //<=======================JOGAR AQUI O ID DO COBJET RECEBIDO===========================>
  String cobjectId = '3977';

  var cobject = new List<dynamic>();
  var questionType;
  //<===================================JOGAR AQUI O ID DA ESCOLA=============================================>
  String schoolId = "51";

  _ActivitySelectionFormState() {
    _getTurmas(schoolId);
  }
  //<===================================PARA OS TESTES =======================================================>
  List questionTypeList = ['MTE', 'PRE', 'DAD', 'TXT'];
  String typeSelected = "Selecione o tipo da questão";

  //<=================================GETS DA API===============================================>
  _getTurmas(String schoolId) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
    API_TURMA.getTurmas(schoolId).then((response) {
      setState(() {
        classes = response.data[0]["classroom"];
        //print('EXIBINDO: $turmas');
      });
    });
  }

  _getAlunos(String classIdReceived) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
    API_ALUNO.getAlunos(classIdReceived).then((response) {
      setState(() {
        valid = response.data[0]["valid"];
        students = response.data[0]["person"];
        //print(response);
      });
    });
  }

  _getCobject(String questionId) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
    API_COBJECT.getQuestao(questionId).then((response) {
      setState(() {
        cobject = response.data;
        questionType = cobject[0]["cobjects"][0]["template_code"];
      });
      switch (questionType) {
        // pushNamedAndRemoveUntil
        // case 'PRE':
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       TextQuestion.routeName, (Route<dynamic> route) => false,
        //       arguments: ScreenArguments(cobject));
        //   break;
        // case 'DDROP':
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       DragAndDrop.routeName, (Route<dynamic> route) => false,
        //       arguments: ScreenArguments(cobject));
        //   break;
        // case 'MTE':
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       MultipleChoiceQuestion.routeName, (Route<dynamic> route) => false,
        //       arguments: ScreenArguments(cobject));
        //   break;
        // case 'TXT':
        //   Navigator.of(context).pushNamedAndRemoveUntil(DragAndDrop.routeName, (Route<dynamic> route) => false,arguments: ScreenArguments(cobject));
        //   break;
        case 'PRE':
          Navigator.of(context).pushNamed(TextQuestion.routeName,
              arguments: ScreenArguments(cobject,0));
          break;
        case 'DDROP':
          Navigator.of(context).pushNamed(DragAndDrop.routeName,
              arguments: ScreenArguments(cobject,0));
          break;
        case 'MTE':
          Navigator.of(context).pushNamed(MultipleChoiceQuestion.routeName,
              arguments: ScreenArguments(cobject,0));
          break;
        case 'TXT':
          Navigator.of(context).pushNamed(TXTQuestion.routeName,
              arguments: ScreenArguments(cobject,0));
          break;
      }
    });
  }

  //<=================================WIDGET DE SELEÇÃO DE TURMA E ALUNO===============================================>

  Widget classAndName(double heightScreen, double widthScreen) {
    return Column(
      children: [
        //<====TURMA=====>
        GestureDetector(
          onTap: () {
            classAlertDialog(context);
          },
          child: Container(
            width: widthScreen,
            height: heightScreen * 0.08,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedNameClass,
                  style: TextStyle(fontSize: heightScreen * 0.02),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(Icons.arrow_drop_down, size: heightScreen * 0.04),
              ],
            ),
          ),
        ),
        //<====NOME=====>
        GestureDetector(
          onTap: () {
            // studentAlertDialog(context);
            showQuestionAlertDialog(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: widthScreen,
            height: heightScreen * 0.08,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  typeSelected,
                  style: TextStyle(fontSize: heightScreen * 0.02),
                  overflow: TextOverflow.ellipsis,
                ),
                Icon(Icons.arrow_drop_down, size: heightScreen * 0.04),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //<=================================DIALOG DE SELEÇÃO DE TURMA E ALUNO===============================================>

  classAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                String className = classes[index]["name"];
                String classId = classes[index]["id"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedNameClass = className;
                      selectedIdClass = classId;
                    });
                    Navigator.of(context).pop();
                    _getAlunos(selectedIdClass);
                    print('''
                        Nome selecionado:  $selectedNameClass
                        ID da turma selecionada: $selectedIdClass
                      ''');
                  },
                  child: ListTile(
                    title: Text(
                      className,
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

  studentAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                String studentName = students[index]["name"];
                String studentId = students[index]["id"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedNamestudents = studentName;
                      selectedIdstudents = studentId;
                      checkStudent = true;
                      redirectToQuestion();
                    });
                    Navigator.of(context).pop();
                    checkStudent = true;
                    // print('''
                    //     Nome selecionado:  $nomeAlunoSelecionado
                    //     ID o aluno selecionada: $id_aluno_selecionada
                    //   ''');
                  },
                  child: ListTile(
                    title: Text(
                      studentName,
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

  showQuestionAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: questionTypeList.length,
              itemBuilder: (context, index) {
                String qType = questionTypeList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      typeSelected = qType;
                      checkStudent = true;
                      switch (typeSelected) {
                        case "MTE":
                          cobjectId = "3976";
                          break;
                        case "PRE":
                          cobjectId = "3977";
                          break;
                        case "DAD":
                          cobjectId = "3987";
                          break;
                        case "TXT":
                          cobjectId = "3988";
                          break;
                      }
                      redirectToQuestion();
                    });
                    Navigator.of(context).pop();
                    checkStudent = true;
                  },
                  child: ListTile(
                    title: Text(
                      questionTypeList[index],
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
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
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
                classAndName(heightScreen, widthScreen),
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
                          checkDiscipline = true;
                          redirectToQuestion();
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
                          checkDiscipline = true;
                          redirectToQuestion();
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
  void redirectToQuestion() {
    if (checkStudent == true && checkDiscipline == true) {
      _getCobject(cobjectId);
    }
  }
}

class ScreenArguments {
  final List<dynamic> cobject;
  final int questionIndex;
  ScreenArguments(this.cobject, this.questionIndex);
}
