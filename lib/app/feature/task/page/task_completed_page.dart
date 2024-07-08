import 'package:flutter/material.dart';

import '../../home_offline/home_offline_module.dart';

class TaskCompletedPage extends StatelessWidget {
  const TaskCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Tarefa Concluída', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            Image(
              image: AssetImage('assets/img/personagem_comemorando_MATEUS_mat.png'),
              height: MediaQuery.of(context).size.height / 1.5,
            ),
            //botão de continuar bloco
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil("/auth-module", (route) => false);
              },
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
