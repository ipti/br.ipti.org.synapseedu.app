import 'package:elesson/app/providers/block_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectUserPage extends StatefulWidget {
  const SelectUserPage({super.key});

  @override
  State<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BlockProvider _blockProvider = Provider.of<BlockProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Text("Digite o código do aluno"),
          TextFormField(controller: _idController),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home");
            },
            child: Text("Entrar"),
          )
        ],
      ),
    );
  }
}
