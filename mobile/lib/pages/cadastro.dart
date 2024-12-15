import 'dart:convert';  // Para codificar a imagem em base64
import 'dart:io';  // Para o File
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_mobile/components/footer.dart';
import 'package:wallet_mobile/dto/dto_aluno_foto.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/login.dart';
import 'package:wallet_mobile/service/aluno_service.dart';
import 'package:image/image.dart' as img;

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  


  bool _isFormValid() {
    return _imageFile != null; // Verifica se a imagem foi anexada.
  }

  @override
  void dispose() {
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
                  pick(ImageSource.camera); // Permite tirar uma foto.
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Remover foto"),
                onTap: () {
                  Navigator.of(context).pop();
                  _removeImage(); // Remove a foto existente.
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onButtonPressed() {
    _sendImageToServer().then((_) {
      // Navega para a página de solicitação de cadastro
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }).catchError((error) {
      print("Erro: $error");
    });
  }


Future<void> _sendImageToServer() async {
 
    var url = Uri.parse('http://192.168.6.215:8080/cronos/rest/service/solicitacao-carteirinha');
    var headers = {'Content-Type': 'application/json; charset=UTF-8'};
 

   // Recupera os dados do aluno
   // Future<DtoalunoLogin?> dadosAlunoFuture = AlunoService.recuperarAlunoSalvo();
    //DtoalunoLogin? dadosAluno = await dadosAlunoFuture; 
    String ra = "20240006665";
    // if (dadosAluno != null && dadosAluno.ra != null) {
    //   ra = dadosAluno.ra;
    //   print("RA ALUNO: " + ra);
    // } else {
    //   print("ERRO AO CARREGAR RA SALVO LOCALMENTE NO CADASTRO DA IMAGEM DO USUÁRIO");
    //   return;
    // }
    print("IMAGE FILE: ${_imageFile}");
   
    if (_imageFile != null) {
        File imageFilePath = File(_imageFile!.path);
        List<int> imageBytes = await imageFilePath.readAsBytes();
        if (imageBytes.isEmpty) {
          print("Erro: arquivo vazio ou não pôde ser lido.");
          return;
        }

      // Codificar diretamente em Base64
      String base64Image = base64Encode(imageBytes);
      print("BASE64: $base64Image");

      var dto = DtoAlunoFoto(ra, base64Image);
      var body = jsonEncode(dto);

      // Envio ao servidor
      var response = await http.post(url, headers: headers, body: body);
      print("RESPONSE: ${response.statusCode}");
        print("Resposta do servidor: ${response.body}");
        if (response.statusCode == 200) {
          print("Imagem enviada com sucesso.");
        } else {
          print("Erro ao enviar imagem: ${response.statusCode}");
          print("Resposta do servidor: ${response.body}");
        }
      } else {
        print("Nenhuma imagem selecionada.");
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
                          offset: Offset(34, 0),
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
                        onPressed: _isFormValid() ? _onButtonPressed : null, 
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
