import 'package:flutter/material.dart';
import '../components/header.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: Header(
          title: 'Wallet - IFPR',
          onBackPressed: () {
            // Ação ao clicar na seta de retorno
            Navigator.of(context).pop();
          },
        ),
        body: Center(
          child: Text('Conteúdo principal'),
        ),
      ),
    );
  }
}