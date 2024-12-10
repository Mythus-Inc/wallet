import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/models/aluno.dart';
import 'package:wallet_mobile/values/preferences_key.dart';

class AlunoService{

  static Future<void> salvarAluno(DtoalunoLogin aluno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKey.chaveAcessoOuSobreescrita, json.encode(aluno.toJson()));
  }

  // Aqui deve ter um método que busca os dados de aluno no Backend (cronos)!!

  // static Future<DtoalunoLogin?> recuperarAlunoSalvo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? alunoJson = prefs.getString(PreferencesKey.chaveAcessoOuSobreescrita);
    
  //   if (alunoJson != null) {
  //     Map<String, dynamic> alunoMap = json.decode(alunoJson);
  //     return DtoalunoLogin.fromJson(alunoMap);
  //   }
  //   return null;
  // }
  static Future<DtoalunoLogin?> recuperarAlunoSalvo() async {
  // Simula que a operação foi bem-sucedida e retorna dados fixos
  return Future.value(
    DtoalunoLogin(
      nome: 'João Silva',
      ra: '123456',
      alunoTurma: null, // Ou uma lista vazia, conforme necessário
    ),
  );
}


}