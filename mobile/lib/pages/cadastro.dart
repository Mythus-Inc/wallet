import 'dart:io';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_mobile/components/footer.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/login.dart';

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
        title: Center( 
          child: Text("Adicionar foto"),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
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

void _onButtonPressed() {
  requisicaoDeAcessoCronos(DtoalunoLogin(ra: _raController.text)).then((_) {
    print("Requisição concluída.");
  }).catchError((error) {
    print("Erro: $error");
  });
}

Future<void> requisicaoDeAcessoCronos(DtoalunoLogin dto) async{
    Map<String, dynamic> corpoRequisicao =  dto.toJson();
    String jsonBody = jsonEncode(corpoRequisicao);
    try{
      var url = Uri.parse('http://192.168.34.215:8080/cronos/rest/service/solicitacao-carteirinha');
      var chamdaBackEnd = await http.post(
        url, // aqui deve ser passada a url do cronos !!
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );
       if (chamdaBackEnd.statusCode == 200) {
          _showSuccessDialog();
          print("Requisição efetuada com sucesso");
        } else {
          print("Requisição falhou");
        }
    }catch(Exception){
      throw Exception;
    }
    

   
  }

/*
  // Função para enviar os dados para o servidor
  void _requestRegistration() async {
  if (_isFormValid()) {
    try {
      // Prepara os dados para envio
      var uri = Uri.parse('http://192.168.0.101:8080/cronos/rest/service/solicitacao-carteirinha'); // Substituir pelo endpoint real
      var request = http.MultipartRequest('POST', uri);

      // Adiciona RA e Senha
      request.fields['ra'] = _raController.text;
      request.fields['senha'] = _userPasswordController.text;

      // Adiciona a imagem, se existir
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('foto', _imageFile!.path));
      }

      _showSuccessDialog();
      

      // Envia a requisição
      var response = await request.send();

      // Verifica a resposta
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
         var jsonResponse = jsonDecode(responseData.body);
         print("Cadastro realizado com sucesso: $jsonResponse");

          //Exibe a caixa de diálogo de sucesso
         _showSuccessDialog();
       } else {
         print("Erro ao solicitar cadastro: ${response.statusCode}");
       }


    } catch (error) {
      print("Erro na requisição: $error");
    }
  }
}*/

void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text("Solicitação de cadastro efetuada com sucesso!"),
        ),
        actions: <Widget>[
          Center( 
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 18, 129, 68), 
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), 
                ),
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18, 
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); 
              },
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Voltar"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset("assets/app/ifprlogo.png"),
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => _showAvatarOptions(context),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        ),
                        if (_imageFile == null) 
                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey[700], 
                            size: 55, 
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Expanded(
                      child: Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 1.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(height: 20),
                        Text(
                          "•Tire uma foto do próprio rosto de costas a uma parede branca;\n\n" 
                          "•Retire quaisquer acessórios, como óculos ou chapéu.",
                          style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(238, 0, 0, 0),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        ],
                      ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(34, 0), // Mova 50 pixels para a direita, se necessário
                      child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Image.asset("assets/app/selfie.png"),
                      ),
                      ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
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
                        onPressed: _onButtonPressed,  
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
