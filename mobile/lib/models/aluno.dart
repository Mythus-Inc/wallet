
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Aluno {
  String? nome;
  String? curso;
  int? ra;
  String? ingresso;
  String? validade;

  Aluno({this.nome, this.curso, this.ra, this.ingresso, this.validade});

  Aluno.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    curso = json['curso'];
    ra = json['ra'];
    ingresso = json['ingresso'];
    validade = json['validade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['curso'] = this.curso;
    data['ra'] = this.ra;
    data['ingresso'] = this.ingresso;
    data['validade'] = this.validade;
    return data;
  }

  void _salvarAluno(Aluno aluno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("KEY_ACESSAR_OU_SOBREESCREVER", json.encode(aluno.toJson()));
  }

}