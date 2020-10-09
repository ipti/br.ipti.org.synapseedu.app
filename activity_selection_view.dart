import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  int _selectedSchool = 0;
  int _selectedStudent = 0;

  List<DropdownMenuItem<int>> schoolList = [];
  List<DropdownMenuItem<int>> studentList = [];

  void loadSchoolList() {
    schoolList = [];
    schoolList.add(new DropdownMenuItem(
      child: new Text('Escola 1'),
      value: 0,
    ));
    schoolList.add(new DropdownMenuItem(
      child: new Text('Escola 2'),
      value: 1,
    ));
    schoolList.add(new DropdownMenuItem(
      child: new Text('Escola 3'),
      value: 2,
    ));
  }

  void loadStudentList() {
    studentList = [];
    studentList.add(new DropdownMenuItem(
      child: new Text('Aluno 1'),
      value: 0,
    ));
    studentList.add(new DropdownMenuItem(
      child: new Text('Aluno 2'),
      value: 1,
    ));
    studentList.add(new DropdownMenuItem(
      child: new Text('Aluno 3'),
      value: 2,
    ));
  }

  @override
  Widget build(BuildContext context) {
    loadSchoolList();
    loadStudentList();
    return Scaffold(
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
                ...getFormWidget(),
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
                      onPressed: () => {},
                      child: Text('Português'),
                    ),
                    OutlineButton(
                      color: Colors.amber,
                      highlightedBorderColor: Colors.red,
                      highlightElevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      onPressed: () => {},
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

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(new DropdownButton(
      hint: new Text('Escolher Escola'),
      items: schoolList,
      value: _selectedSchool,
      onChanged: (value) {
        setState(() {
          _selectedSchool = value;
        });
      },
      isExpanded: true,
    ));

    formWidget.add(new DropdownButton(
      hint: new Text('Escolher Aluno'),
      items: studentList,
      value: _selectedStudent,
      onChanged: (value) {
        setState(() {
          _selectedStudent = value;
        });
      },
      isExpanded: true,
    ));

    return formWidget;
  }
}
