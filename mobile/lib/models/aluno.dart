
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_mobile/values/preferences_key.dart';

class Aluno {
  String? nome;
  String? curso;
  int? ra;
  String? ingresso;
  String? validade;
  String? senha;

  Aluno({this.nome, this.curso, this.ra, this.ingresso, this.validade, this.senha});

  Aluno.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    curso = json['curso'];
    ra = json['ra'];
    ingresso = json['ingresso'];
    validade = json['validade'];
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['curso'] = this.curso;
    data['ra'] = this.ra;
    data['ingresso'] = this.ingresso;
    data['validade'] = this.validade;
    data['senha'] = this.senha;
    return data;
  }

  static void salvarAluno(Aluno aluno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKey.chaveAcessoOuSobreewscrita, json.encode(aluno.toJson()));
  }

}