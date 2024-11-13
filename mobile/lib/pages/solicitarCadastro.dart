import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/carteirinha.dart';
import 'package:wallet_mobile/pages/cadastro.dart';
import 'package:wallet_mobile/service/aluno_service.dart';
import '/components/footer.dart';

class requestRegistrationPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// Adiciona biometria
class _LoginPageState extends State<requestRegistrationPage> {
  bool _passwordVisible = false;
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _raController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    _passwordFocusNode.addListener(() {
      setState(() {
        // Mostra o ícone apenas quando o campo de senha está em foco
        _passwordVisible = _passwordFocusNode.hasFocus ? false : _passwordVisible;
      });
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _userPasswordController.dispose();
    _raController.dispose();
    super.dispose();
  }
  

  Future<DtoalunoLogin> solicitarValidacaoCarteirinha() async {
  
    var url = Uri.parse('http://192.168.34.215:8080/cronos/rest/service/solicitacao-carteirinha/validada');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      DtoalunoLogin alunoDto = DtoalunoLogin.fromJson(jsonData);
      return alunoDto;
    } else {
      throw Exception('Falha ao validar carteirinha: ${response.statusCode}');
    }
  }



  bool _isFormValid() {
    return _raController.text.isNotEmpty && _userPasswordController.text.isNotEmpty;
  }

  Future<void> enter() async {
    if (_raController.text.isNotEmpty && _userPasswordController.text.isNotEmpty) {
        Future<DtoalunoLogin?> dadosAlunoFuture = AlunoService.recuperarAlunoSalvo();
        DtoalunoLogin? dadosAluno = await dadosAlunoFuture; 

        // Se os dados do aluno já estiverem salvos localmente, vai direto para a CarteirinhaPage
        if (dadosAluno != null /* && dadosAluno.ra == _raController.text*/) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CarteirinhaPage()),
          );
          return; 
        }else{
          DtoalunoLogin dadosAlunoRecebidoDoBackend  = await solicitarValidacaoCarteirinha();
          if(dadosAlunoRecebidoDoBackend != null){
            AlunoService.salvarAluno(dadosAlunoRecebidoDoBackend);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CarteirinhaPage()),
            );

          }else{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Carteirinha não validada'),
                  content: Text('Sua carteirinha ainda não foi validada. Por favor, aguarde a liberação da secretaria.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o pop-up
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 50),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset("assets/app/ifprlogo.png"),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "ATENÇÃO",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(text: "Preencha os campos com o "),
                                TextSpan(
                                  text: "RA",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: " e "),
                                TextSpan(
                                  text: "senha",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: " correspondentes ao do "),
                                TextSpan(
                                  text: "Cronos",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "."),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  // Padding RA
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "R.A.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Padding RA
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      controller: _raController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "RA",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFCED1CE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Padding Senha
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Senha do Cronos",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),                 
                  // Padding Senha
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      controller: _userPasswordController,
                      focusNode: _passwordFocusNode,
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Senha do Cronos",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 172, 172, 172),
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFCED1CE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: _passwordFocusNode.hasFocus
                            ? Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              )
                            : null,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Padding Acessar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isFormValid() ? Color.fromARGB(255, 18, 129, 68) : Color.fromARGB(135, 84, 118, 99),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: TextButton(
                        child: Text(
                          "Solicitar Cadastro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CadastroPage()),
                          );
                        },                       
                      ),
                    ),
                  ),                  
                ],
              ),
            ),
            Footer(), // Adiciona o Footer aqui
          ],
        ),
      ),
    );
  }
}
