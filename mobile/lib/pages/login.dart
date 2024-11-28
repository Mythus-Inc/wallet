import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/carteirinha.dart';
import 'package:wallet_mobile/pages/cadastro.dart';
import 'package:wallet_mobile/service/aluno_service.dart';
import 'package:wallet_mobile/widgets/service/biometric_service.dart';
import '/components/footer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// Adiciona biometria
class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _passwordVisible = false;
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _raController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  late BiometricService biometricService;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    biometricService = BiometricService();
    
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

  Future<void> authenticateUser() async {
    isAuthenticated = await biometricService.authenticate();
    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CarteirinhaPage()),
      );
    } 
  }

  

  Future<DtoalunoLogin> solicitarValidacaoCarteirinha() async {
  
    var url = Uri.parse('http://192.168.80.215:8080/cronos/rest/service/solicitacao-carteirinha/validada');
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

  Future<bool> loginCronos() async {
  
    var url = Uri.parse('http://192.168.80.215:8080/cronos/rest/service/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'ra': _raController.text,
        'senha': _userPasswordController.text,
      }),
    );

    if(response.statusCode == 200){
     return true;
    }else{
      return false;
    }
  }


  bool _isFormValid() {
    return _raController.text.isNotEmpty && _userPasswordController.text.isNotEmpty;
  }

  Future<void> enter() async {
    if (_isFormValid()) {
        bool eLoginValido = await loginCronos();
        print("resultado login: $eLoginValido");
        if(eLoginValido){
            Future<DtoalunoLogin?> dadosAlunoFuture = AlunoService.recuperarAlunoSalvo();
            DtoalunoLogin? dadosAluno = await dadosAlunoFuture; 

            if (dadosAluno != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CarteirinhaPage()),
              );
              return; 
            }else{
              DtoalunoLogin dadosAlunoRecebidoDoBackend  = await solicitarValidacaoCarteirinha();
              AlunoService.salvarAluno(dadosAlunoRecebidoDoBackend);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CarteirinhaPage()),
              );

                      }
        }else{
          showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Login inválido'),
                      content: Text('Sua senha ou ra está incorreto, lembre-se que são os mesmos dados utilizados para acessar o cronos!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); 
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
                  SizedBox(height: 30),
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
                      "Senha",
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
                        labelText: "Senha",
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
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Login com biometria",
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            setState(() {
                              _rememberMe = value;
                              if(_rememberMe){
                                biometricService.autenticar();
                                authenticateUser();
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                          "Acessar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: (){enter();},
                        
                      ),
                    ),
                  ),
                  // Padding Recuperar Senha
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text("Cadastrar nova senha"),
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
