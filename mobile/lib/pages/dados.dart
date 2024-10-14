import 'dart:convert'; // Para usar json.decode e json.encode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import do SharedPreferences
import 'package:wallet_mobile/models/aluno.dart';

class Dados extends StatefulWidget {
  @override
  _DadosState createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  Aluno aluno = Aluno(
    nome: "Keren", 
    ra: 20226662, 
    ingresso: "2022-02", 
    validade: "2025", 
    curso: "Engenharia de Software", 
    senha: "********"
  );

  Aluno? alunoSalvo;

  @override
  void initState() {
    super.initState();
    salvarERecuperarAluno();
  }

  Future<void> salvarERecuperarAluno() async {
    // Salvando o aluno no SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('alunoSalvo', json.encode(aluno.toJson())); // Salvando os dados como String JSON

    // Recuperando o aluno salvo do SharedPreferences
    String? alunoJson = prefs.getString('alunoSalvo'); // Buscando os dados salvos
    if (alunoJson != null) {
      Map<String, dynamic> jsonMap = json.decode(alunoJson); // Convertendo para Map
      setState(() {
        alunoSalvo = Aluno.fromJson(jsonMap); // Usando o fromJson para reconstruir o objeto Aluno
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados do Aluno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: alunoSalvo != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${alunoSalvo!.nome}', style: TextStyle(fontSize: 18)),
                  Text('RA: ${alunoSalvo!.ra}', style: TextStyle(fontSize: 18)),
                  Text('Ingresso: ${alunoSalvo!.ingresso}', style: TextStyle(fontSize: 18)),
                  Text('Validade: ${alunoSalvo!.validade}', style: TextStyle(fontSize: 18)),
                  Text('Curso: ${alunoSalvo!.curso}', style: TextStyle(fontSize: 18)),
                  // Evitar mostrar senha na tela por questões de segurança
                ],
              )
            : Center(child: CircularProgressIndicator()), // Mostra um loading enquanto os dados são carregados
      ),
    );
  }
}
