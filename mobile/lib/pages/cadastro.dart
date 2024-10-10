import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final TextEditingController _raController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _raController,
              decoration: InputDecoration(
                labelText: 'RA',
              ),
            ),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmarSenhaController,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _raController.dispose();
    super.dispose();
  }
}