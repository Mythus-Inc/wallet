import 'dart:io';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_mobile/components/footer.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _confirmUserPasswordController = TextEditingController();
  final TextEditingController _raController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _passwordFocusNode.addListener(() {
      setState(() {
        _passwordVisible = _passwordFocusNode.hasFocus ? false : _passwordVisible;
      });
    });

    _confirmPasswordFocusNode.addListener(() {
      setState(() {
        _confirmPasswordVisible = _confirmPasswordFocusNode.hasFocus ? false : _confirmPasswordVisible;
      });
    });
  }

  bool _isFormValid() {
    return _userPasswordController.text.isNotEmpty && 
           _confirmUserPasswordController.text.isNotEmpty && 
           _raController.text.isNotEmpty && 
           _imageFile != null;
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _userPasswordController.dispose();
    _confirmUserPasswordController.dispose();
    super.dispose();
  }

  pick(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void _showAvatarOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tirar Foto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Tirar uma nova foto"),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera); 
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Remover foto"),
                onTap: () {
                  Navigator.of(context).pop();
                  _removeImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Função para enviar os dados para o servidor
  void _solicitarCadastro() async {
    if (_isFormValid()) {
      try {
        // Prepara os dados para envio
        var uri = Uri.parse('https://example.com/cadastro'); // Substituir pelo endpoint
        var request = http.MultipartRequest('POST', uri);

        // Adiciona RA e Senha
        request.fields['ra'] = _raController.text;
        request.fields['senha'] = _userPasswordController.text;

        // Adiciona a imagem, se existir
        if (_imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath('foto', _imageFile!.path));
        }

        // Envia a requisição
        var response = await request.send();

        // Verifica a resposta
        if (response.statusCode == 200) {
          var responseData = await http.Response.fromStream(response);
          var jsonResponse = jsonDecode(responseData.body);
          print("Cadastro realizado com sucesso: $jsonResponse");
        } else {
          print("Erro ao solicitar cadastro: ${response.statusCode}");
        }
      } catch (error) {
        print("Erro na requisição: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Voltar"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showAvatarOptions(context),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        ),
                        if (_imageFile == null) 
                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey[700], 
                            size: 32, 
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Campo R.A.
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
                      style: TextStyle(fontSize: 20),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Campo Senha
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
                      style: TextStyle(fontSize: 20),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Campo Confirmar Senha
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Confirmar Senha",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      controller: _confirmUserPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      keyboardType: TextInputType.text,
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Confirmar Senha",
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
                        suffixIcon: _confirmPasswordFocusNode.hasFocus
                            ? Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: IconButton(
                                  icon: Icon(
                                    _confirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _confirmPasswordVisible =
                                          !_confirmPasswordVisible;
                                    });
                                  },
                                ),
                              )
                            : null,
                      ),
                      style: TextStyle(fontSize: 20),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Botão "Solicitar Cadastro"
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _isFormValid() ? Color.fromARGB(255, 18, 129, 68) : Color.fromARGB(135, 84, 118, 99),
                      ),
                      child: TextButton(
                        child: Text(
                          "Solicitar Cadastro",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: _solicitarCadastro, // Chama o método de requisição
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
