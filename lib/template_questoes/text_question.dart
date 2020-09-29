import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class TextQuestion extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
  }

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  void submitButton(BuildContext context) {
    // print(context.read(buttonStateProvider).state);
    context.read(buttonStateProvider).state = true;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final buttonState = watch(buttonStateProvider).state;
    bool image = true;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Elesson',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.exit_to_app),
      //       onPressed: () => {},
      //     )
      //   ],
      // ),
      body: TemplateSlider(
        title: Text(
          "Texto da questão",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        image: Image.network(
            'http://1.bp.blogspot.com/-Dk9tb3fDa68/UUN932BEVHI/AAAAAAAABNs/iqm8mdkMoA8/s1600/cubo_magico_montado.png'),
        activityScreen: Container(
          margin: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (image == true) Image.asset('assets/img/logo.png'),
                Text(
                  'Como visto acima, faça pipipipopopó',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 15),
                Card(
                  child: TextFormField(
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    controller: _textController,
                    autofocus: false,
                    style: TextStyle(fontSize: 22.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Escreva a resposta aqui',
                      contentPadding: const EdgeInsets.all(8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                    // Utiliza o onChanged em conjunto com o provider para renderizar a UI assim que o form
                    // receber um texto, acionando o botão. O condicional faz com que a UI seja renderizada
                    // apenas uma vez enquanto o texto estiver sendo digitado.
                    onChanged: (val) {
                      if (_textController.text.length == 1) {
                        print('hello');
                        submitButton(context);
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Não se esqueça de digitar a resposta!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                if (_textController.text.isNotEmpty)
                  MaterialButton(
                    onPressed: () {
                      print(_textController.text);
                    },
                    minWidth: 200.0,
                    height: 45.0,
                    color: Theme.of(context).primaryColor,
                    splashColor: Theme.of(context).accentColor,
                    child: Text(
                      "Enviar Resposta",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Alike",
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                    ),
                  ),
                // if(_textController.text.isNotEmpty) {
                //   submitButton(context)
                // },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
