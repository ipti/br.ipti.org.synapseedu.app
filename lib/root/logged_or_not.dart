import 'package:elesson/init_pages/space_selection.dart';
import 'package:elesson/root/start_and_send_test(descontinuada).dart';
import 'package:flutter/material.dart';

// ESSA É UMA BASE DE UM PROJETO MEU QUE USA FIREBASE E FUNCIONA COM O PERSISTENTE, PODEMOS USAR ELA COMO BASE PARA FAZER A NOSSA,
//É SÓ ADAPTAR O GETUSER PARA VERIFICAR SE ELE ESTÁ LOGADO

//ORDEM DE INICIALIZAÇÃO DO APP NO TRELLO

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class LoggedOrNot extends StatefulWidget {
  LoggedOrNot({this.auth});

  //final BaseAuth auth; // aqui entra a instancia onde ficam as classes de autenticação do usuário
  final auth; // essa linha está aqui só pra não dar erro enquanto a gente não está usando, mas está ERRADA

  @override
  State<StatefulWidget> createState() => new _LoggedOrNotState();
}

class _LoggedOrNotState extends State<LoggedOrNot> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  // ignore: non_constant_identifier_names
  Widget TelaDeEspera() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return TelaDeEspera();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new SpaceSelection(); // aqui vai para a pagina onde o usuario ainda não está logado
        // return new loginView(
        //   auth: widget.auth,
        //   loginCallback: loginCallback,
        // ); // aqui vai para a pagina onde o usuario ainda não está logado
        break;
      case AuthStatus.LOGGED_IN:
        return new StartAndSendTest(); // aqui vai para a pagina onde o usuario já está logado
        // return new homeView(
        //   userId: _userId,
        //   auth: widget.auth,
        //   logoutCallback: logoutCallback,
        // ); // aqui vai para a pagina onde o usuario já está logado
        break;
      default:
        return TelaDeEspera();
    }
  }
}
