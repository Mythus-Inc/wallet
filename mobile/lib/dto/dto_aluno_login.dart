import 'package:wallet_mobile/models/aluno.dart';

class DtoalunoLogin{
  final String ra;
  final String? nome;
  final String? email;
  final String? senha;
  final List<String>? alunoTurma;


 DtoalunoLogin({
    required this.ra,
    this.nome,
    this.email,
    this.senha,
    this.alunoTurma,
  });
  
  Map<String, dynamic> toJson()  {
    return  {
      'ra': ra,
      'nome': nome,
      'email': email,
      'senha': senha,
      'alunoTurma': []
    };
  }

  factory DtoalunoLogin.fromJson(Map<String, dynamic> json) {
    return DtoalunoLogin(
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      ra: json['ra'],
    );
  }
}