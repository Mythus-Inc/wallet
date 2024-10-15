import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_mobile/models/aluno.dart';
import 'package:wallet_mobile/values/preferences_key.dart';

class AlunoService{

  static Future<void> salvarAluno(Aluno aluno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferencesKey.chaveAcessoOuSobreescrita, json.encode(aluno.toJson()));
  }

  // Aqui deve ter um método que busca os dados de aluno no Backend (cronos)!!

  static Future<Aluno?> recuperarAlunoSalvo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? alunoJson = prefs.getString(PreferencesKey.chaveAcessoOuSobreescrita);
    
    if (alunoJson != null) {
      Map<String, dynamic> alunoMap = json.decode(alunoJson);
      return Aluno.fromJson(alunoMap);
    }
    return null;
  }
}