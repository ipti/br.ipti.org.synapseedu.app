import 'package:flutter/material.dart';

class TaskCompletedPage extends StatelessWidget {
  const TaskCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Tarefa Concluída', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          Image(image: AssetImage('assets/img/personagem_comemorando_MATEUS_mat.png')),
        ],
      ),);
  }
}
