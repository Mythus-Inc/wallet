import 'package:flutter/material.dart';
import '/components/footer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _userPasswordController = TextEditingController();
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
    super.dispose();
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
                    width: 180,
                    height: 180,
                    child: Image.asset("assets/app/ifprlogo.png"),
                  ),
                  SizedBox(height: 100),
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
                                padding: const EdgeInsets.only(right: 3.0),
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
                        color: Color.fromARGB(255, 18, 129, 68),
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
                        onPressed: () {},
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
                        child: Text("Recuperar Senha"),
                        onPressed: () {},
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
