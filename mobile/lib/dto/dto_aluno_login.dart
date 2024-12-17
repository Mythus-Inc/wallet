import 'package:wallet_mobile/dto/dto_aluno_turma.dart';

class DtoalunoLogin{
  final String ra;
  String? nome;
  String? email;
  String? senha;
  String? foto;
  List<DtoAlunoTurma>? alunoTurma;


 DtoalunoLogin({
    required this.ra,
    this.nome,
    this.email,
    this.senha,
    this.alunoTurma,
    this.foto,
  });
  
  Map<String, dynamic> toJson()  {
    return  {
      'ra': ra,
      'nome': nome,
      'email': email,
      'senha': senha,
      'foto': foto,
      'alunoTurma': alunoTurma?.map((turma) => turma.toJson()).toList() ?? []
    };
  }

  factory DtoalunoLogin.fromJson(Map<String, dynamic> json) {
    return DtoalunoLogin(
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      ra: json['ra'],
      foto: json['foto'],
      alunoTurma: (json['alunoTurma'] as List<dynamic>?)
          ?.map((turma) => DtoAlunoTurma.fromJson(turma))
          .toList(),
    );
  }
}