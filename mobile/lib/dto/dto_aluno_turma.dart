import 'package:flutter/material.dart';

class DtoAlunoTurma{

  String? ra;
  String? turma;
  String? curso;
  String ? dataMatricula;
  String? validade;


  DtoAlunoTurma(this.ra, this.turma, this.curso, this.dataMatricula, this.validade){
    this.dataMatricula = dataMatricula;
    this.validade = _calcularValidade(dataMatricula);
  }

  String? _calcularValidade(String? dataMatricula) {
    if (dataMatricula != null && dataMatricula.isNotEmpty) {
      DateTime matriculaDate = DateTime.parse(dataMatricula);
      DateTime validadeDate = DateTime(matriculaDate.year + 4);
      return '${validadeDate.year}';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'ra': ra,
      'turma': turma,
      'curso': curso,
      'validade': validade,
      'dataMatricula': dataMatricula?.toString(),
    };
  }

  factory DtoAlunoTurma.fromJson(Map<String, dynamic> json) {
    return DtoAlunoTurma(
      json['ra'],
      json['turma'],
      json['curso'],
      json['dataMatricula'],
      json['validade'],
    );
  }


}